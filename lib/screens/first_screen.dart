import 'dart:async';
import 'package:fcm_sample/notifications/notifications_api.dart';
import 'package:fcm_sample/screens/second_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirstScreen extends StatefulWidget {
  final RemoteMessage? message;

  const FirstScreen(this.message, {super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {

  @override
  void initState() {
    super.initState();
    // TODO 20: initialize notifications and head to the next screen
    _initNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Splash Screen')),
      body: const Center(
        child: Text('Loading..'),
      ),
    );
  }

  Future<void> _initNotifications() async {
    await NotificationsApi.initNotifications();
    WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.pushReplacementNamed(context, SecondScreen.route, arguments: widget.message));
  }
}
