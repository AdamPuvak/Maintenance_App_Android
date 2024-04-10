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
      body: devices.isNotEmpty ? _buildBody() : Container(),
    );
  }

  Widget _buildBody() {
    return Center(
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

            SizedBox(height: 10),

            Stack(
              children: [
                Image.asset(
                  'images/workplace_plan.jpg',
                  width: 420,
                  height: 420,
                ),
                DeviceContainer(left: 71, top: 188, width: 58, height: 34, device: devices[0]),
                DeviceContainer(left: 294, top: 188, width: 58, height: 34, device: devices[1]),
                DeviceContainer(left: 182, top: 99, width: 57, height: 30, device: devices[2]),
                DeviceContainer(left: 185, top: 0, width: 111, height: 29, device: devices[3]),
                DeviceContainer(left: 190, top: 175, width: 40, height: 28, device: devices[4]),
                DeviceContainer(left: 110, top: 335, width: 50, height: 32, device: devices[5]),
                DeviceContainer(left: 189, top: 352, width: 50, height: 32, device: devices[5]),
                DeviceContainer(left: 70, top: 101, width: 50, height: 32, device: devices[6]),
                DeviceContainer(left: 294, top: 104, width: 50, height: 32, device: devices[6]),
              ],
            ),

            SizedBox(height: 30),

            Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: 20),
                    Container(
                      width: 40,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      "  - normálny stav",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    SizedBox(width: 20),
                    Container(
                      width: 40,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 213, 0, 1),
                      ),
                    ),
                    Text(
                      "  - potrebná údržba",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    SizedBox(width: 20),
                    Container(
                      width: 40,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      "  - aktuálna porucha",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    SizedBox(width: 20),
                    Container(
                      width: 40,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 213, 0, 1),
                        border: Border.all(
                          color: Colors.red,
                          width: 5,
                        ),
                      ),
                    ),
                    Text(
                      "  -  porucha + údržba",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DeviceContainer extends StatelessWidget {
  final double left;
  final double top;
  final double width;
  final double height;
  final Device device;

  const DeviceContainer({
    Key? key,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.device,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => DeviceDetail(device: device)),
          );
        },
        child: FutureBuilder<bool>(
          future: hasFault(device),
          builder: (context, faultSnapshot) {
            return FutureBuilder<bool>(
              future: hasMaintenance(device),
              builder: (context, maintenanceSnapshot) {
                bool hasFault = faultSnapshot.hasData && faultSnapshot.data!;
                bool hasMaintenance = maintenanceSnapshot.hasData && maintenanceSnapshot.data!;
                if (hasFault && hasMaintenance) {
                  return _buildContainer(Color.fromRGBO(255, 213, 0, 0.3), Colors.red, 4);
                } else if (hasFault) {
                  return _buildContainer(Colors.red.withOpacity(0.4), Colors.red, 2);
                } else if (hasMaintenance) {
                  return _buildContainer(Color.fromRGBO(255, 213, 0, 0.3), Color.fromRGBO(255, 213, 0, 1), 4);
                } else {
                  return _buildContainer(Colors.blue.withOpacity(0.2), Colors.blue, 2);
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildContainer(Color color, Color borderColor, double borderWidth) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
      ),
    );
  }
}

Future<bool> hasFault(Device device) async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('devices')
        .doc(device.id)
        .collection('faults')
        .get();

    for (QueryDocumentSnapshot fault in snapshot.docs) {
      bool isRepaired = fault['isRepaired'];

      if (!isRepaired) {
        return true;
      }
    }

    return false;
  } catch (error) {
    print('Chyba při načítání dat z databáze: $error');
    return false;
  }
}

Future<bool> hasMaintenance(Device device) async {
  try {
    final DateTime? nearestMaintenanceDate = await getNearestMaintenanceDate(device.id);

    if (nearestMaintenanceDate != null) {
      final DateTime currentDate = DateTime.now();
      final DateTime currentDay = DateTime(currentDate.year, currentDate.month, currentDate.day);
      final DateTime maintenanceDay = DateTime(nearestMaintenanceDate.year, nearestMaintenanceDate.month, nearestMaintenanceDate.day);

      if (maintenanceDay.isAtSameMomentAs(currentDay) || maintenanceDay.isBefore(currentDay)) {
        return true;
      }
    }
    return false;
  } catch (error) {
    print('Chyba pri zisťovaní údržby: $error');
    return false;
  }
}

