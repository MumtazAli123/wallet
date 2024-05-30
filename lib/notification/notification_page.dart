// ignore_for_file: public_member_api_docs, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:wallet/notification/notification_badge.dart';
import 'package:wallet/notification/push_notification_model.dart';
import 'package:wallet/widgets/mix_widgets.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late int _totalNotifications;
  late final FirebaseMessaging _firebaseMessaging;
  PushNotification? _notificationInfo;

  void requestAndRegisterNotification() async {
    await Firebase.initializeApp();
    _firebaseMessaging = FirebaseMessaging.instance;

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      String? token = await _firebaseMessaging.getToken();
      print('Token: $token');
    } else {
      print('User declined or has not accepted permission');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title ?? '',
        body: message.notification?.body ?? '',
      );
      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
      if (_notificationInfo != null) {
        showSimpleNotification(
          Text(_notificationInfo!.title),
          leading: NotificationBadge(totalNotification: _totalNotifications),
          subtitle: Text(_notificationInfo!.body),
          background: Colors.green,
          duration: const Duration(seconds: 2),
        );
      }
    });
    
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification!.title!,
        body: message.notification!.body!,
      );
      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    });

    // Get any messages which caused the application to open from terminated state
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title ?? '',
        body: initialMessage.notification?.body ?? '',
      );
      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    }

  }
  // stream to listen to incoming messages



  @override
  void initState() {
    super.initState();
    _totalNotifications = 0;
    requestAndRegisterNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$_totalNotifications Notifications'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            wText('Notification Page'),
            if (_notificationInfo != null) ...[
              Text(_notificationInfo!.title),
              const SizedBox(height: 8),
              Text(_notificationInfo!.body),
            ],
          ],
        ),
      ),
    );
  }

}
