import 'dart:async';
import 'dart:convert';
import 'package:fcm_sample/notifications/notifications_api.dart';
import 'package:fcm_sample/screens/notification_data_screen.dart';
import 'package:fcm_sample/screens/second_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  final RemoteMessage? message;

  const HomeScreen(this.message, {super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final StreamSubscription<RemoteMessage> fcmStream;
  late final StreamSubscription<String> localNotificationStream;

  @override
  void initState() {
    super.initState();
    _initNotifications();
    // firebase notification was tapped while the app is terminated
    if (widget.message != null) {
      Navigator.pushNamed(context, NotificationDataScreen.route, arguments: jsonEncode(widget.message!.data));
    }
    // firebase notification was tapped while the app is in background
    fcmStream = FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      Fluttertoast.showToast(msg: 'firebase back');
      Map<String, dynamic> payload = message.data;
      Navigator.pushNamed(context, NotificationDataScreen.route, arguments: jsonEncode(payload));
    });
  }

  Future<void> _initNotifications() async {
    await NotificationsApi.initNotifications();
    NotificationAppLaunchDetails? initialNotification =
        await NotificationsApi.localNotificationsPlugin.getNotificationAppLaunchDetails();
    // local notification was tapped while the app is in background
    if (initialNotification != null && initialNotification.didNotificationLaunchApp == true) {
      Fluttertoast.showToast(msg: 'local back');
      String? payload = initialNotification.notificationResponse?.payload;
      // avoid using context across an async gap by ensuring that the context is used after the current frame is rendered
      Future.delayed(
        Duration.zero,
        () => Navigator.pushNamed(
          context,
          NotificationDataScreen.route,
          arguments: payload,
        ),
      );
    } else {
      // local notification was tapped while the app is in foreground
      localNotificationStream = NotificationsApi.notificationStream.stream.listen((payload) {
        Navigator.pushNamed(context, NotificationDataScreen.route, arguments: payload);
      });
      // TODO: uncomment this to test with this screen as a splash screen
      // Future.delayed(Durations.extralong4, () => Navigator.pushNamed(context, SecondScreen.route));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('home')),
      body: Center(
        // TODO: uncomment this to test with this screen as a splash screen
        // child: Text('Loading..'),
        // TODO: uncomment this to test with this screen as a normal screen
        child: ElevatedButton(
          child: const Text('Go to second screen'),
          onPressed: () => Navigator.pushNamed(context, SecondScreen.route),
        ),
      ),
    );
  }

  @override
  void dispose() {
    fcmStream.cancel();
    localNotificationStream.cancel();
    super.dispose();
  }
}
