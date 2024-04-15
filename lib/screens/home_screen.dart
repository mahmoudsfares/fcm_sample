import 'dart:async';
import 'package:fcm_sample/notifications/notifications_api.dart';
import 'package:fcm_sample/screens/second_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final RemoteMessage? message;

  const HomeScreen(this.message, {super.key});

  // TODO 20: define the stream subscriptions for both FCMs and local notifications to cancel them on dispose
  // late final StreamSubscription<RemoteMessage> fcmStream;
  // late final StreamSubscription<String> localNotificationStream;

  // TODO 22: initialize notifications and navigate to post-splash screen
  Future<void> _initNotifications(BuildContext context) async {
    await NotificationsApi.initNotifications();
    Future.delayed(Durations.extralong4, () => Navigator.pushReplacementNamed(context, SecondScreen.route, arguments: message));
  }

  @override
  Widget build(BuildContext context) {
    // TODO 21: call these on init to initialize the notifications
    _initNotifications(context);
    return Scaffold(
      appBar: AppBar(title: const Text('home')),
      body: const Center(
        child: Text('Loading..'),
      ),
    );
  }

  // @override
  // void dispose() {
  //   // TODO 23: cancel stream subscriptions
  //   // localNotificationStream.cancel();
  //   // fcmStream.cancel();
  //   super.dispose();
  // }
}
