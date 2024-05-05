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
    copyDocuments();
    //deleteDocuments();
    //deleteMaintenances();
  }

  Future<void> copyDocuments() async {
    try {
      // Získanie snapshotu pôvodnej kolekcie 'parts' z dokumentu 'kr_man_1'
      QuerySnapshot originalnaKolekcia = await FirebaseFirestore.instance
          .collection('devices')
          .doc('kr_man_1')
          .collection('parts')
          .get();

      // Pripravenie batch operácie pre efektívnejšie kopírovanie
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Iterácia cez každý dokument v pôvodnej kolekcii
      for (DocumentSnapshot dokument in originalnaKolekcia.docs) {
        DocumentReference novaReferencia = FirebaseFirestore.instance
            .collection('devices')
            .doc('kr_zvar')
            .collection('parts')
            .doc(dokument.id);  // Používame rovnaké ID dokumentu pre nový dokument

        // Pridanie operácie kopírovania do batchu
        batch.set(novaReferencia, dokument.data() as Map<String, dynamic>);
      }

      // Vykonanie všetkých operácií v batchi
      await batch.commit();

      print('Všetky dokumenty boli úspešne skopírované.');
    } catch (e) {
      print('Chyba pri kopírovaní dokumentov: $e');
    }
  }

  Future<void> deleteDocuments() async {
    try {
      // ZDROJ
      QuerySnapshot partsSnapshot = await FirebaseFirestore.instance
          .collection('devices')
          .doc('kr_zvar')
          .collection('parts')
          .get();

      // ZISKANIE VSETKYCH DOKUMENTOV V ZDROJI
      var batch = FirebaseFirestore.instance.batch(); // Create a batch operation for efficiency

      for (DocumentSnapshot partSnapshot in partsSnapshot.docs) {
        // Adding each document to the batch delete operation
        batch.delete(partSnapshot.reference);
      }

      // Committing the batch delete to remove all documents
      await batch.commit();

      print('All documents in parts collection have been deleted successfully.');
    } catch (e) {
      print('Error deleting documents: $e');
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
