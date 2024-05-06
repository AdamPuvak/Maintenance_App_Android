import 'package:flutter/material.dart';
import '../PAGE-(home)/home_page.dart';
import '/utilities/globalVar.dart';
import '/login/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3500),
    );

    _fadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Interval(0.0, 0.7)));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, -0.475),
    ).animate(CurvedAnimation(parent: _controller, curve: Interval(0.7, 1.0, curve: Curves.easeInOut)));

    _controller.forward(); // Spustí animáciu

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: customYellow,
        child: Center(
          child: FadeTransition(
            opacity: _fadeInAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Image.asset(
                'images/Logo_bez_ramu.png',
                width: 500,
                height: 500,
              ),
            ),
          ),
        ),
      ),
    );
  }

}