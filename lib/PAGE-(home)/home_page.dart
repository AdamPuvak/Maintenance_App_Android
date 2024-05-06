import 'package:flutter/material.dart';
import 'package:maintenace/PAGE-(workplace)/workplace_page.dart';
import '../PAGE-(devices)/devices_page.dart';
import '../app-bar/customAppBar.dart';
import '/utilities/globalVar.dart';
import 'customIconButton.dart';
import '../PAGE-(schedule)/schedule_page.dart';
import '../PAGE-(records)/records_page.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(),
        body: Center(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                const Text(
                  'Menu',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: customDarkGrey,
                  ),
                ),

                SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomIconButton(
                      icon: Icons.engineering,
                      label: 'Pracovisko',
                      locationPage: () => WorkplacePage(),
                    ),
                    CustomIconButton(
                      icon: Icons.precision_manufacturing,
                      label: 'Zariadenia',
                      locationPage: () => DevicesPage(),
                    ),
                  ],
                ),

                SizedBox(height: 45),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomIconButton(
                      icon: Icons.checklist,
                      label: 'Plán',
                      locationPage: () => SchedulePage(),
                    ),
                    CustomIconButton(
                      icon: Icons.description,
                      label: 'Záznamy',
                      locationPage: () => RecordsPage(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }
}