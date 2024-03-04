import 'package:flutter/material.dart';
import '../app-bar/customAppBar.dart';
import '/utilities/globalVar.dart';

class RecordsPage extends StatelessWidget {
  const RecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Text(
        'Záznamy',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: customGrey,
        ),
      ),
    );
  }
}