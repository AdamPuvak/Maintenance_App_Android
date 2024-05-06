import 'package:flutter/material.dart';
import '/utilities/globalVar.dart';
import 'customInputField.dart';
import 'firebase_auth_services.dart';


class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {

  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: customYellow,
        child: Column(
          children: [
            SizedBox(height: 91,),
            Image.asset('images/Logo_bez_ramu.png'),
            SizedBox(height: 10,),
            Text(
              'Reset hesla',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: customDarkGrey,
              ),
            ),
            SizedBox(height: 10,),

            CustomInputField(
              labelText: 'Email',
              controller: _emailController,
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                String email = _emailController.text;
                bool isEmailSent = await _auth.resetPassword(email);

                if (isEmailSent) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Nové heslo bolo odoslané na váš email.'),
                    backgroundColor: Colors.green,
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Email nie je pripojený k žiadnemu účtu.'),
                    backgroundColor: Colors.red,
                  ));
                }
                _emailController.clear();
                FocusScope.of(context).unfocus();
              },
              style: ElevatedButton.styleFrom(
                primary: customDarkGrey,
                padding: EdgeInsets.symmetric(horizontal: 145, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Resetovať',
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
      ),
    );
  }
}

