/**
 * NAYBRZ DXB Firebase Cloud Functions
 * 
 * This file contains Firebase Cloud Functions for handling:
 * - Push notifications (FCM v1 API)
 * - Message management and unread counts
 * - Admin and user app notifications
 * - Bulk notifications
 */

const { onCall } = require("firebase-functions/v2/https");
const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const logger = require("firebase-functions/logger");
const { getFirestore } = require('firebase-admin/firestore');
const { getMessaging } = require('firebase-admin/messaging');
const { initializeApp } = require('firebase-admin/app');

// Initialize Firebase Admin SDK
initializeApp();

// Firebase Firestore reference
const db = getFirestore();

// Constants
const UNREAD_MESSAGES_COLLECTION = 'unreadMessageCounts';
const USER_APP_PACKAGE = 'com.semester.ride.mobile';
const ADMIN_APP_PACKAGE = 'com.naybrz.coreCircle.com';

// ===========================
// UTILITY FUNCTIONS
// ===========================

/**
 * Creates a consistent conversation ID between two users
 * @param {string} senderId - ID of the sender
 * @param {string} receiverId - ID of the receiver
 * @returns {string} - Consistent conversation ID
 */
const getConversationId = (senderId, receiverId) => {
    const sortedIds = [senderId, receiverId].sort();
    return `${sortedIds[0]}_${sortedIds[1]}`;
};

/**
 * Creates a standardized FCM message structure
 * @param {string} token - FCM token
 * @param {Object} options - Message options
 * @returns {Object} - FCM message object
 */
const createFCMMessage = (token, { title, body, imageUrl, data, tag, channelId = 'default' }) => {
    const message = {
        token,
        data: {
            ...data,
            title: title || 'NAYBRZ DXB',
            body: body || 'You have a new notification',
            imageUrl: imageUrl || '',
            timestamp: Date.now().toString(),
            // notificationId is now passed through data
        },
        android: {
            notification: {
                icon: 'notification_icon',
                color: '#000000',
                priority: 'high',
                channelId,
                ...(tag && { tag }),
                ...(imageUrl && { imageUrl }),
            }
        },
        apns: {
            payload: {
                aps: {
                    alert: {
                        title: title || 'NAYBRZ DXB',
                        body: body || 'You have a new notification',
                    },
                    badge: 1,
                    sound: 'default',
                    'mutable-content': 1,
                    'content-available': 1,
                    ...(tag && { threadId: tag }),
                }
            },
            headers: {
                'apns-priority': '10',
                'apns-topic': data?.targetApp === 'admin' ? ADMIN_APP_PACKAGE : USER_APP_PACKAGE,
            },
            ...(imageUrl && { fcmOptions: { imageUrl } })
        }
    };

    if (imageUrl && data?.senderName) {
        message.data.senderName = data.senderName;
        message.data.senderProfileUrl = imageUrl;
    }

    return message;
};

// ===========================
// BASIC NOTIFICATION FUNCTIONS
// ===========================

/**
 * Send notification using FCM v1 API to a specific token
 */
exports.sendNotification = onCall({
    timeoutSeconds: 60,
    maxInstances: 10,
}, async (request) => {
    try {
        const { token, title, body, imageUrl, data } = request.data;

        if (!token) {
            return { success: false, error: 'No token provided' };
        }

        const message = createFCMMessage(token, { title, body, imageUrl, data });
        const response = await getMessaging().send(message);

        return { success: true, messageId: response };
    } catch (error) {
        logger.error('Error sending notification:', error);
        return { success: false, error: error.message };
    }
});

/**
 * Send notification to a specific user by userId
 */
exports.sendNotificationToUser = onCall({
    timeoutSeconds: 60,
    maxInstances: 10,
}, async (request) => {
    try {
        const { userId, title, body, imageUrl, notificationId, data } = request.data;

        if (!userId) {
            return { success: false, error: 'No userId provided' };
        }

        const userDoc = await getFirestore().collection('users').doc(userId).get();

        if (!userDoc.exists || !userDoc.data()?.fcmToken) {
            return { success: false, error: 'User not found or no FCM token' };
        }

        const fcmToken = userDoc.data().fcmToken;
        const threadId = data?.threadId || userId;

        // Include notificationId in data payload if provided
        const messageData = {
            ...data,
            ...(notificationId && { notificationId })
        };

        const message = createFCMMessage(fcmToken, {
            title,
            body,
            imageUrl,
            data: messageData,
            tag: threadId,
            channelId: 'chat_messages'
        });

        const response = await getMessaging().send(message);
        return { success: true, messageId: response };
    } catch (error) {
        logger.error('Error sending notification to user:', error);
        return { success: false, error: error.message };
    }
});

/**
 * Send notification to topic
 */
exports.sendNotificationToTopic = onCall({
    timeoutSeconds: 60,
    maxInstances: 10,
}, async (request) => {
    try {
        const { topic, title, body, imageUrl, data } = request.data;

        if (!topic) {
            return { success: false, error: 'No topic provided' };
        }

        const message = {
            topic,
            data: {
                ...data,
                title: title || 'NAYBRZ DXB',
                body: body || 'You have a new notification',
                imageUrl: imageUrl || '',
                senderName: data?.senderName || 'NAYBRZ',
                timestamp: Date.now().toString(),
            },
            android: {
                notification: {
                    icon: 'notification_icon',
                    color: '#000000',
                    priority: 'high',
                    tag: 'message',
                    ...(imageUrl && { imageUrl }),
                }
            },
            apns: {
                payload: {
                    aps: {
                        alert: {
                            title: title || 'NAYBRZ DXB',
                            body: body || 'You have a new notification',
                        },
                        badge: 1,
                        sound: 'default',
                        'mutable-content': 1,
                        'content-available': 1,
                    }
                },
                headers: {
                    'apns-priority': '10',
                    'apns-topic': USER_APP_PACKAGE,
                },
                ...(imageUrl && { fcmOptions: { imageUrl } })
            }
        };

        const response = await getMessaging().send(message);
        return { success: true, messageId: response };
    } catch (error) {
        logger.error('Error sending notification to topic:', error);
        return { success: false, error: error.message };
    }
});

// ===========================
// BULK NOTIFICATION FUNCTIONS
// ===========================

/**
 * Send push notification when a new notification document is created
 * This is a Firestore trigger that handles automatic notification sending for both admin and user apps
 */
exports.sendPushOnNewNotification = onDocumentCreated('notifications/{notificationId}', async (event) => {

    try {
        logger.log('New notification document created:', event.params.notificationId);
        const snapshot = event.data;
        if (!snapshot) return;

        const notificationData = snapshot.data();

        logger.log('Notification data:', notificationData.title);
        if (!notificationData) return;

        // Skip direct send notifications (already sent via bulk function)
        if (notificationData.directSend === true) return;

        const userId = notificationData.userId;
        if (!userId) return;

        const userDoc = await getFirestore().collection('users').doc(userId).get();
        if (!userDoc.exists) return;

        const userData = userDoc.data();

        // Handle admin notifications
        if (notificationData.isForAdmin === true || notificationData.data?.targetApp === 'admin') {
            logger.log('is admin notification');
            if (userData.isAdmin) {
                // Get the admin FCM token
                const adminFcmToken = userData.adminAppFcmToken || userData.fcmToken;
                if (!adminFcmToken) return;

                await sendAdminNotification(adminFcmToken, notificationData, snapshot.id);
            }
            return;
        }

        // Handle user app specific notifications
        if (notificationData.data?.targetApp === 'user' || notificationData.data?.isUserAppNotification === 'true') {
            logger.log('is user notification via sendUserAppNotification');
            const userAppFcmToken = userData.userAppFcmToken || userData.fcmToken;
            if (!userAppFcmToken) return;

            await sendUserAppNotification(userAppFcmToken, notificationData, snapshot.id);
            return;
        }

        // Handle regular user notifications (default case)
        if (userData.fcmToken) {
            logger.log('is user notification via handleUserNotification');
            await handleUserNotification(notificationData, snapshot.id, userData);
        }

    } catch (error) {
        logger.error('Error sending push notification:', error);
    }
});

/**
 * Send notification to admin app
 */
const sendAdminNotification = async (adminFcmToken, notificationData, notificationId) => {
    try {
        const threadId = notificationData.data?.threadId || notificationData.userId;
        const title = notificationData.title || 'NAYBRZ Admin';
        const body = notificationData.body || 'You have a new admin notification';

        const adminMessage = {
            token: adminFcmToken,
            data: {
                ...notificationData.data || {},
                title,
                body,
                imageUrl: notificationData.imageUrl || '',
                isAdminNotification: 'true',
                timestamp: Date.now().toString(),
                notificationId: notificationData.notificationId || notificationId, // Use document's notificationId if available
                targetApp: 'admin',
                ...(notificationData.imageUrl && {
                    senderName: notificationData.data?.senderName || 'User',
                    senderProfileUrl: notificationData.imageUrl,
                }),
            },
            android: {
                notification: {
                    icon: 'admin_notification_icon',
                    color: '#FFD700',
                    priority: 'high',
                    tag: `admin_${threadId}`,
                    channelId: 'admin_messages',
                    ...(notificationData.imageUrl && { imageUrl: notificationData.imageUrl }),
                },
                restrictedPackageName: ADMIN_APP_PACKAGE,
            },
            apns: {
                payload: {
                    aps: {
                        alert: {
                            title,
                            body,
                        },
                        badge: 1,
                        sound: 'admin_sound.aiff',
                        threadId: `admin_${threadId}`,
                        'mutable-content': 1,
                        'content-available': 1,
                    }
                },
                headers: {
                    'apns-priority': '10',
                    'apns-topic': ADMIN_APP_PACKAGE,
                },
                ...(notificationData.imageUrl && {
                    fcmOptions: { imageUrl: notificationData.imageUrl }
                })
            }
        };

        await getMessaging().send(adminMessage);
        return true;
    } catch (error) {
        logger.error('Error sending admin notification:', error);
        return false;
    }
};

/**
 * Send notification to user app
 */
const sendUserAppNotification = async (userAppFcmToken, notificationData, notificationId) => {
    try {
        const title = notificationData.title || 'NAYBRZ';
        const body = notificationData.body || 'You have a new message';

        const message = {
            token: userAppFcmToken,
            data: {
                ...notificationData.data || {},
                title: title,
                body: body,
                imageUrl: notificationData.imageUrl || '',
                isUserAppNotification: 'true',
                senderName: notificationData.data?.senderName || title || 'NAYBRZ',
                notificationId: notificationData.notificationId || notificationId,
                timestamp: Date.now().toString(),
                targetApp: 'user',
                ...(notificationData.imageUrl && {
                    senderProfileUrl: notificationData.imageUrl,
                }),
            },
            android: {
                priority: 'high',
                restrictedPackageName: USER_APP_PACKAGE,
            },
            apns: {
                payload: {
                    aps: {
                        alert: {
                            title: title,
                            body: body,
                        },
                        badge: 1,
                        sound: 'default',
                        'mutable-content': 1,
                        'content-available': 1,
                    }
                },
                headers: {
                    'apns-priority': '10',
                    'apns-topic': USER_APP_PACKAGE,
                },
                ...(notificationData.imageUrl && { fcmOptions: { imageUrl: notificationData.imageUrl } })
            }
        };

        await getMessaging().send(message);
        return true;
    } catch (error) {
        logger.error('Error sending user app notification:', error);
        return false;
    }
};

/**
 * Handle regular user notifications
 */
const handleUserNotification = async (notificationData, notificationId, userData = null) => {
    try {
        // If userData wasn't passed, fetch it
        let fcmToken;
        if (!userData) {
            const userId = notificationData.userId;
            if (!userId) return;

            const userDoc = await getFirestore().collection('users').doc(userId).get();
            if (!userDoc.exists || !userDoc.data()?.fcmToken) return;

            userData = userDoc.data();
            fcmToken = userData.fcmToken;
        } else {
            fcmToken = userData.fcmToken;
        }

        if (!fcmToken) return;

        // Determine notification tag based on type
        let notificationTag = `notification_${notificationId}`;
        let title = notificationData.title || 'NAYBRZ DXB';
        let body = notificationData.body || 'You have a new notification';

        if (notificationData.type === 'meetup_join' || notificationData.type === 'meetup_leave') {
            const meetupId = notificationData.meetupId || 'unknown';
            notificationTag = `meetup_${meetupId}_${notificationId}`;
        } else if (notificationData.data?.type === 'chat') {
            const senderId = notificationData.data.senderId || 'unknown';
            notificationTag = `chat_${senderId}_${notificationId}`;
        }

        // Create message with both data and notification payloads
        const message = {
            token: fcmToken,
            data: {
                ...notificationData.data || {},
                title,
                body,
                imageUrl: notificationData.imageUrl || '',
                senderName: notificationData.data?.senderName || 'User',
                senderProfileUrl: notificationData.imageUrl || '',
                notificationId: notificationData.notificationId || notificationId, // Use document's notificationId if available
                timestamp: Date.now().toString(),
                tag: notificationTag,
            },
            android: {
                priority: 'high',
                collapseKey: notificationTag,
            },
            apns: {
                payload: {
                    aps: {
                        alert: {
                            title,
                            body,
                        },
                        badge: 1,
                        sound: 'default',
                        threadId: notificationTag,
                        'mutable-content': 1,
                        'content-available': 1
                    }
                },
                headers: {
                    'apns-priority': '10',
                    'apns-topic': USER_APP_PACKAGE,
                    'apns-collapse-id': notificationTag,
                },
                ...(notificationData.imageUrl && {
                    fcmOptions: { imageUrl: notificationData.imageUrl }
                })
            }
        };

        await getMessaging().send(message);
        return true;
    } catch (error) {
        logger.error('Error sending user notification:', error);
        return false;
    }
};

// ===========================
// MESSAGE MANAGEMENT FUNCTIONS
// ===========================

/**
 * Update unread message count when a new message is created
 */
exports.updateUnreadMessageCount = onDocumentCreated('messages/{messageId}', async (event) => {
    try {
        const snapshot = event.data;
        if (!snapshot) return;

        const messageData = snapshot.data();
        if (!messageData) return;

        const { senderId, receiverId } = messageData;
        if (!senderId || !receiverId) return;

        const conversationId = getConversationId(senderId, receiverId);

        // Update the unread message count for the receiver
        const receiverDoc = db.collection(UNREAD_MESSAGES_COLLECTION).doc(receiverId);
        await receiverDoc.set({
            conversationId: conversationId,
            userId: receiverId,
            unreadCount: 1, // Use increment if available: admin.firestore.FieldValue.increment(1)
        }, { merge: true });

    } catch (error) {
        logger.error('Error updating unread message count:', error);
    }
});

/**
 * Clear unread messages when user opens a conversation
 */
exports.clearUnreadMessages = onCall({
    timeoutSeconds: 60,
    maxInstances: 10,
}, async (request) => {
    try {
        const { senderId, receiverId } = request.data;

        if (!senderId || !receiverId) {
            return { success: false, error: 'Missing user IDs' };
        }

        const conversationId = getConversationId(senderId, receiverId);
        const unreadCountRef = db.collection(UNREAD_MESSAGES_COLLECTION)
            .doc(`${conversationId}_${receiverId}`);

        const unreadDoc = await unreadCountRef.get();

        if (unreadDoc.exists) {
            await unreadCountRef.update({
                count: 0,
                lastUpdated: new Date(),
                lastCleared: new Date()
            });
            return { success: true, message: 'Unread count cleared' };
        } else {
            return { success: true, message: 'No unread messages' };
        }
    } catch (error) {
        logger.error('Error clearing unread message count:', error);
        return { success: false, error: error.message };
    }
});

/**
 * Reset message counters between two users
 */
exports.resetMessageCounter = onCall({
    timeoutSeconds: 60,
    maxInstances: 10,
}, async (request) => {
    try {
        const { receiverId, senderId } = request.data;

        if (!receiverId || !senderId) {
            return { success: false, error: 'Missing required parameters' };
        }

        const conversationId = getConversationId(senderId, receiverId);
        const counterRef = db.collection(UNREAD_MESSAGES_COLLECTION).doc(conversationId);
        const counterDoc = await counterRef.get();

        if (counterDoc.exists) {
            const data = counterDoc.data();
            if (data[receiverId]) {
                data[receiverId][senderId] = 0;
                await counterRef.update({
                    [receiverId]: data[receiverId],
                    lastUpdated: new Date()
                });
            }
        }

        return { success: true };
    } catch (error) {
        logger.error('Error resetting message counter:', error);
        return { success: false, error: error.message };
    }
});

/**
 * Send notifications to multiple users at once (for group messages)
 */
exports.sendBulkNotifications = onCall({
    timeoutSeconds: 60,
    maxInstances: 10,
}, async (request) => {
    try {
        const { userIds, title, body, imageUrl, data } = request.data;

        if (!userIds || !Array.isArray(userIds) || userIds.length === 0) {
            return { success: false, error: 'No userIds array provided' };
        }

        // Get FCM tokens for all users
        const userDocs = await Promise.all(
            userIds.map(userId => getFirestore().collection('users').doc(userId).get())
        );

        const validTokens = [];
        const failedUsers = [];

        userDocs.forEach((userDoc, index) => {
            const userId = userIds[index];
            if (!userDoc.exists || !userDoc.data()?.fcmToken) {
                failedUsers.push(userId);
                return;
            }
            validTokens.push(userDoc.data().fcmToken);
        });

        if (validTokens.length === 0) {
            return { success: false, error: 'No valid FCM tokens found' };
        }

        const threadId = data?.threadId || 'group_message';

        // Create multicast message
        const multicastMessage = {
            tokens: validTokens,
            data: {
                ...data,
                title: title || 'NAYBRZ DXB',
                body: body || 'You have a new group message',
                imageUrl: imageUrl || '',
                timestamp: Date.now().toString(),
                ...(imageUrl && { senderProfileUrl: imageUrl }),
            },
            android: {
                notification: {
                    icon: 'notification_icon',
                    color: '#000000',
                    priority: 'high',
                    tag: threadId,
                    channelId: 'group_messages',
                    ...(imageUrl && { imageUrl }),
                }
            },
            apns: {
                payload: {
                    aps: {
                        alert: {
                            title: title || 'NAYBRZ DXB',
                            body: body || 'You have a new group message',
                        },
                        badge: 1,
                        sound: 'default',
                        threadId: threadId,
                        'mutable-content': 1,
                        'content-available': 1,
                    }
                },
                headers: {
                    'apns-priority': '10',
                    'apns-topic': USER_APP_PACKAGE,
                },
                ...(imageUrl && { fcmOptions: { imageUrl } })
            }
        };

        const response = await getMessaging().sendEachForMulticast(multicastMessage);

        return {
            success: true,
            successCount: response.successCount,
            failureCount: response.failureCount,
            failedUsers: failedUsers
        };
    } catch (error) {
        logger.error('Error sending bulk notifications:', error);
        return { success: false, error: error.message };
    }
});

// ===========================
// FCM TOKEN MANAGEMENT
// ===========================


/**
 * Store FCM token for any app (user or admin)
 */
exports.storeFcmToken = onCall({
    timeoutSeconds: 60,
    maxInstances: 10,
}, async (request) => {
    try {
        const { userId, fcmToken, appType, packageName, bundleId } = request.data;

        if (!userId || !fcmToken) {
            return { success: false, error: 'Missing required parameters' };
        }

        const updateData = {};

        // Check which app is updating its token
        if (appType === 'admin') {
            updateData.adminAppFcmToken = fcmToken;
            updateData.adminAppTokenLastUpdated = new Date();
            updateData.adminAppPackageName = packageName || ADMIN_APP_PACKAGE;
            updateData.adminAppBundleId = bundleId || ADMIN_APP_PACKAGE;
        } else {
            // Default to user app
            updateData.userAppFcmToken = fcmToken;
            updateData.userAppTokenLastUpdated = new Date();
            updateData.userAppPackageName = packageName || USER_APP_PACKAGE;
            updateData.userAppBundleId = bundleId || USER_APP_PACKAGE;

            // Also update general FCM token for backward compatibility
            updateData.fcmToken = fcmToken;
            updateData.fcmTokenLastUpdated = new Date();
        }

        // Add platform info
        updateData.appPlatform = request.data.platform || 'unknown';
        updateData.appVersion = request.data.appVersion || 'unknown';

        await getFirestore().collection('users').doc(userId).update(updateData);

        return { success: true, appType };
    } catch (error) {
        logger.error('Error storing FCM token:', error);
        return { success: false, error: error.message };
    }
});

// ===========================
// FIRESTORE TRIGGERS
// ===========================

/**
 * Handle RevenueCat webhook events for subscription status changes
 * 
 * This function listens for HTTP requests from RevenueCat webhooks
 * and updates the user's subscription status in Firestore.
 * 
 * Set up your webhook in RevenueCat dashboard to point to:
 * https://YOUR_REGION-YOUR_PROJECT_ID.cloudfunctions.net/handleRevenueCatWebhook
 */
exports.handleRevenueCatWebhook = onCall({
    cors: true,
    maxInstances: 10,
    timeoutSeconds: 60,
}, async (request) => {
    try {
        // Get webhook data from request
        const data = request.data;
        logger.info('Received RevenueCat webhook event', data);

        // Verify webhook data
        if (!data || !data.event || !data.event.type) {
            throw new Error('Invalid webhook data');
        }

        // Extract relevant information
        const eventType = data.event.type;
        const appUserId = data.app_user_id;
        const productId = data.product_id;
        const expirationDate = data.event.expiration_at_ms
            ? new Date(data.event.expiration_at_ms)
            : null;

        // Skip if no user ID (anonymous purchase)
        if (!appUserId) {
            logger.warn('No app_user_id provided in webhook');
            return { success: false, message: 'No app_user_id provided' };
        }

        logger.info(`Processing ${eventType} event for user ${appUserId} and product ${productId}`);

        // Get Firebase user ID from app user ID
        // In this case, appUserId should be the Firebase UID
        const userId = appUserId;

        // Determine subscription status based on event type
        let subscriptionStatus = false;
        let updateData = {};

        switch (eventType) {
            case 'INITIAL_PURCHASE':
            case 'RENEWAL':
            case 'UNCANCELLATION':
            case 'NON_RENEWING_PURCHASE':
                // Subscription active
                subscriptionStatus = true;
                updateData = {
                    'subscription.isActive': true,
                    'subscription.lastUpdated': new Date(),
                    'subscription.willRenew': true,
                    'subscription.cancelledDate': null,
                    'subscription.productId': productId,
                };

                if (expirationDate) {
                    updateData['subscription.expirationDate'] = expirationDate;
                }
                break;

            case 'CANCELLATION':
                // Subscription cancelled but might still be active until expiration
                updateData = {
                    'subscription.willRenew': false,
                    'subscription.cancelledDate': new Date(),
                    'subscription.lastUpdated': new Date(),
                    'subscription.productId': productId,
                };

                // Check if subscription has already expired
                if (expirationDate && expirationDate < new Date()) {
                    subscriptionStatus = false;
                    updateData['subscription.isActive'] = false;
                }
                break;

            case 'EXPIRATION':
                // Subscription expired
                subscriptionStatus = false;
                updateData = {
                    'subscription.isActive': false,
                    'subscription.lastUpdated': new Date(),
                    'subscription.willRenew': false,
                    'subscription.expirationDate': expirationDate || new Date(),
                    'subscription.productId': productId,
                };
                break;

            case 'BILLING_ISSUE':
                // Billing issue but subscription might still be active
                updateData = {
                    'subscription.hasBillingIssue': true,
                    'subscription.lastUpdated': new Date(),
                    'subscription.productId': productId,
                };
                break;

            default:
                logger.info(`Unhandled event type: ${eventType}`);
                return { success: true, message: 'Event ignored' };
        }

        // Update user document in Firestore
        const userRef = db.collection('users').doc(userId);
        const userDoc = await userRef.get();

        if (!userDoc.exists) {
            logger.error(`User ${userId} not found in database`);
            return { success: false, message: 'User not found' };
        }

        logger.info(`Updating user ${userId} with new subscription status: ${subscriptionStatus}`, updateData);
        await userRef.update(updateData);

        // Send notification to user about subscription status change
        if (['INITIAL_PURCHASE', 'RENEWAL', 'UNCANCELLATION', 'EXPIRATION', 'NON_RENEWING_PURCHASE'].includes(eventType)) {
            const notificationType = subscriptionStatus ? 'subscription_active' : 'subscription_expired';
            const notificationTitle = subscriptionStatus ? 'Subscription Activated' : 'Subscription Expired';
            const notificationBody = subscriptionStatus
                ? `Your subscription has been ${eventType === 'INITIAL_PURCHASE' ? 'activated' : 'renewed'}.`
                : 'Your subscription has expired.';

            // Create notification document
            const notificationRef = db.collection('notifications').doc();
            await notificationRef.set({
                userId: userId,
                title: notificationTitle,
                body: notificationBody,
                type: notificationType,
                notificationId: notificationRef.id,
                data: {
                    route: '/profile',
                    subscriptionStatus: subscriptionStatus,
                    eventType: eventType,
                    productId: productId,
                    notificationId: notificationRef.id,
                },
                timestamp: new Date(),
                isRead: false,
            });

            logger.info(`Created notification for user ${userId} about subscription status change`);
        }

        return { success: true, message: 'Subscription status updated' };

    } catch (error) {
        logger.error('Error processing RevenueCat webhook', error);
        return { success: false, message: error.message };
    }
});
