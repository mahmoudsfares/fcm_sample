import 'dart:async';
import 'dart:convert';
import 'package:fcm_sample/notifications/notifications_api.dart';
import 'package:fcm_sample/screens/notification_data_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SecondScreen extends StatefulWidget {
  static const String route = "/second";

  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {

  // TODO 21: define the stream subscriptions for both FCMs and local notifications to cancel them on dispose
  late final StreamSubscription<RemoteMessage> fcmStream;
  late final StreamSubscription<String> localNotificationStream;

  @override
  Widget build(BuildContext context) {
    _triggerNotificationsListeners(context);
    return Scaffold(
      appBar: AppBar(title: const Text('second')),
      body: const Center(
        child: Text('this is the second screen'),
      ),
    );
  }

  void _triggerNotificationsListeners(BuildContext context) async {
    // local notification
    NotificationAppLaunchDetails? initialNotification = await NotificationsApi.localNotificationsPlugin.getNotificationAppLaunchDetails();
    // fcm notification
    RemoteMessage? message;
    await Future.delayed(Duration.zero, () => message = getRemoteMessage(context));
    // local notification was tapped while the app is in foreground
    localNotificationStream = NotificationsApi.notificationStream.stream.listen((payload) {
      Future.delayed(Duration.zero, () => Navigator.pushNamed(context, NotificationDataScreen.route, arguments: payload));
    });
    // firebase notification was tapped while the app is in background
    fcmStream = FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      Map<String, dynamic> payload = message.data;
      Future.delayed(Duration.zero, () => Navigator.pushNamed(context, NotificationDataScreen.route, arguments: jsonEncode(payload)));
    });
    // local notification was tapped while the app is in background
    if (initialNotification != null && initialNotification.didNotificationLaunchApp == true) {
      String? payload = initialNotification.notificationResponse?.payload;
      // avoid using context across an async gap by ensuring that the context is used after the current frame is rendered
      Future.delayed(Duration.zero, () => Navigator.pushNamed(context, NotificationDataScreen.route, arguments: payload));
    }
    // firebase notification was tapped while the app is terminated
    else if (message != null) {
      Future.delayed(Duration.zero, () => Navigator.pushNamed(context, NotificationDataScreen.route, arguments: jsonEncode(message!.data)));
    }
  }

  RemoteMessage? getRemoteMessage(BuildContext context) {
    return ModalRoute.of(context)!.settings.arguments as RemoteMessage?;
  }

  @override
  void dispose() {
    // TODO 22: cancel stream subscriptions
    localNotificationStream.cancel();
    fcmStream.cancel();
    super.dispose();
  }
}
