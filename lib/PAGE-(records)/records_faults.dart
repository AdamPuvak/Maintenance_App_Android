import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../app-bar/customAppBar.dart';
import '/utilities/globalVar.dart';

class RecordsFaults extends StatefulWidget {
  const RecordsFaults({Key? key}) : super(key: key);

  @override
  _RecordsFaultsState createState() => _RecordsFaultsState();
}

class _RecordsFaultsState extends State<RecordsFaults> {
  bool isDataLoaded = false;
  List<Map<String, dynamic>> faultsArray = [];

  @override
  void initState() {
    super.initState();
    fetchFaults();
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
                'Poruchy',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: customDarkGrey,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: isDataLoaded
                    ? (faultsArray.isEmpty
                    ? ListView(children: [Text('Žiadne neopravené poruchy')])
                    : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    height: MediaQuery.of(context).size.height * 0.7,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: customDarkGrey,
                        width: 3.0,
                      ),
                    ),
                    child: ListView.builder(
                      itemCount: faultsArray.length > 15 ? 15 : faultsArray.length,
                      itemBuilder: (context, index) {
                        var fault = faultsArray[index];
                        return Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${fault['deviceName']}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: customDarkGrey,
                                                ),
                                              ),
                                              Text(
                                                DateFormat('dd. MM. yyyy (HH:mm)').format(fault['date']),
                                                style: TextStyle(
                                                  color: customDarkGrey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Divider(
                                            color: customDarkGrey,
                                            thickness: 1.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (fault['description'] != null && fault['description'] != '')
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Popis: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: customDarkGrey,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          fault['description'],
                                          style: TextStyle(
                                            color: customDarkGrey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                SizedBox(height: 4),
                                if (fault['worker'] != null && fault['worker'] != '')
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Pracovník: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: customDarkGrey,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          fault['worker'],
                                          style: TextStyle(
                                            color: customDarkGrey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                SizedBox(height: 4),
                                if (fault['category'] != null && fault['category'] != '' && fault['code'] != null && fault['code'] != '')
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Kód: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: customDarkGrey,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${fault['category']} - ${fault['code']}',
                                          style: TextStyle(
                                            color: customDarkGrey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ))
                    : Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchFaults() async {
    try {
      QuerySnapshot deviceSnapshot =
      await FirebaseFirestore.instance.collection('devices').get();

      for (var deviceDoc in deviceSnapshot.docs) {
        var faultsSnapshot =
        await deviceDoc.reference.collection('faults').get();
        List<QueryDocumentSnapshot> faults = faultsSnapshot.docs;

        for (var fault in faults) {
          if (!(fault['isRepaired'] ?? false)) {
            faultsArray.add({
              'deviceName': deviceDoc['name'],
              'date': (fault['date'] as Timestamp).toDate(),
              'description': fault['description'],
              'worker': fault['worker'],
              'category': fault['category'],
              'code': fault['code'],
            });
          }
        }
      }

      faultsArray.sort((a, b) {
        DateTime dateA = a['date'] as DateTime;
        DateTime dateB = b['date'] as DateTime;
        return dateA.compareTo(dateB);
      });

      setState(() {
        isDataLoaded = true;
      });
    } catch (error) {
      print('Error fetching faults: $error');
    }
  }

}
