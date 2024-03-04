import 'package:flutter/material.dart';
import 'customAppBar.dart';


class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: Text(
          "Upraviť profil",
        ),
      ),
    );
  }
}
