import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../app-bar/customAppBar.dart';
import '../../utilities/globalVar.dart';
import '../device.dart';

class DeviceRepairs extends StatefulWidget {
  final Device device;

  const DeviceRepairs({
    super.key,
    required this.device
  });

  @override
  State<DeviceRepairs> createState() => _DeviceRepairsState();
}

class _DeviceRepairsState extends State<DeviceRepairs> {
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
                  'Opravy',
                  style: TextStyle(
                    fontSize: 26,
                    color: customSuperLightGrey,
                  ),
                ),
                SizedBox(width: 25),
              ],
            ),
          ),

          SizedBox(height: 30),

          Container(
            height: 550,
            width: 380,
            decoration: BoxDecoration(
              color: customSuperLightGrey,
              border: Border.all(color: Colors.grey, width: 3),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
            child: Scrollbar(
              thumbVisibility: true,
              child: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('devices')
                    .doc(widget.device.id)
                    .collection('faults')
                    .orderBy('date', descending: true)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final documents = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final fault = documents[index];
                        final bool isRepaired = fault['isRepaired'];

                        if (isRepaired) {
                          final date = fault['date'].toDate();
                          final formattedDate = DateFormat('dd. MM. yyyy (HH:mm)').format(date);

                          return Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: customSuperLightGrey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              style: DefaultTextStyle.of(context).style,
                                              children: [
                                                TextSpan(text: 'Dátum: ', style: TextStyle(fontWeight: FontWeight.bold,)),
                                                TextSpan(text: '$formattedDate\n'),
                                                TextSpan(text: 'Popis: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                TextSpan(text: '${fault['description']}\n'),
                                                TextSpan(text: 'Pracovník: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                TextSpan(text: '${fault['worker']}\n'),
                                                TextSpan(text: 'Stav: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                TextSpan(
                                                  text: 'Opravená',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                Divider(
                                  color: Colors.grey,
                                  thickness: 2,
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    );
                }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}