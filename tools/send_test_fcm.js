#!/usr/bin/env node
/**
 * FCM Test Notification Sender
 * ---------------------------
 * A simple script to send a test notification to a Firebase Cloud Messaging token.
 * 
 * Requirements:
 * - Node.js installed
 * - Firebase Admin SDK installed (npm install firebase-admin)
 * - A service account key from your Firebase project
 * 
 * How to use:
 * 1. Save this file as send_test_fcm.js
 * 2. Run with: node send_test_fcm.js YOUR_DEVICE_TOKEN_HERE
 * 
 * How to get your service account key:
 * - Go to Firebase Console > Project Settings > Service Accounts
 * - Click "Generate New Private Key"
 * - Save the file as serviceAccountKey.json in the same directory as this script
 */

// Check if a device token was provided
if (process.argv.length < 3) {
    console.error('Please provide a device token');
    console.error('Usage: node send_test_fcm.js YOUR_DEVICE_TOKEN_HERE');
    process.exit(1);
}

const deviceToken = process.argv[2];

try {
    // Initialize Firebase Admin SDK
    const admin = require('firebase-admin');
    const serviceAccount = require('./serviceAccountKey.json');

    admin.initializeApp({
        credential: admin.credential.cert(serviceAccount)
    });

    // Notification message
    const message = {
        notification: {
            title: 'Test Notification',
            body: 'This is a test notification from the CLI tool'
        },
        data: {
            title: 'Test Notification',
            body: 'This is a test notification from the CLI tool',
            route: '/notification_settings',
            id: `test_notification_${Date.now()}`
        },
        token: deviceToken
    };

    // Send the message
    admin.messaging().send(message)
        .then((response) => {
            console.log('Successfully sent message:', response);
            process.exit(0);
        })
        .catch((error) => {
            console.error('Error sending message:', error);
            process.exit(1);
        });

} catch (error) {
    console.error('Failed to initialize Firebase:', error);
    process.exit(1);
}
