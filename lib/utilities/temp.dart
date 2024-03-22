import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../PAGE-(devices)/device.dart';


class Temp extends StatefulWidget {
  Temp({Key? key}) : super(key: key);

  @override
  _TempState createState() => _TempState();
}

class _TempState extends State<Temp> {

  late List<Device> devices = [];

  @override
  void initState() {
    super.initState();
    //loadDevices();
    //copyDocuments();
    //deleteMaintenances();
  }

  Future<void> copyDocuments() async {
    try {
      // ZDROJ
      QuerySnapshot maintenancesSnapshot = await FirebaseFirestore.instance
          .collection('devices')
          .doc('kr_man_1')
          .collection('parts')
          .doc('gwa_1')
          .collection('maintenances')
          .get();

      // ZISKANIE VSETKYCH DOKUMENTOV V ZDROJI
      for (DocumentSnapshot maintenanceSnapshot in maintenancesSnapshot.docs) {
        // Získanie údajov zo zdrojového dokumentu
        Map<String, dynamic> maintenanceData = maintenanceSnapshot.data() as Map<String, dynamic>;

        // Prechádzanie cieľových dokumentov v kolekcii parts
        QuerySnapshot partsSnapshot = await FirebaseFirestore.instance
            .collection('devices')
            .doc('kr_man_1')
            .collection('parts')
            .get();

        for (DocumentSnapshot partSnapshot in partsSnapshot.docs) {
          // CIEL
          await FirebaseFirestore.instance
              .collection('devices')
              .doc('kr_man_2')
              .collection('parts')
              .doc(partSnapshot.id)
              .collection('maintenances')
              .doc(maintenanceSnapshot.id)
              .set(maintenanceData);
        }
      }
    } catch (e) {
      print('Error copying maintenances: $e');
    }
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

  Future<void> deleteMaintenances() async {
    try {
      QuerySnapshot devicesSnapshot = await FirebaseFirestore.instance.collection('devices').get();

      for (QueryDocumentSnapshot deviceDoc in devicesSnapshot.docs) {
        String deviceId = deviceDoc.id;

        QuerySnapshot partsSnapshot = await deviceDoc.reference.collection('parts').get();

        for (QueryDocumentSnapshot partDoc in partsSnapshot.docs) {
          String partId = partDoc.id;

          await partDoc.reference.collection('maintenances').get().then((snapshot) {
            for (DocumentSnapshot doc in snapshot.docs) {
              doc.reference.delete();
            }
          });
        }
      }
    } catch (error) {
      print("chyba");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "USPECH",
        ),
      ),
    );
  }
}
