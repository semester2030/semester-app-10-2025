#!/bin/bash
# NAYBRZ DXB Notification Testing Suite
# This script provides a comprehensive toolkit for testing notifications

# Set color variables
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Print welcome header
clear
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}       NAYBRZ DXB - Notification Testing Suite          ${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo ""

# Check if we're in the right directory
if [ ! -f "tools/send_fcm_notification.js" ]; then
    echo -e "${RED}❌ Error: Please run this script from the project root directory${NC}"
    echo -e "${YELLOW}Example: ./tools/test_notifications.sh${NC}"
    exit 1
fi

# Check if node.js is installed
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Error: Node.js is not installed${NC}"
    echo -e "${YELLOW}Please install Node.js to use this script${NC}"
    exit 1
fi

# Check if firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo -e "${YELLOW}⚠️ Warning: Firebase CLI is not installed${NC}"
    echo -e "${YELLOW}Some features of this script may not work without it${NC}"
    echo -e "${YELLOW}Install with: npm install -g firebase-tools${NC}"
    echo ""
fi

# Check if service account file exists
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

# Main menu function
show_main_menu() {
    echo -e "${CYAN}Choose an option:${NC}"
    echo -e "${YELLOW}1)${NC} Send notification to a specific user"
    echo -e "${YELLOW}2)${NC} Send notification to a specific device (using FCM token)"
    echo -e "${YELLOW}3)${NC} List available users"
    echo -e "${YELLOW}4)${NC} Search for a user by email"
    echo -e "${YELLOW}5)${NC} Validate notification icons"
    echo -e "${YELLOW}6)${NC} Show help and documentation"
    echo -e "${YELLOW}0)${NC} Exit"
    echo ""
    read -p "Enter your choice (0-6): " choice
    
    case $choice in
        1) send_to_user ;;
        2) send_to_device ;;
        3) list_users ;;
        4) search_user ;;
        5) validate_icons ;;
        6) show_help ;;
        0) exit_script ;;
        *) 
            echo -e "${RED}Invalid option. Please try again.${NC}"
            show_main_menu
            ;;
    esac
}

# Send to a specific user
send_to_user() {
    echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}        Send Notification to a Specific User            ${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
    echo ""
    
    read -p "Enter user ID (or type 'list' to see users): " USER_ID
    
    if [ "$USER_ID" == "list" ]; then
        list_users
        return
    fi
    
    if [ -z "$USER_ID" ]; then
        echo -e "${RED}❌ No user ID provided. Returning to main menu.${NC}"
        show_main_menu
        return
    fi
    
    read -p "Enter notification title (or press enter for default): " TITLE
    TITLE="${TITLE:-NAYBRZ DXB Notification}"
    
    read -p "Enter notification body (or press enter for default): " BODY
    BODY="${BODY:-This is a test notification from NAYBRZ DXB}"
    
    echo -e "${BLUE}🔍 Fetching FCM token for user ${YELLOW}$USER_ID${NC}..."
    
    # Get the user's FCM token from Firestore
    TOKEN=$(firebase firestore:get --project naybrzdbx users/$USER_ID | grep fcmToken | cut -d'"' -f4 2>/dev/null)
    
    if [ -z "$TOKEN" ]; then
        echo -e "${RED}❌ Error: Could not find FCM token for user $USER_ID${NC}"
        echo -e "${YELLOW}Make sure the user exists and has an FCM token saved in Firestore${NC}"
        
        read -p "Press enter to continue..." dummy
        show_main_menu
        return
    fi
    
    TOKEN_PREVIEW="${TOKEN:0:10}...${TOKEN: -10}"
    echo -e "${GREEN}✅ Found FCM token: $TOKEN_PREVIEW${NC}"
    echo -e "${BLUE}📝 Notification details:${NC}"
    echo -e "   ${YELLOW}Title:${NC} \"$TITLE\""
    echo -e "   ${YELLOW}Body:${NC} \"$BODY\""
    echo ""
    
    read -p "Send this notification? (y/n): " CONFIRM
    if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
        echo -e "${YELLOW}Notification sending cancelled.${NC}"
        read -p "Press enter to continue..." dummy
        show_main_menu
        return
    fi
    
    echo -e "${BLUE}📤 Sending notification...${NC}"
    
    # Call the Node.js script to send the notification
    node tools/send_fcm_notification.js "$TOKEN" "$TITLE" "$BODY"
    
    read -p "Press enter to continue..." dummy
    show_main_menu
}

# Send to a specific device using FCM token
send_to_device() {
    echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}        Send Notification to a Specific Device          ${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
    echo ""
    
    # Check if we've saved a token before
    TOKEN_FILE="$(pwd)/fcm_token.txt"
    DEVICE_TOKEN=""

    if [ -f "$TOKEN_FILE" ]; then
        DEVICE_TOKEN=$(cat "$TOKEN_FILE")
        echo -e "${GREEN}Found previously saved FCM token:${NC}"
        echo "$DEVICE_TOKEN"
        echo ""
        read -p "Use this token? (y/n): " USE_SAVED_TOKEN
        
        if [[ "$USE_SAVED_TOKEN" != "y" && "$USE_SAVED_TOKEN" != "Y" ]]; then
            DEVICE_TOKEN=""
        fi
    fi
    
    # If we don't have a token yet, ask for one
    if [ -z "$DEVICE_TOKEN" ]; then
        read -p "Enter FCM token: " DEVICE_TOKEN
        
        if [ -z "$DEVICE_TOKEN" ]; then
            echo -e "${RED}❌ No FCM token provided. Returning to main menu.${NC}"
            show_main_menu
            return
        fi
        
        # Save token for future use
        echo "$DEVICE_TOKEN" > "$TOKEN_FILE"
        echo -e "${GREEN}Token saved for future use${NC}"
    fi
    
    read -p "Enter notification title (or press enter for default): " TITLE
    TITLE="${TITLE:-NAYBRZ DXB Notification}"
    
    read -p "Enter notification body (or press enter for default): " BODY
    BODY="${BODY:-This is a test notification from NAYBRZ DXB}"
    
    echo -e "${BLUE}📝 Notification details:${NC}"
    echo -e "   ${YELLOW}Title:${NC} \"$TITLE\""
    echo -e "   ${YELLOW}Body:${NC} \"$BODY\""
    echo -e "   ${YELLOW}Token:${NC} ${DEVICE_TOKEN:0:10}...${DEVICE_TOKEN: -10}"
    echo ""
    
    read -p "Send this notification? (y/n): " CONFIRM
    if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
        echo -e "${YELLOW}Notification sending cancelled.${NC}"
        read -p "Press enter to continue..." dummy
        show_main_menu
        return
    fi
    
    echo -e "${BLUE}📤 Sending notification...${NC}"
    
    # Call the Node.js script to send the notification
    node tools/send_fcm_notification.js "$DEVICE_TOKEN" "$TITLE" "$BODY"
    
    read -p "Press enter to continue..." dummy
    show_main_menu
}

# List available users
list_users() {
    echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}               Available Users                          ${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
    echo ""
    
    # Check if Firebase CLI is installed
    if ! command -v firebase &> /dev/null; then
        echo -e "${RED}❌ Error: Firebase CLI is not installed${NC}"
        echo -e "${YELLOW}Please install it using: npm install -g firebase-tools${NC}"
        read -p "Press enter to continue..." dummy
        show_main_menu
        return
    fi
    
    # Attempt to list users with FCM tokens
    echo -e "${YELLOW}Fetching users from Firestore. This may take a moment...${NC}"
    USERS=$(firebase firestore:get --project naybrzdbx users --limit=20 2>/dev/null)
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Error: Could not fetch users from Firestore${NC}"
        echo -e "${YELLOW}Make sure you're logged in with Firebase CLI: firebase login${NC}"
        read -p "Press enter to continue..." dummy
        show_main_menu
        return
    fi
    
    echo -e "${GREEN}Available users:${NC}"
    echo "$USERS" | grep -E "id:|displayName:|email:|fcmToken:" | sed -E 's/.*id: "([^"]+)".*/User ID: \1/g; s/.*displayName: "([^"]+)".*/Name: \1/g; s/.*email: "([^"]+)".*/Email: \1/g; s/.*fcmToken: "([^"]+)".*/Token: ✅\n/g; s/.*fcmToken: null.*/Token: ❌\n/g'
    
    read -p "Press enter to continue..." dummy
    show_main_menu
}

# Search for a user by email
search_user() {
    echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}               Search for a User                        ${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
    echo ""
    
    read -p "Enter user email (or part of it): " EMAIL
    
    if [ -z "$EMAIL" ]; then
        echo -e "${RED}❌ No email provided. Returning to main menu.${NC}"
        show_main_menu
        return
    fi
    
    # Check if Firebase CLI is installed
    if ! command -v firebase &> /dev/null; then
        echo -e "${RED}❌ Error: Firebase CLI is not installed${NC}"
        echo -e "${YELLOW}Please install it using: npm install -g firebase-tools${NC}"
        read -p "Press enter to continue..." dummy
        show_main_menu
        return
    fi
    
    echo -e "${YELLOW}Searching for users with email containing \"$EMAIL\"...${NC}"
    USERS=$(firebase firestore:get --project naybrzdbx users --limit=50 2>/dev/null)
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Error: Could not fetch users from Firestore${NC}"
        echo -e "${YELLOW}Make sure you're logged in with Firebase CLI: firebase login${NC}"
        read -p "Press enter to continue..." dummy
        show_main_menu
        return
    fi
    
    # Extract and filter users based on email
    FILTERED_USERS=$(echo "$USERS" | grep -E "id:|displayName:|email:|fcmToken:" | sed -E 's/.*id: "([^"]+)".*/User ID: \1/g; s/.*displayName: "([^"]+)".*/Name: \1/g; s/.*email: "([^"]+)".*/Email: \1/g; s/.*fcmToken: "([^"]+)".*/Token: ✅\n/g; s/.*fcmToken: null.*/Token: ❌\n/g' | grep -B3 -A1 -i "$EMAIL")
    
    if [ -z "$FILTERED_USERS" ]; then
        echo -e "${YELLOW}No users found with email containing \"$EMAIL\"${NC}"
    else
        echo -e "${GREEN}Found matching users:${NC}"
        echo "$FILTERED_USERS"
    fi
    
    read -p "Press enter to continue..." dummy
    show_main_menu
}

# Validate notification icons
validate_icons() {
    echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}            Notification Icon Validation                ${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
    echo ""
    
    # Check if the notification icon script exists
    if [ ! -f "create_notification_icons.sh" ]; then
        echo -e "${RED}❌ Error: create_notification_icons.sh script not found${NC}"
        read -p "Press enter to continue..." dummy
        show_main_menu
        return
    fi
    
    echo -e "${CYAN}Options:${NC}"
    echo -e "${YELLOW}1)${NC} Validate existing notification icons"
    echo -e "${YELLOW}2)${NC} Generate new notification icons"
    echo -e "${YELLOW}3)${NC} View notification icon guide"
    echo -e "${YELLOW}0)${NC} Back to main menu"
    echo ""
    
    read -p "Enter your choice (0-3): " icon_choice
    
    case $icon_choice in
        1)
            echo -e "${BLUE}Checking notification icons...${NC}"
            
            # Check if the notification icon files exist in the expected locations
            MISSING_ICONS=()
            
            icon_paths=(
                "android/app/src/main/res/drawable/notification_icon.png"
                "android/app/src/main/res/drawable-mdpi/notification_icon.png"
                "android/app/src/main/res/drawable-hdpi/notification_icon.png"
                "android/app/src/main/res/drawable-xhdpi/notification_icon.png"
                "android/app/src/main/res/drawable-xxhdpi/notification_icon.png"
                "android/app/src/main/res/drawable-xxxhdpi/notification_icon.png"
            )
            
            for icon_path in "${icon_paths[@]}"; do
                if [ ! -f "$icon_path" ]; then
                    MISSING_ICONS+=("$icon_path")
                fi
            done
            
            if [ ${#MISSING_ICONS[@]} -eq 0 ]; then
                echo -e "${GREEN}✅ All notification icon files exist in expected locations${NC}"
            else
                echo -e "${RED}❌ Some notification icon files are missing:${NC}"
                for missing in "${MISSING_ICONS[@]}"; do
                    echo -e "   - ${YELLOW}$missing${NC}"
                done
                echo ""
                echo -e "${YELLOW}Would you like to generate the missing icons?${NC}"
                read -p "Generate icons now? (y/n): " generate
                
                if [[ "$generate" == "y" || "$generate" == "Y" ]]; then
                    # Run the icon generation script
                    echo -e "${BLUE}Generating notification icons...${NC}"
                    bash create_notification_icons.sh
                fi
            fi
            
            read -p "Press enter to continue..." dummy
            validate_icons
            ;;
        2)
            echo -e "${BLUE}Generating notification icons...${NC}"
            bash create_notification_icons.sh
            read -p "Press enter to continue..." dummy
            validate_icons
            ;;
        3)
            if [ -f "NOTIFICATION_ICON_FIX.md" ]; then
                echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
                echo -e "${CYAN}            Notification Icon Guide                     ${NC}"
                echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
                echo ""
                cat NOTIFICATION_ICON_FIX.md
            else
                echo -e "${RED}❌ Error: NOTIFICATION_ICON_FIX.md not found${NC}"
            fi
            read -p "Press enter to continue..." dummy
            validate_icons
            ;;
        0)
            show_main_menu
            return
            ;;
        *)
            echo -e "${RED}Invalid option. Please try again.${NC}"
            read -p "Press enter to continue..." dummy
            validate_icons
            ;;
    esac
}

# Show help and documentation
show_help() {
    echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}            Notification Testing Help                   ${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
    echo ""
    
    echo -e "${CYAN}Documentation:${NC}"
    
    if [ -f "FCM_TOKEN_GUIDE.md" ]; then
        echo -e "${YELLOW}FCM Token Guide:${NC} FCM_TOKEN_GUIDE.md"
    fi
    
    if [ -f "NOTIFICATION_ICON_FIX.md" ]; then
        echo -e "${YELLOW}Notification Icon Fix:${NC} NOTIFICATION_ICON_FIX.md"
    fi
    
    if [ -f "tools/FIREBASE_CREDENTIALS_GUIDE.md" ]; then
        echo -e "${YELLOW}Firebase Credentials Guide:${NC} tools/FIREBASE_CREDENTIALS_GUIDE.md"
    fi
    
    echo ""
    echo -e "${CYAN}Available Tools:${NC}"
    echo -e "${YELLOW}1. tools/send_fcm_notification.js${NC} - Send notification to a specific FCM token"
    echo -e "${YELLOW}2. tools/send_user_notification.sh${NC} - Send notification to a specific user"
    echo -e "${YELLOW}3. create_notification_icons.sh${NC} - Generate notification icons"
    
    echo ""
    echo -e "${CYAN}Troubleshooting:${NC}"
    echo -e "1. If notifications aren't being received:"
    echo -e "   - Check that notification permissions are granted in the app"
    echo -e "   - Verify FCM token is saved to Firestore (user must open app once)"
    echo -e "   - Check if device is in Do Not Disturb mode"
    echo -e "   - Ensure notification icon is properly formatted"
    
    echo ""
    echo -e "2. If notification icon shows as a white square:"
    echo -e "   - Run create_notification_icons.sh to generate proper icons"
    echo -e "   - Make sure the icon is a white foreground on transparent background"
    echo -e "   - Refer to NOTIFICATION_ICON_FIX.md for detailed guidance"
    
    read -p "Press enter to continue..." dummy
    show_main_menu
}

# Exit the script
exit_script() {
    echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}       Thank you for using NAYBRZ DXB Notification Tool  ${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
    exit 0
}

# Start the script by showing the main menu
show_main_menu
