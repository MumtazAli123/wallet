import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:wallet/global/global.dart';
import 'package:wallet/notification/push_notification_model.dart';

final user = FirebaseAuth.instance.currentUser;

class PushNotificationSys {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // notification received
  Future whenNotificationReceived() async {
    //  1. Terminated
    //   when the app is completely closed and opened directly from the notification
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        //   show notification data when open app
        showNotificationWhenOpenApp(
          remoteMessage.data['user_id'],
          Get.context!,
        );
        //   remoteMessage.data['user_id'];
      }
    });

    //   2. Foreground
    //   when the app is opened and received a notification
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      if (remoteMessage.notification != null) {
        showNotificationWhenOpenApp(
          remoteMessage.data['user_id'],
          Get.context!,
        );
      }
    });

    // 3. Background
    // when the app is in the background and opened directly from the notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      if (message.data['user_id'] != null) {
        showNotificationWhenOpenApp(
          message.data['user_id'],
          Get.context!,
        );
      }
    });
  }

  // device registration token
  Future<void> generateDeviceToken() async {
    String? registerDeviceToken = await messaging.getToken();
    FirebaseFirestore.instance
        .collection('sellers')
        .doc(sharedPreferences!.getString('uid'))
        .update({'sellerDeviceToken': registerDeviceToken});
    messaging.subscribeToTopic('allSellers');
    messaging.subscribeToTopic('allBuyers');
  }

  void sendNotification(
      PNotificationModel notificationModel, String recipientDeviceToken) async {
    try {
      await messaging.subscribeToTopic('allSellers');
      RemoteMessage(
        data: {
          'title': notificationModel.title,
          'body': notificationModel.body,
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        },
        notification: RemoteNotification(
          title: notificationModel.title,
          body: notificationModel.body,
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  void showNotificationWhenOpenApp(data, BuildContext context) async {
   await FirebaseFirestore.instance
        .collection('sellers')
        .doc(data)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Get.snackbar(
          'Notification',
          'You have a new notification',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      }
    });
  }
}


