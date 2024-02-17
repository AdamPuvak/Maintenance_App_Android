import 'package:flutter/material.dart';
import '/custom_widgets/customAppBar.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: Text('Oznámenia'),
      ),
    );
  }
}