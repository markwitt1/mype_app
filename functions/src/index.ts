import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();
const db = admin.firestore();
const fcm = admin.messaging();
//const storage = admin.storage();

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const getUser = async (id: string) =>
  await (await db.collection("users").doc(id).get()).data();

export const onFriendRequestNotification = functions
  .region("europe-west2")
  .firestore.document("friendRequests/{requestId}")
  .onCreate(async (snapshot) => {
    const friendRequest = snapshot.data();
    const toUserId = friendRequest.to;
    const fromUserId = friendRequest.from;

    const toUser = await getUser(toUserId);
    const fromUser = await getUser(fromUserId);

    if (!!toUser && !!fromUser) {
      /*       const profilePictureUrl = (
        await storage
          .bucket("gs://mype-app.appspot.com/")
          .file(fromUser.profilePicture)
          .getSignedUrl({
            action: "read",
            expires: Date.now() + 172800000,
          })
      )[0]; */

      const payload: admin.messaging.MessagingPayload = {
        data: {
          type: "incomingFriendRequest",
          fromUser: fromUserId,
        },
        notification: {
          title: "New Friend Request!",
          body: `From ${fromUser.name}`,
          //icon: profilePictureUrl,
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      };
      return fcm.sendToDevice(toUser.tokens, payload);
    } else return null;
  });
