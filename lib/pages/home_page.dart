import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maintenace/login/login_page.dart';
import '/utilities/globalVar.dart';
import '/custom_widgets/customAppBar.dart';
import '/custom_widgets/customIconButton.dart';
import '/pages/devices_page.dart';
import '/pages/schedule_page.dart';
import '/pages/records_page.dart';
import '/pages/manual_page.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body:
        Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              const Text(
                'Menu',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: customDarkGrey,
                ),
              ),

              SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomIconButton(
                    icon: Icons.settings_rounded,
                    label: 'Zariadenia',
                    locationPage: () => DevicesPage(),
                  ),
                  CustomIconButton(
                    icon: Icons.checklist,
                    label: 'Plán',
                    locationPage: () => SchedulePage(),
                  ),
                ],
              ),

              SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomIconButton(
                    icon: Icons.description,
                    label: 'Záznamy',
                    locationPage: () => RecordsPage(),
                  ),
                  CustomIconButton(
                    icon: Icons.help,
                    label: 'Manuál',
                    locationPage: () => ManualPage(),
                  ),
                ],
              ),

              SizedBox(height: 30),
              ElevatedButton(   // DOČASNÉ
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: customDarkGrey,
                  padding: EdgeInsets.symmetric(horizontal: 150, vertical: 15), // rozmery
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Upravuje rohy tlačidla
                  ),
                ),
                child: Text(
                  'Odhlásiť',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}