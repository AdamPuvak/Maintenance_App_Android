import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maintenace/PAGE-(devices)/devices_page.dart';
import 'package:maintenace/firebase_options.dart';

import 'package:maintenace/PAGE-(home)/home_page.dart';
import 'package:maintenace/login/splash_screen.dart';
import 'package:maintenace/login/login_page.dart';
import 'package:maintenace/login/sign_up_page.dart';
import 'package:maintenace/utilities/temp.dart';

import 'PAGE-(devices)/subpages/part_maintenance.dart';
import 'PAGE-(workplace)/workplace_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  /*FirebaseFirestore.instance.settings = Settings(
    persistenceEnabled: true, // Povolenie offline podpory
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED, // Voliteľné: nastavenie veľkosti vyrovnávacej pamäte
  );*/
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Industry Hub',
      //home: WorkplacePage(),
      //home: HomePage(),
      //home: DevicesPage(),
      //home: Temp(),
      home: SplashScreen(),
    );
  }
}





