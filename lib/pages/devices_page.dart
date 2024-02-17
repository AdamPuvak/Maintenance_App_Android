import 'package:flutter/material.dart';
import '/custom_widgets/customAppBar.dart';
import '/utilities/globalVar.dart';

class DevicesPage extends StatelessWidget {
  const DevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Text(
        'Zariadenia',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: customGrey,
        ),
      ),
    );
  }
}