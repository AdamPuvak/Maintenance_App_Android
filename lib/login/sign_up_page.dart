import 'package:flutter/material.dart';
import '../PAGE-(home)/home_page.dart';
import '/login/customInputField.dart';
import '/login/login_page.dart';
import '/utilities/globalVar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_auth_services.dart';



class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: customYellow,
        child: Column(
          children: [
            SizedBox(height: 91,),

            Image.asset(
              'images/Logo_bez_ramu.png',
            ),

            SizedBox(height: 10,),

            Text(
              'Registrácia',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: customDarkGrey,
              ),
            ),

            SizedBox(height: 10,),

            CustomInputField(
              labelText: 'Meno',
              controller: _nameController,
            ),

            CustomInputField(
              labelText: 'Priezvisko',
              controller: _surnameController,
            ),

            CustomInputField(
              labelText: 'Email',
              controller: _emailController,
            ),

            CustomInputField(
              labelText: 'Heslo',
              controller: _passwordController,
              isPasswordField: true,
            ),

            SizedBox(height: 20,),

            ElevatedButton(
              onPressed: _singUp,
              style: ElevatedButton.styleFrom(
                primary: customDarkGrey,
                padding: EdgeInsets.symmetric(horizontal: 120, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Zaregistrovať',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
            ),

            //SizedBox(height: 10,),

            SizedBox(height: 2,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Už máte účet?',
                  style: TextStyle(
                    fontSize: 19,
                    color: customDarkGrey,
                  ),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text(
                    'Prihlásiť sa',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _singUp() async {
    String name = _nameController.text;
    String surname = _surnameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      await user?.updateDisplayName('$name $surname');

      print("User is successfully created");

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      print("Error occurred: $e");
    }
  }

}
