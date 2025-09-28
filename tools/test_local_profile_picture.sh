#!/bin/bash

# Test Local Notifications with Profile Pictures
# This script helps test the display of profile pictures in local notifications

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Display banner
echo -e "${BLUE}"
echo "=================================================="
echo "=   Local Notification Profile Picture Test      ="
echo "=                NAYBRZ DXB                      ="
echo "=================================================="
echo -e "${NC}"

# Default profile picture URL
DEFAULT_PROFILE_PIC="https://randomuser.me/api/portraits/men/1.jpg"

# Get profile picture URL (optional)
if [ -z "$1" ]; then
    PROFILE_PIC_URL=$DEFAULT_PROFILE_PIC
    echo -e "${YELLOW}Using default profile picture URL${NC}"
else
    PROFILE_PIC_URL=$1
fi

echo -e "${BLUE}Profile Picture URL: ${GREEN}$PROFILE_PIC_URL${NC}"

# Check if adb is installed (for Android testing)
if command -v adb &> /dev/null; then
    echo -e "${GREEN}ADB found - can send test command to Android device${NC}"
    
    # Check if device is connected
    if adb devices | grep -q "device$"; then
        echo -e "${GREEN}Android device connected${NC}"
        echo -e "${BLUE}Sending test notification command to app...${NC}"
        
        # Convert the URL to be suitable for adb shell command
        ENCODED_URL=$(echo $PROFILE_PIC_URL | sed 's/:/\\:/g' | sed 's/\//\\\//g' | sed 's/\./\\./g' | sed 's/-/\\-/g' | sed 's/_/\\_/g')
        
        # Use adb to trigger the test notification in the app
        adb shell am broadcast -a "com.naybrzdbx.TEST_NOTIFICATION" --es "profilePicUrl" "$ENCODED_URL"
        
        echo -e "${GREEN}Test notification request sent to Android device${NC}"
    else
        echo -e "${YELLOW}No Android device connected${NC}"
    fi
else
    echo -e "${YELLOW}ADB not found. Cannot send direct command to Android device.${NC}"
fi

echo -e "\n${BLUE}Alternative method:${NC}"
echo -e "${YELLOW}To test profile picture notifications manually:${NC}"
echo -e "1. Open the NAYBRZ DXB app"
echo -e "2. Navigate to profile or settings"
echo -e "3. Find and tap 'Test Notifications' option"
echo -e "4. Select 'Test Profile Picture Notification'${NC}"

echo -e "\n${BLUE}Done.${NC}"
