import 'package:flutter/material.dart';
import '/custom_widgets/customAppBar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: Text('Nastavenia'),
      ),
    );
  }
}