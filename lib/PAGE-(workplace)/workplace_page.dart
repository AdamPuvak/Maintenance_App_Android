import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../PAGE-(devices)/device.dart';
import '../PAGE-(devices)/device_detail.dart';
import '../app-bar/customAppBar.dart';
import '/utilities/globalVar.dart';

class WorkplacePage extends StatefulWidget {
  WorkplacePage({super.key});

  @override
  State<WorkplacePage> createState() => _WorkplacePageState();
}

class _WorkplacePageState extends State<WorkplacePage> {
  late List<Device> devices = [];

  @override
  void initState() {
    super.initState();
    loadDevices();
  }

  Future<void> loadDevices() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('devices')
          .get();

      List<Device> fetchedDevices = querySnapshot.docs.map((doc) {
        return Device(
          id: doc.id,
          name: doc['name'],
          imageUrl: doc['imageUrl'],
          info1: doc['info1'],
          info2: doc['info2'],
          info3: doc['info3'],
        );
      }).toList();

      setState(() {
        devices = fetchedDevices;
      });
    } catch (e) {
      print('Error loading devices: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Text(
                'Pracovisko',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: customDarkGrey,
                ),
              ),
              SizedBox(height: 20),

              Stack(
                children: [
                  Image.asset(
                    'images/workplace_plan.jpg',
                    width: 400,
                    height: 400,
                  ),
                  Positioned(
                    left: 82,
                    top: 180,
                    child: GestureDetector(
                      onTap: () {
                        //MaterialPageRoute(builder: (context) => DeviceDetail(device: devices[1]));
                      },
                      child: Container(
                        width: 50,
                        height: 28,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}
