import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hemenyukle/bussinnes/work_list.dart';
import 'package:hemenyukle/widgets/app_color.dart';
import 'package:hemenyukle/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    if (auth.currentUser != null) {
      print(':::::::::::::::User login with uid: ${auth.currentUser!.uid}');
      Timer(
          const Duration(seconds: 1),
          () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => const WorkList())));
    } else {
      print(':::::::::::::::User not login.');
      Timer(
          const Duration(seconds: 3),
          () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => const Home())));
    }
    return Scaffold(
      backgroundColor: const AppColors().primary,
      body: Center(
        child: Image.asset(
          'assets/images/logo-2.png',
          height: 250,
        ),
      ),
    );
  }
}
