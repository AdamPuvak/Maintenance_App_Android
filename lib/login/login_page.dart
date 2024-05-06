import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maintenace/login/customInputField.dart';
import 'package:maintenace/login/reset_password_page.dart';
import 'firebase_auth_services.dart';
import '../PAGE-(home)/home_page.dart';
import '/login/sign_up_page.dart';
import '/utilities/globalVar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    checkUserLoggedInState();
  }

  Future<void> checkUserLoggedInState() async {
    bool isLoggedIn = await getUserLoggedInState();
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
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

            SizedBox(height: 60,),

            Text(
              'Prihlásenie',
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

            CustomInputField(
              labelText: 'Heslo',
              controller: _passwordController,
              isPasswordField: true,
            ),
            SizedBox(height: 20,),

            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                primary: customDarkGrey,
                padding: EdgeInsets.symmetric(horizontal: 150, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Príhlásiť',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
            ),

            SizedBox(height: 2,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Nemáte účet?',
                  style: TextStyle(
                    fontSize: 19,
                    color: customDarkGrey,
                  ),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: Text(
                    'Zaregistrovať sa',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ],
            ),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResetPasswordPage()),
                );
              },
              child: Text(
                'Zabudol som heslo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    if (user != null) {
      print("User is logged in successfuly");
      await saveUserLoggedInState(true); // Save user login state
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
    else {
      print("Incorrect credentials");
      _passwordController.clear();
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Nesprávne prihlasovacie údaje'),
        backgroundColor: Colors.red,
      ));
    }
  }
}

Future<void> saveUserLoggedInState(bool isLoggedIn) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', isLoggedIn);
}

Future<bool> getUserLoggedInState() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
}
