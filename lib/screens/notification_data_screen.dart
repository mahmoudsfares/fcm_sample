import 'dart:convert';

import 'package:flutter/material.dart';

class NotificationDataScreen extends StatelessWidget {

  static const String route = "/notificationData";

  const NotificationDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String text = decodePayload(context)['text'];
    return Scaffold(
      appBar: AppBar(title: const Text('notification data')),
      body: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  // TODO 24: format the string payload as required
  Map<String, dynamic> decodePayload(BuildContext context){
    String payload = ModalRoute.of(context)!.settings.arguments as String;
    Map<String, dynamic> payloadMap = jsonDecode(payload);
    return payloadMap;
  }
}