# Getting Firebase Service Account Credentials for NAYBRZ DXB

This guide will help you obtain and set up the Firebase service account credentials needed for the notification testing tools in NAYBRZ DXB.

## Step 1: Access Firebase Console

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Select your NAYBRZ DXB project

## Step 2: Get Service Account Credentials

1. In the left navigation, click on the gear icon ⚙️ and select **Project settings**
2. Go to the **Service accounts** tab
3. Make sure "Firebase Admin SDK" is selected 
4. Click **Generate new private key**
5. Save the downloaded JSON file (keep it secure as it contains sensitive credentials)

## Step 3: Set Up Credentials in NAYBRZ DXB

1. Rename the downloaded file to `firebase-service-account.json`
2. Replace the placeholder file in the NAYBRZ DXB project:
   ```
   cp path/to/downloaded/file.json "/Users/huzaifashakeel/Documents/NAYBRZ DXB/NAYBRZ DXB/tools/firebase-service-account.json"
   ```
   Replace `path/to/downloaded/file.json` with the actual path to your downloaded file.

## Step 4: Verify Setup

To verify your setup is working correctly:

1. Run the test script:
   ```
   cd "/Users/huzaifashakeel/Documents/NAYBRZ DXB/NAYBRZ DXB"
   ./tools/fcm_token_demo.sh
   ```

2. Follow the prompts to test sending a notification

## Security Notes

- **IMPORTANT**: The service account file contains sensitive credentials. Never commit it to version control.
- Add `tools/firebase-service-account.json` to your `.gitignore` file if not already there.
- Keep a backup of your credentials in a secure location.
