import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../app-bar/customAppBar.dart';
import '../utilities/globalVar.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Zmena hesla',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: customDarkGrey,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _oldPasswordController,
              decoration: InputDecoration(
                labelText: 'Staré heslo',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                labelText: 'Nové heslo',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Potvrdenie nového hesla',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: changePassword,
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

  Future<void> changePassword() async {
    String oldPassword = _oldPasswordController.text;
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Nové heslá sa nezhodujú.'),
      ));
      return;
    }

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.reauthenticateWithCredential(EmailAuthProvider.credential(email: user.email!, password: oldPassword));
        await user.updatePassword(newPassword);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Heslo bolo úspešne zmenené.'),
        ));
        _oldPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
        FocusScope.of(context).unfocus();
      }

    } catch (e) {
      print('Chyba pri zmene hesla: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Chyba pri zmene hesla.'),
      ));
    }
  }
}
