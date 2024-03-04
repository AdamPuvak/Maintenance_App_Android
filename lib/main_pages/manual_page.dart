import 'package:flutter/material.dart';
import '../app-bar/customAppBar.dart';
import '/utilities/globalVar.dart';

class ManualPage extends StatelessWidget {
  const ManualPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Text(
        'Manuál',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: customGrey,
        ),
      ),
    );
  }
}