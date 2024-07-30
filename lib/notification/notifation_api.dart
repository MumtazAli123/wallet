
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wallet/notification/push_notification_model.dart';

Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');

}


class FirebaseApi {
  final firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await firebaseMessaging.requestPermission();
    final fCMToken = await firebaseMessaging.getToken();
    print('Token: $fCMToken');

    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
  }



  // static Stream<List<PNotificationModel>> readNotifications() => FirebaseFirestore.instance
  //     .collection('notifications')
  //     .orderBy(PNotificationModel.KEY_CREATED_AT, descending: true)
  //     .snapshots()
  //     .transform(Utils.transformer(PNotificationModel.fromJson));

  static Future<void> updateNotification(PNotificationModel notification) async {
    final docNotification = FirebaseFirestore.instance.collection('notifications').doc(notification.id);
    await docNotification.update(notification.toJson());
  }

  static Future<void> deleteNotification(PNotificationModel notification) async {
    final docNotification = FirebaseFirestore.instance.collection('notifications').doc(notification.id);
    await docNotification.delete();
  }
}


