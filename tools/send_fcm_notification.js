#!/usr/bin/env node
/**
 * Script to send a test FCM notification to a specific device
 * 
 * Usage:
 *   node send_fcm_notification.js FCM_TOKEN "Notification Title" "Notification Body"
 */

const admin = require('firebase-admin');
const serviceAccount = require('./firebase-service-account.json');

// Initialize Firebase Admin SDK
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

// Get command line arguments
const token = process.argv[2];
const title = process.argv[3] || 'NAYBRZ DXB Notification';
const body = process.argv[4] || 'This is a test notification from NAYBRZ DXB';

if (!token) {
    console.error('Error: FCM token is required');
    console.log('Usage: node send_fcm_notification.js FCM_TOKEN "Notification Title" "Notification Body"');
    process.exit(1);
}

// Message payload
const message = {
    notification: {
        title: title,
        body: body,
    },
    data: {
        route: '/notification_settings',
        id: `test_notification_${Date.now()}`,
        title: title,
        body: body,
    },
    token: token
};

// Send the message
admin.messaging().send(message)
    .then((response) => {
        console.log('✅ Successfully sent notification:');
        console.log(`   Title: "${title}"`);
        console.log(`   Body: "${body}"`);
        console.log(`   FCM Response: ${response}`);
    })
    .catch((error) => {
        console.error('❌ Error sending notification:', error);
    });
