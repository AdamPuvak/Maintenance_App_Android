import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maintenace/PAGE-(devices)/subpages/part_maintenance.dart';
import '../../app-bar/customAppBar.dart';
import '../../utilities/globalVar.dart';
import '../device.dart';
import 'package:intl/intl.dart';

class DeviceMaintenance extends StatefulWidget {
  final Device device;

  const DeviceMaintenance({
    Key? key,
    required this.device,
  }) : super(key: key);

  @override
  State<DeviceMaintenance> createState() => _DeviceMaintenanceState();
}

class _DeviceMaintenanceState extends State<DeviceMaintenance> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: customDarkGrey,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(70),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.device.name,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: customSuperLightGrey,
                  ),
                ),
                Spacer(),
                Text(
                  'Údržba',
                  style: TextStyle(
                    fontSize: 25,
                    color: customSuperLightGrey,
                  ),
                ),
                SizedBox(width: 25),
              ],
            ),
          ),

          SizedBox(height: 40),

          Text(
            "Časti zariadenia",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            )
          ),

          SizedBox(height: 10),

          Container(
            height: 460,
            width: 380,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: Colors.grey, width: 3),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
            child: Scrollbar(
              thumbVisibility: true,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('devices')
                    .doc(widget.device.id)
                    .collection('parts')
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      var part = snapshot.data!.docs[index];

                      var data = part.data() as Map<String, dynamic>?;

                      // Ak part nemá žiadne dáta alebo atribút 'maintenance_period_days'
                      if (data == null || !data.containsKey('maintenance_period_days')) {
                        return SizedBox.shrink();
                      }

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PartMaintenance(device: widget.device, partId:part.id),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                part['name'],
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FutureBuilder<DateTime?>(
                                    future: getLastMaintenanceDate(widget.device.id, part.id),
                                    builder: (BuildContext context, AsyncSnapshot<DateTime?> dateSnapshot) {
                                      if (dateSnapshot.connectionState == ConnectionState.waiting) {
                                        return Text(
                                          'Loading...',
                                          style: TextStyle(fontSize: 16),
                                        );
                                      }
                                      DateTime? lastMaintenanceDate = dateSnapshot.data;
                                      int maintenancePeriodDays = part['maintenance_period_days'] ?? 0;
                                      // Výpočet dátumu nasledujúcej údržby
                                      DateTime? nextMaintenanceDate;
                                      if (lastMaintenanceDate != null) {
                                        nextMaintenanceDate = lastMaintenanceDate.add(Duration(days: maintenancePeriodDays));
                                      }
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (lastMaintenanceDate != null)
                                            Text(
                                              'Dátum poslednej údržby: ${DateFormat('dd. MM. yyyy').format(lastMaintenanceDate)}',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          if (nextMaintenanceDate != null)
                                            Text(
                                              'Termín najbližšej údržby: ${DateFormat('dd. MM. yyyy').format(nextMaintenanceDate)}',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                              // Add other details of part here as needed
                            ),
                            Divider(
                              color: Colors.grey,
                              thickness: 2,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );

  }
}

Future<DateTime?> getLastMaintenanceDate(String deviceId, String partId) async {
  try {
    QuerySnapshot maintenanceSnapshot = await FirebaseFirestore.instance
        .collection('devices')
        .doc(deviceId)
        .collection('parts')
        .doc(partId)
        .collection('maintenances')
        .orderBy('date', descending: true)
        .limit(1)
        .get();
    if (maintenanceSnapshot.docs.isNotEmpty) {
      return maintenanceSnapshot.docs.first['date'].toDate();
    }
  } catch (e) {
    print('Error getting last maintenance date: $e');
  }
  return null;
}