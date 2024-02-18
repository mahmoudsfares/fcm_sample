import 'package:fcm_sample/screens/second.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: uncomment this to test with this screen as a splash screen
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, SecondScreen.route);
    });
    return Scaffold(
      appBar: AppBar(title: const Text('home')),
      body: Center(
        // TODO: uncomment this to test with this screen as a splash screen
        child: Text('Loading..'),
        // TODO: uncomment this to test with this screen as a normal screen
        // child: ElevatedButton(
        //   child: const Text('Go to second screen'),
        //   onPressed: () => Navigator.pushNamed(context, SecondScreen.route),
        // ),
      ),
    );
  }
}
