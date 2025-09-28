#!/bin/bash

# This script checks and updates FCM tokens for users in your Firestore database

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Display banner
echo -e "${BLUE}"
echo "=================================================="
echo "=       FCM Token Verification Script            ="
echo "=       NAYBRZ DXB Firebase Edition              ="
echo "=================================================="
echo -e "${NC}"

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo -e "${RED}Firebase CLI not found. Please install it with:${NC}"
    echo -e "npm install -g firebase-tools"
    exit 1
fi

echo -e "${YELLOW}This script will check if users have FCM tokens stored in Firestore.${NC}"
echo -e "${YELLOW}It can also help diagnose notification delivery issues.${NC}"
echo ""

# Check if user is logged in to Firebase
echo -e "${BLUE}Checking Firebase login status...${NC}"
FIREBASE_USER=$(firebase projects:list --json | jq -r '.result[0].projectId')

if [ -z "$FIREBASE_USER" ]; then
    echo -e "${RED}Not logged in to Firebase. Please run:${NC}"
    echo -e "firebase login"
    exit 1
fi

echo -e "${GREEN}Logged in to Firebase. Proceeding...${NC}"
echo ""

# Function to check and update specific user
check_user() {
    local user_id=$1
    
    echo -e "${BLUE}Checking FCM token for user: ${user_id}${NC}"
    
    # Get user data from Firestore
    firebase firestore:get --pretty users/${user_id} > /tmp/user_data.json
    
    # Check if fcmToken exists
    FCM_TOKEN=$(cat /tmp/user_data.json | grep -o '"fcmToken": "[^"]*"' | cut -d'"' -f4)
    
    if [ -z "$FCM_TOKEN" ]; then
        echo -e "${RED}FCM token not found for user: ${user_id}${NC}"
        echo -e "${YELLOW}This user will not receive push notifications.${NC}"
        echo -e "${YELLOW}Make sure the user logs in to the app again to register a new token.${NC}"
    else
        echo -e "${GREEN}FCM token found for user: ${user_id}${NC}"
        echo -e "Token: ${FCM_TOKEN:0:15}... (truncated for security)"
        
        # Check when token was last updated
        TOKEN_UPDATED=$(cat /tmp/user_data.json | grep -o '"tokenUpdatedAt": {[^}]*}' || echo "Not found")
        
        if [ "$TOKEN_UPDATED" == "Not found" ]; then
            echo -e "${YELLOW}Token update timestamp not found. Token might be outdated.${NC}"
        else
            echo -e "${GREEN}Token was last updated at: ${TOKEN_UPDATED}${NC}"
        fi
    fi
    
    echo ""
}

# Function to send test notification to user
send_test_notification() {
    local user_id=$1
    
    echo -e "${BLUE}Sending test notification to user: ${user_id}${NC}"
    
    # Call the Cloud Function
    firebase functions:call sendNotificationToUser --data "{\"userId\":\"$user_id\",\"title\":\"FCM Token Test\",\"body\":\"This is a test notification to verify your FCM token is working\"}"
    
    echo -e "${GREEN}Test notification sent. Check the device to see if it was received.${NC}"
    echo ""
}

# Check all users option
check_all_users() {
    echo -e "${BLUE}Fetching all users from Firestore...${NC}"
    
    # Get all user IDs
    firebase firestore:get --shallow users > /tmp/users_list.json
    
    # Extract user IDs
    USER_IDS=$(cat /tmp/users_list.json | jq -r 'keys[]')
    
    # Count users
    USER_COUNT=$(echo "$USER_IDS" | wc -l)
    echo -e "${GREEN}Found ${USER_COUNT} users in Firestore.${NC}"
    
    # Check tokens
    USERS_WITH_TOKEN=0
    USERS_WITHOUT_TOKEN=0
    
    for user_id in $USER_IDS; do
        firebase firestore:get --pretty users/${user_id} > /tmp/user_data.json
        FCM_TOKEN=$(cat /tmp/user_data.json | grep -o '"fcmToken": "[^"]*"' | cut -d'"' -f4)
        
        if [ -z "$FCM_TOKEN" ]; then
            ((USERS_WITHOUT_TOKEN++))
        else
            ((USERS_WITH_TOKEN++))
        fi
    done
    
    echo -e "${GREEN}Users with FCM token: ${USERS_WITH_TOKEN}${NC}"
    echo -e "${RED}Users without FCM token: ${USERS_WITHOUT_TOKEN}${NC}"
    
    if [ $USERS_WITHOUT_TOKEN -gt 0 ]; then
        PERCENT=$(( (USERS_WITHOUT_TOKEN * 100) / USER_COUNT ))
        echo -e "${YELLOW}${PERCENT}% of users will not receive push notifications.${NC}"
    fi
    
    echo ""
}

# Main menu
echo -e "${BLUE}Select an option:${NC}"
echo "1. Check FCM token for a specific user"
echo "2. Send test notification to a specific user"
echo "3. Check statistics for all users"
echo "4. Exit"
echo ""
read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        read -p "Enter the user ID: " user_id
        check_user "$user_id"
        ;;
    2)
        read -p "Enter the user ID: " user_id
        send_test_notification "$user_id"
        ;;
    3)
        check_all_users
        ;;
    4)
        echo -e "${GREEN}Exiting.${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid choice.${NC}"
        exit 1
        ;;
esac

echo -e "${BLUE}===================${NC}"
echo -e "${GREEN}Script completed.${NC}"
echo -e "${YELLOW}If you're experiencing notification issues, make sure:${NC}"
echo "1. Users have active FCM tokens in Firestore"
echo "2. The Firebase Cloud Functions are properly deployed"
echo "3. The app has notification permissions granted on the device"
echo "4. APNs certificates are properly configured for iOS"
echo -e "${BLUE}===================${NC}"
