#!/bin/bash
# Script to send a test FCM notification to a user
# Usage: ./send_user_notification.sh USER_ID "Notification Title" "Notification Body"

# Set color variables
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print script header
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}       NAYBRZ DXB - User Notification Sender            ${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo ""

# Check service account file
if [ ! -f "tools/firebase-service-account.json" ]; then
  echo -e "${RED}❌ Error: Firebase service account file not found${NC}"
  echo -e "${YELLOW}Please follow the instructions in tools/FIREBASE_CREDENTIALS_GUIDE.md${NC}"
  exit 1
fi

# Check if placeholder service account is being used
if grep -q "your-firebase-project-id" "tools/firebase-service-account.json"; then
  echo -e "${RED}❌ Error: You're using the placeholder service account file${NC}"
  echo -e "${YELLOW}Please follow the instructions in tools/FIREBASE_CREDENTIALS_GUIDE.md${NC}"
  exit 1
fi

# Check if user ID is provided
if [ -z "$1" ]; then
  echo -e "${YELLOW}No USER_ID provided. Would you like to:${NC}"
  echo "1) List available users to choose from"
  echo "2) Enter a user ID manually"
  echo "3) Exit"
  read -p "Enter your choice (1-3): " choice
  
  case $choice in
    1)
      echo -e "${BLUE}Fetching users from Firestore...${NC}"
      # Check if Firebase CLI is installed
      if ! command -v firebase &> /dev/null; then
        echo -e "${RED}❌ Error: Firebase CLI is not installed${NC}"
        echo -e "${YELLOW}Please install it using: npm install -g firebase-tools${NC}"
        exit 1
      fi
      
      # Attempt to list users with FCM tokens
      echo -e "${YELLOW}This may take a moment...${NC}"
      USERS=$(firebase firestore:get --project naybrzdbx users --limit=10 2>/dev/null)
      
      if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Error: Could not fetch users from Firestore${NC}"
        echo -e "${YELLOW}Make sure you're logged in with Firebase CLI: firebase login${NC}"
        exit 1
      fi
      
      echo -e "${GREEN}Available users:${NC}"
      echo "$USERS" | grep -E "id:|displayName:|email:" | sed -E 's/.*id: "([^"]+)".*/User ID: \1/g; s/.*displayName: "([^"]+)".*/Name: \1/g; s/.*email: "([^"]+)".*/Email: \1\n/g'
      
      read -p "Enter user ID from the list: " USER_ID
      if [ -z "$USER_ID" ]; then
        echo -e "${RED}❌ No user ID entered. Exiting.${NC}"
        exit 1
      fi
      ;;
    2)
      read -p "Enter the user ID: " USER_ID
      if [ -z "$USER_ID" ]; then
        echo -e "${RED}❌ No user ID entered. Exiting.${NC}"
        exit 1
      fi
      ;;
    *)
      echo -e "${YELLOW}Exiting.${NC}"
      exit 0
      ;;
  esac
else
  USER_ID="$1"
fi

# Get notification content
if [ -z "$2" ]; then
  read -p "Enter notification title (or press enter for default): " CUSTOM_TITLE
  TITLE="${CUSTOM_TITLE:-NAYBRZ DXB Notification}"
else
  TITLE="$2"
fi

if [ -z "$3" ]; then
  read -p "Enter notification body (or press enter for default): " CUSTOM_BODY
  BODY="${CUSTOM_BODY:-This is a test notification from NAYBRZ DXB}"
else
  BODY="$3"
fi

# Check if Firebase CLI is installed (if we need it)
if [[ "$USER_ID" == "list" ]]; then
  if ! command -v firebase &> /dev/null; then
    echo -e "${RED}❌ Error: Firebase CLI is not installed${NC}"
    echo -e "${YELLOW}Please install it using: npm install -g firebase-tools${NC}"
    exit 1
  fi
fi

echo -e "${BLUE}🔍 Fetching FCM token for user ${YELLOW}$USER_ID${NC}..."

# Get the user's FCM token from Firestore
TOKEN=$(firebase firestore:get --project naybrzdbx users/$USER_ID | grep fcmToken | cut -d'"' -f4 2>/dev/null)

if [ -z "$TOKEN" ]; then
  echo -e "${RED}❌ Error: Could not find FCM token for user $USER_ID${NC}"
  echo -e "${YELLOW}Make sure the user exists and has an FCM token saved in Firestore${NC}"
  echo -e "${YELLOW}The user must have opened the app at least once to generate an FCM token${NC}"
  exit 1
fi

TOKEN_PREVIEW="${TOKEN:0:10}...${TOKEN: -10}"
echo -e "${GREEN}✅ Found FCM token: $TOKEN_PREVIEW${NC}"
echo -e "${BLUE}📝 Notification details:${NC}"
echo -e "   ${YELLOW}Title:${NC} \"$TITLE\""
echo -e "   ${YELLOW}Body:${NC} \"$BODY\""
echo ""

# Confirm before sending
read -p "Send this notification? (y/n): " CONFIRM
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  echo -e "${YELLOW}Notification sending cancelled.${NC}"
  exit 0
fi

echo -e "${BLUE}📤 Sending notification...${NC}"

# Call the Node.js script to send the notification
node tools/send_fcm_notification.js "$TOKEN" "$TITLE" "$BODY"

# Check if the notification was sent successfully
if [ $? -eq 0 ]; then
  echo -e "${GREEN}✅ Notification sent successfully!${NC}"
  echo -e "${YELLOW}Note: If the user doesn't receive the notification, check:${NC}"
  echo -e "  - User has notification permissions enabled"
  echo -e "  - Device is not in Do Not Disturb mode"
  echo -e "  - App is not in battery optimization"
else
  echo -e "${RED}❌ Failed to send notification.${NC}"
  echo -e "${YELLOW}Check the error message above for details.${NC}"
fi
