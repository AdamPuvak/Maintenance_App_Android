import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maintenace/pages/edit_profile_page.dart';
import '../login/login_page.dart';
import '../utilities/globalVar.dart';
import '/custom_widgets/customAppBar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
                'Nastavenia',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: customDarkGrey,
                ),
              ),

              SizedBox(height: 25),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfilePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: customLightGrey,
                  padding: EdgeInsets.symmetric(horizontal: 126, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: BorderSide(color: customDarkGrey)
                ),
                child: Text(
                  'Upraviť profil',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: customDarkGrey,
                    letterSpacing: 1.5,
                  ),
                ),
              ),

              SizedBox(height: 20,),

              ElevatedButton(
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

              Row(
              ),

            ],
          ),
        )
    );
  }
}