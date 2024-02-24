import 'package:flutter/material.dart';
import '/custom_widgets/customAppBar.dart';
import '/utilities/globalVar.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Text(
        'Plán',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: customGrey,
        ),
      ),
    );
  }
}