import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glitched/screens/onBoarding/intro_Screen.dart';

import 'firebase_options.dart';
import '../../screens/splash/splash_screen.dart';
import 'controller/home/home_controller.dart'; // 🔥 Sahi controller file ka import path

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🔥 THE ULTIMATE FIX: Isko permanent true kar ke put kar dein
  // Ab back flow mein GetX isey kabhi delete nahi kar sakega!
  Get.put(HomeViewModel(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Glitched',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}