import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {

  static const String route = "/second";

  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RemoteMessage message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    String body = (message.notification?.body)!;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(
          body,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}