#!/bin/zsh

# Get FCM Token Demo Script
# This script demonstrates how to retrieve a user's FCM token from Firestore
# and send a test notification using the Firebase Admin SDK.

# Display header
echo "\033[1;34m================================================\033[0m"
echo "\033[1;34m   NAYBRZ DXB FCM Token and Notification Demo   \033[0m"
echo "\033[1;34m================================================\033[0m"

# Check if Firebase CLI is logged in
firebase projects:list &>/dev/null
if [ $? -ne 0 ]; then
  echo "\033[1;31m❌ Error: You are not logged in to Firebase CLI\033[0m"
  echo "Please log in first with: firebase login"
  exit 1
fi

# Get a list of users from Firestore
echo "\033[1;33m🔍 Fetching users from Firestore...\033[0m"
USERS=$(firebase firestore:get --project naybrzdbx users --limit=5 2>/dev/null)

# Check if we got user data
if [ -z "$USERS" ]; then
  echo "\033[1;31m❌ Error: Could not retrieve users from Firestore\033[0m"
  echo "Make sure your Firebase project is properly configured and you have permission to access Firestore"
  exit 1
fi

# Extract user IDs
USER_IDS=($(echo "$USERS" | grep "_path" | cut -d'"' -f4))

# Display the first few users
echo "\033[1;32m✅ Found ${#USER_IDS[@]} users\033[0m"
echo "\033[1;33m📋 User IDs:\033[0m"

for i in {1..5}; do
  if [ $i -le ${#USER_IDS[@]} ]; then
    echo "   $i. ${USER_IDS[$i-1]}"
  fi
done

# Prompt for user selection
echo ""
echo "\033[1;36m👉 Enter the number of the user to check FCM token (or any other number to exit):\033[0m"
read USER_NUM

if [[ "$USER_NUM" =~ ^[0-9]+$ ]] && [ "$USER_NUM" -ge 1 ] && [ "$USER_NUM" -le ${#USER_IDS[@]} ]; then
  SELECTED_USER_ID=${USER_IDS[$USER_NUM-1]}
  
  echo "\033[1;33m🔍 Fetching FCM token for user $SELECTED_USER_ID...\033[0m"
  
  # Get the specific user document
  USER_DATA=$(firebase firestore:get --project naybrzdbx users/$SELECTED_USER_ID 2>/dev/null)
  FCM_TOKEN=$(echo "$USER_DATA" | grep "fcmToken" | cut -d'"' -f4)
  
  if [ -z "$FCM_TOKEN" ]; then
    echo "\033[1;31m❌ No FCM token found for this user\033[0m"
    echo "The user might not have opened the app recently or allowed notifications"
  else
    echo "\033[1;32m✅ FCM Token found:\033[0m"
    echo "${FCM_TOKEN:0:20}...${FCM_TOKEN: -20}"
    
    # Prompt to send a test notification
    echo ""
    echo "\033[1;36m🔔 Do you want to send a test notification to this user? (y/n)\033[0m"
    read SEND_NOTIFICATION
    
    if [[ "$SEND_NOTIFICATION" == "y" || "$SEND_NOTIFICATION" == "Y" ]]; then
      echo "\033[1;36m📝 Enter notification title (or press Enter for default):\033[0m"
      read NOTIFICATION_TITLE
      NOTIFICATION_TITLE=${NOTIFICATION_TITLE:-"Test from NAYBRZ DXB"}
      
      echo "\033[1;36m📝 Enter notification body (or press Enter for default):\033[0m"
      read NOTIFICATION_BODY
      NOTIFICATION_BODY=${NOTIFICATION_BODY:-"This is a test notification sent on $(date '+%Y-%m-%d %H:%M:%S')"}
      
      echo "\033[1;33m📤 Sending notification...\033[0m"
      
      # Call the send_fcm_notification.js script
      node tools/send_fcm_notification.js "$FCM_TOKEN" "$NOTIFICATION_TITLE" "$NOTIFICATION_BODY"
    else
      echo "\033[1;33m🛑 Notification sending canceled\033[0m"
    fi
  fi
else
  echo "\033[1;33m🛑 User selection canceled\033[0m"
fi

echo ""
echo "\033[1;34m================================================\033[0m"
echo "\033[1;34m                Demo Completed                  \033[0m"
echo "\033[1;34m================================================\033[0m"
