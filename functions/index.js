/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendOrderNotification = functions.firestore
    .document('orders/{orderId}')
    .onCreate((snap, context) => {
      const orderData = snap.data();
      const userId = orderData.userId;

      // Récupérer le token FCM de l'utilisateur (gérant)
      return admin.firestore().collection('users').doc(userId).get().then(userDoc => {
        const fcmToken = userDoc.data().fcmToken;

        // Envoyer la notification
        const message = {
          notification: {
            title: 'Nouvelle Commande',
            body: `Vous avez une nouvelle commande de ${orderData.clientName}.`
          },
          token: fcmToken
        };
        return admin.messaging().send(message);
      });
    });


// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
