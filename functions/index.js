// functions/index.js
const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");

initializeApp();

exports.sendNotificationOnCreate = onDocumentCreated("notifications/{notificationId}", async (event) => {
  const snapshot = event.data;
  if (!snapshot) return;

  const notification = snapshot.data();
  const userId = notification.userId;

  const db = getFirestore();
  const userDoc = await db.collection('users').doc(userId).get();
  const deviceToken = userDoc.data()?.deviceToken;

  if (!deviceToken) {
    console.log(`No device token found for user: ${userId}`);
    return;
  }

  const payload = {
    notification: {
      title: notification.title || 'New Notification',
      body: notification.body || '',
    },
    token: deviceToken,
  };

  try {
    await getMessaging().send(payload);
    console.log("✅ Notification sent to:", deviceToken);
  } catch (err) {
    console.error("❌ Failed to send notification:", err);
  }
});
