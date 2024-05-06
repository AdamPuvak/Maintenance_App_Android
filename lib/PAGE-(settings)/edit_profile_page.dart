import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../app-bar/customAppBar.dart';
import '../utilities/globalVar.dart';
import 'change_password.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Upraviť profil',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: customDarkGrey,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Meno',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _surnameController,
              decoration: InputDecoration(
                labelText: 'Priezvisko',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: customLightGrey,
                minimumSize: Size(400, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(color: Colors.black),
                ),
              ),
              child: Text(
                'Zmeniť heslo',
                style: TextStyle(
                  fontSize: 18,
                  color: customDarkGrey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 30),
            TextButton(
              onPressed: saveUserData,
              style: TextButton.styleFrom(
                backgroundColor: customYellow,
                minimumSize: Size(100, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.black),
                ),
              ),
              child: Text(
                'Uložiť',
                style: TextStyle(
                  fontSize: 18,
                  color: customDarkGrey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _nameController.text = user.displayName?.split(" ").first ?? "";
        _surnameController.text = user.displayName?.split(" ").last ?? "";
      });
    }
  }

  Future<void> saveUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateDisplayName('${_nameController.text} ${_surnameController.text}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Údaje boli úspešne uložené.'),
        ));
        FocusScope.of(context).unfocus();
      }
    } catch (e) {
      print('Chyba pri ukladaní údajov: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Chyba pri ukladaní údajov.'),
      ));
    }
  }
}


