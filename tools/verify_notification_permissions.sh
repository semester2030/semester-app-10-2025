// This shell script can be used to make the mobile device permission necessary
// to display profile pictures in notifications

#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Display banner
echo -e "${BLUE}"
echo "=================================================="
echo "=  Verify Notification Image Permissions Helper   ="
echo "=                 NAYBRZ DXB                      ="
echo "=================================================="
echo -e "${NC}"

# Function to check Android notification permission
check_android_notification_permission() {
    echo -e "${BLUE}Checking Android notification permissions...${NC}"
    
    if command -v adb &> /dev/null; then
        # Check if any device is connected
        if adb devices | grep -q "device$"; then
            echo -e "${GREEN}Android device connected${NC}"
            
            # Get the package name
            PACKAGE_NAME="com.naybrzdbx"
            
            # Check notification permission
            NOTIFICATION_PERMISSION=$(adb shell dumpsys package $PACKAGE_NAME | grep -E "android.permission.POST_NOTIFICATIONS: granted|com.android.settings.permission.NOTIFICATION_ACCESS: granted")
            
            if [[ -n "$NOTIFICATION_PERMISSION" ]]; then
                echo -e "${GREEN}Notification permission is granted!${NC}"
            else
                echo -e "${YELLOW}Notification permission might not be granted.${NC}"
                echo -e "Please make sure to grant notification permission to the app in Settings."
            fi
            
            # Check if notification channels are set up correctly
            NOTIFICATION_CHANNELS=$(adb shell cmd notification list | grep -E "$PACKAGE_NAME/high_importance_channel")
            
            if [[ -n "$NOTIFICATION_CHANNELS" ]]; then
                echo -e "${GREEN}High importance notification channel is set up correctly!${NC}"
            else
                echo -e "${YELLOW}High importance notification channel might not be set up correctly.${NC}"
            fi
        else
            echo -e "${YELLOW}No Android device connected. Please connect a device and try again.${NC}"
        fi
    else
        echo -e "${YELLOW}ADB not found. Cannot check Android notification permissions.${NC}"
        echo -e "You can install ADB from Android SDK Platform Tools."
    fi
}

# Function to check iOS notification permission
check_ios_notification_permission() {
    echo -e "${BLUE}iOS notification permission check:${NC}"
    echo -e "${YELLOW}iOS notification permissions can only be checked within the app itself.${NC}"
    echo -e "Please make sure you have granted notification permissions to the app in iOS Settings."
    echo -e "For profile pictures in notifications, ensure your app has 'mutable-content' capability."
}

# Main execution
echo -e "${BLUE}This tool helps verify that your device permissions are correctly set up${NC}"
echo -e "${BLUE}for displaying profile pictures in notifications.${NC}"
echo

# Check OS-specific permissions
if [ -n "$(adb devices 2>/dev/null | grep -v "List of devices" | grep "device$")" ]; then
    check_android_notification_permission
else
    echo -e "${YELLOW}No Android device detected. Assuming iOS device.${NC}"
    check_ios_notification_permission
fi

echo
echo -e "${BLUE}Manual verification steps:${NC}"
echo -e "1. Open your app and navigate to the notification test screen"
echo -e "2. Send a test notification with profile picture"
echo -e "3. Check if the notification shows the profile picture"
echo -e "4. If not, check your device settings:"
echo -e "   - Android: Settings > Apps > NAYBRZ DXB > Notifications"
echo -e "   - iOS: Settings > NAYBRZ DXB > Notifications"

echo
echo -e "${GREEN}Done.${NC}"
