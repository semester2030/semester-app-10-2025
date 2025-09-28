#!/bin/bash

# FCM v1 API Profile Picture Notification Test Tool
# This script tests the notification with profile picture functionality

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Display banner
echo -e "${BLUE}"
echo "=================================================="
echo "=  FCM v1 API Profile Picture Notification Test   ="
echo "=       NAYBRZ DXB Small Avatar Style Edition     ="
echo "=================================================="
echo -e "${NC}"

# Check for user ID parameter
if [ -z "$1" ]; then
    echo -e "${RED}Error: Receiver user ID is required${NC}"
    echo -e "Usage: $0 <receiver_user_id> [sender_name] [profile_picture_url]"
    exit 1
fi

RECEIVER_USER_ID=$1

# Get sender name (optional)
if [ -z "$2" ]; then
    SENDER_NAME="Test User"
else
    SENDER_NAME=$2
fi

# Get profile picture URL (optional)
if [ -z "$3" ]; then
    # Default test profile picture
    PROFILE_PIC_URL="https://randomuser.me/api/portraits/men/1.jpg"
else
    PROFILE_PIC_URL=$3
fi

echo -e "${BLUE}Preparing to send notification:${NC}"
echo -e "Receiver User ID: ${GREEN}$RECEIVER_USER_ID${NC}"
echo -e "Sender Name: ${GREEN}$SENDER_NAME${NC}"
echo -e "Profile Picture URL: ${GREEN}$PROFILE_PIC_URL${NC}"

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo -e "${RED}Firebase CLI not found. Please install it with:${NC}"
    echo -e "npm install -g firebase-tools"
    exit 1
fi

# Call the Cloud Function
echo -e "${BLUE}Calling Cloud Function to send notification with profile picture...${NC}"

# Create a temp JSON file with the request payload
cat > /tmp/notification_request.json << EOF
{
  "userId": "$RECEIVER_USER_ID",
  "title": "$SENDER_NAME sent you a message",
  "body": "Hello! This is a test message with profile picture.",
  "imageUrl": "$PROFILE_PIC_URL",
  "data": {
    "route": "/chatting",
    "threadId": "test_thread_${RANDOM}",
    "otherUserId": "test_sender_${RANDOM}",
    "senderName": "$SENDER_NAME",
    "senderProfileUrl": "$PROFILE_PIC_URL"
  }
}
EOF

# Call Firebase function with the JSON payload
firebase functions:call sendNotificationToUser --data-file /tmp/notification_request.json

echo -e "\n${GREEN}Test notification with profile picture sent!${NC}"
echo -e "${YELLOW}Check the device to see if the profile picture appears in the notification.${NC}"
echo -e "${YELLOW}Note: Some devices may not display images in notifications due to system limitations.${NC}"
echo -e "\n${BLUE}Done.${NC}"

# Cleanup
rm /tmp/notification_request.json
