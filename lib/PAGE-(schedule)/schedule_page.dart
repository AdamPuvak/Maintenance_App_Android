import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../PAGE-(devices)/device.dart';
import '../PAGE-(devices)/subpages/part_maintenance.dart';
import '../app-bar/customAppBar.dart';
import '/utilities/globalVar.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});


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
                'Plán',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: customDarkGrey,
                ),
              ),
              SizedBox(height: 10,),
              FutureBuilder<List<MaintenanceRecord>>(
                future: loadMaintenanceData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        headingRowColor: MaterialStateColor.resolveWith((states) => customDarkGrey),
                        dataRowColor: MaterialStateColor.resolveWith((states) => customLightGrey),
                        columnSpacing: 20.0,
                        columns: [
                          DataColumn(
                            label: Text(
                              'Dátum',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Zariadenie',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: 150,
                              child: Text(
                                'Časť',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                            //numeric: true,
                          ),
                        ],
                        rows: snapshot.data!
                            .take(15)
                            .map(
                              (record) => DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  DateFormat('dd.MM.yyyy').format(record.nextMaintenanceDate),
                                ),
                              ),
                              DataCell(
                                Text(
                                  record.device.name,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                    width: 150,
                                    child: InkWell(
                                      onTap: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => PartMaintenance(device: record.device, partId: record.partId)),
                                        );
                                      },
                                      child: Text(
                                        record.partName,
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    )
                                ),
                              ),
                            ],
                          ),
                        )
                            .toList(),
                      )
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*Future<Device?> getDeviceByName(String deviceName) async {
    QuerySnapshot deviceSnapshot = await FirebaseFirestore.instance
        .collection('devices')
        .where('name', isEqualTo: deviceName)
        .limit(1)
        .get();
    if (deviceSnapshot.docs.isNotEmpty) {
      var deviceData = deviceSnapshot.docs.first.data();
      if (deviceData != null) {
        Map<String, dynamic> deviceMap = deviceData as Map<String, dynamic>;
        String id = deviceData['id'] ?? '';
        String name = deviceData['name'] ?? '';
        String imageUrl = deviceData['imageUrl'] ?? '';
        String info1 = deviceData['info1'] ?? '';
        String info2 = deviceData['info2'] ?? '';
        String info3 = deviceData['info3'] ?? '';

        if (id.isNotEmpty || name.isNotEmpty || imageUrl.isNotEmpty || info1.isNotEmpty || info2.isNotEmpty || info3.isNotEmpty) {
          return Device(
            id: id,
            name: name,
            imageUrl: imageUrl,
            info1: info1,
            info2: info2,
            info3: info3,
          );
        }
      }
      return null;

    } else {
      return null;
    }
  }*/

  /*Future<String?> getPartIdByName(Device device, String partName) async {
    String deviceId = device.id;
    QuerySnapshot partsSnapshot = await FirebaseFirestore.instance
        .collection('devices')
        .doc(deviceId)
        .collection('parts')
        .where('name', isEqualTo: partName)
        .limit(1)
        .get();

    if (partsSnapshot.docs.isNotEmpty) {
      var partData = partsSnapshot.docs.first.data();
      if (partData != null) {
        Map<String, dynamic> partMap = partData as Map<String, dynamic>;
        return partData['id'];
      }
      return null;
    } else {
      return null;
    }
  }*/

}

Future<List<MaintenanceRecord>> loadMaintenanceData() async {
  List<MaintenanceRecord> records = [];
  CollectionReference devices = FirebaseFirestore.instance.collection('devices');

  QuerySnapshot deviceSnapshot = await devices.get();
  for (var deviceDoc in deviceSnapshot.docs) {
    var parts = deviceDoc.reference.collection('parts');
    QuerySnapshot partSnapshot = await parts.get();
    for (var partDoc in partSnapshot.docs) {
      var maintenances = partDoc.reference.collection('maintenances');
      QuerySnapshot maintenanceSnapshot = await maintenances.orderBy('date', descending: true).limit(1).get();
      if (maintenanceSnapshot.docs.isNotEmpty) {
        var maintenanceDoc = maintenanceSnapshot.docs.first;
        DateTime nextMaintenanceDate = (maintenanceDoc['date'] as Timestamp).toDate().add(Duration(days: partDoc['maintenance_period_days']));


        Device device = Device(
          id: deviceDoc.id,
          name: deviceDoc['name'],
          imageUrl: deviceDoc['imageUrl'],
          info1: deviceDoc['info1'],
          info2: deviceDoc['info2'],
          info3: deviceDoc['info3'],
        );

        records.add(MaintenanceRecord(
          device: device,
          partId: partDoc.id,
          partName: partDoc['name'],
          nextMaintenanceDate: nextMaintenanceDate,
        ));
      }
    }
  }

  records.sort((a, b) => a.nextMaintenanceDate.compareTo(b.nextMaintenanceDate));

  return records;
}

class MaintenanceRecord {
  final Device device;
  final String partId;
  final String partName;
  final DateTime nextMaintenanceDate;

  MaintenanceRecord({
    required this.device,
    required this.partId,
    required this.partName,
    required this.nextMaintenanceDate,
  });
}