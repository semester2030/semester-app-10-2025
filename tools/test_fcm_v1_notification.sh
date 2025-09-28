#!/bin/bash

# FCM v1 API Notification Tester
# This script demonstrates how to use Firebase Cloud Functions to send notifications

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Display banner
echo -e "${BLUE}"
echo "=================================================="
echo "=       FCM v1 API Notification Tester           ="
echo "=       NAYBRZ DXB Cloud Functions Edition       ="
echo "=================================================="
echo -e "${NC}"

# Default values
DEFAULT_TITLE="Test Notification"
DEFAULT_BODY="This is a test notification from NAYBRZ DXB"

# Check for user ID parameter
if [ -z "$1" ]; then
    echo -e "${YELLOW}No user ID provided. Will use test mode.${NC}"
    TEST_MODE=true
else
    USER_ID=$1
    TEST_MODE=false
fi

# Get title (optional)
if [ -z "$2" ]; then
    TITLE=$DEFAULT_TITLE
else
    TITLE=$2
fi

# Get body (optional)
if [ -z "$3" ]; then
    BODY=$DEFAULT_BODY
else
    BODY=$3
fi

echo -e "${BLUE}Preparing to send notification:${NC}"
echo -e "Title: ${GREEN}$TITLE${NC}"
echo -e "Body: ${GREEN}$BODY${NC}"

if [ "$TEST_MODE" = true ]; then
    echo -e "${YELLOW}Using test mode (no user ID provided)${NC}"
    echo -e "This will call the test function directly in the app"
    
    # Instructions for testing
    echo -e "\n${BLUE}To test notifications:${NC}"
    echo -e "1. Go to the Notification Settings screen in the app"
    echo -e "2. Press the 'Send Test Notification' button"
    echo -e "3. The notification should appear shortly"
    echo -e "\n${YELLOW}Note: This method uses the local app logic to generate a notification.${NC}"
else
    echo -e "User ID: ${GREEN}$USER_ID${NC}"
    
    # Check if Firebase CLI is installed
    if ! command -v firebase &> /dev/null; then
        echo -e "${RED}Firebase CLI not found. Please install it with:${NC}"
        echo -e "npm install -g firebase-tools"
        exit 1
    fi
    
    # Call the Cloud Function
    echo -e "${BLUE}Calling Cloud Function to send notification...${NC}"
    firebase functions:call sendNotificationToUser --data "{\"userId\":\"$USER_ID\",\"title\":\"$TITLE\",\"body\":\"$BODY\"}"
    
    echo -e "\n${GREEN}Request sent! If the user has a valid FCM token, they should receive the notification shortly.${NC}"
    echo -e "${YELLOW}Note: Check Firebase Functions logs in the Firebase Console for any issues.${NC}"
fi

echo -e "\n${BLUE}Done.${NC}"
