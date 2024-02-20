import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:maintenace/firebase_options.dart';

import 'package:maintenace/pages/home_page.dart';
import 'package:maintenace/login/splash_screen.dart';
import 'package:maintenace/login/login_page.dart';
import 'package:maintenace/login/sign_up_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Industry Hub',
      //home: HomePage(),
      home: SplashScreen(),
    );
  }
}





