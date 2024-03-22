import 'package:flutter/material.dart';
import 'package:maintenace/utilities/globalVar.dart';
import '../app-bar/customAppBar.dart';
import 'device.dart';
import 'device_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class DevicesPage extends StatefulWidget {
  DevicesPage({Key? key}) : super(key: key);

  @override
  _DevicesPageState createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {

  late List<bool> showDetails;
  late List<Device> devices = [];

  @override
  void initState() {
    super.initState();
    showDetails = List<bool>.generate(devices.length, (index) => false);
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
        showDetails = List<bool>.generate(devices.length, (index) => false);
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
              const Text(
                'Zariadenia',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: customDarkGrey,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: devices.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          constraints: BoxConstraints(maxWidth: 370), // max. šírka prvku
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            title: Row(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage: AssetImage(devices[index].imageUrl),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Text(
                                    devices[index].name,
                                    style: TextStyle(
                                      color: customDarkGrey,
                                      fontSize: 24,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      showDetails[index] = !showDetails[index];
                                    });
                                  },
                                  child: Icon(
                                    Icons.arrow_downward,
                                  ),
                                ),
                              ],
                            ),

                            subtitle: showDetails[index]
                              ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 25,),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: customSuperLightGrey,
                                        border: Border.all(color: customBlue, width: 3),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        'Údržba:',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: customBlue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    Spacer(),

                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: customSuperLightGrey,
                                        border: Border.all(color: customRed, width: 3),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        'Poruchy:',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: customRed,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Spacer(), // Medzera, aby sa druhý widget posunul na stred riadku
                                  ],
                                ),

                                SizedBox(height: 25,),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => DeviceDetail(device: devices[index])),
                                        );
                                      },
                                      child: Text(
                                        'DETAIL',
                                        style: TextStyle(
                                          fontSize: 20,
                                          decoration: TextDecoration.underline,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                              : null,
                          ),
                        ),
                        SizedBox(height: 15),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
