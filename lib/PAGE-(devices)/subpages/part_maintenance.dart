import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../app-bar/customAppBar.dart';
import '../../utilities/globalVar.dart';
import '../device.dart';
import '../part.dart';
import 'package:intl/intl.dart';


class PartMaintenance extends StatefulWidget {
  final Device device;
  final String partId;

  const PartMaintenance({
    super.key,
    required this.device,
    required this.partId,
  });

  @override
  State<PartMaintenance> createState() => _PartMaintenanceState();
}

class _PartMaintenanceState extends State<PartMaintenance> {
  late Part part;
  TextEditingController _dateController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _workerController = TextEditingController();
  bool _isDateErrorVisible = false;

  @override
  void initState() {
    super.initState();
    fetchPartData();
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

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
                    fontSize: 26,
                    color: customSuperLightGrey,
                  ),
                ),
                SizedBox(width: 25),
              ],
            ),
          ),

          SizedBox(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 30),
              Expanded(
                child: Text(
                  part.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'Popis',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('devices')
                              .doc(widget.device.id)
                              .collection('parts')
                              .doc(widget.partId)
                              .get(),
                          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Nastala chyba: ${snapshot.error}');
                            }
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (!snapshot.hasData || snapshot.data == null) {
                              return Text('Nenašli sa žiadne údaje');
                            }
                            var description = snapshot.data!['maintenance_description'] ?? 'Žiadny popis';
                            return Text(
                              description,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            );
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Zavrieť',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Icon(
                  Icons.help,
                  size: 40,
                  color: customDarkGrey,
                ),
              ),
              SizedBox(width: 30),
            ],
          ),



          SizedBox(height: 10),

          Container(
            height: 400,
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
                    .collection('parts')
                    .doc(widget.partId)
                    .collection('maintenances')
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
                        final maintenance = documents[index];
                        final date = maintenance['date'].toDate();
                        final formattedDate = DateFormat('dd. MM. yyyy (HH:mm)').format(date);
                        final creationDate = maintenance['createdAt'].toDate();
                        final formattedCreationDate = DateFormat('dd. MM. yyyy').format(creationDate);

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
                                              TextSpan(text: 'Dátum údržby: ', style: TextStyle(fontWeight: FontWeight.bold,)),
                                              TextSpan(text: '$formattedDate\n'),
                                              TextSpan(text: 'Popis: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                              TextSpan(text: '${maintenance['description']}\n'),
                                              TextSpan(text: 'Pracovník: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                              TextSpan(text: '${maintenance['worker']}\n'),
                                              TextSpan(text: 'Zaznamenané: ', style: TextStyle(fontSize: 13)),
                                              TextSpan(text: '$formattedCreationDate'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //---------------------------- Edit/Delete maintenance
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return StatefulBuilder(
                                            builder: (BuildContext context, StateSetter setState) {
                                              DateTime existingDate = maintenance['date'].toDate();
                                              String formattedDate = DateFormat('dd. MM. yyyy (HH:mm)').format(existingDate);
                                              String existingDescription = maintenance['description'];
                                              String existingWorker = maintenance['worker'];


                                              _dateController.text = formattedDate;
                                              _descriptionController.text = existingDescription;
                                              _workerController.text = existingWorker;

                                              return AlertDialog(
                                                title: Text('Upraviť záznam'),
                                                content: Container(
                                                  width: 300,
                                                  height: 250,
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: <Widget>[
                                                      TextFormField(
                                                        controller: _dateController,
                                                        decoration: InputDecoration(
                                                          labelText: 'Dátum údržby',
                                                          labelStyle: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                        readOnly: true,
                                                        onTap: () async {
                                                          DateTime? pickedDate = await showDatePicker(
                                                            context: context,
                                                            initialDate: existingDate,
                                                            firstDate: DateTime(2000),
                                                            lastDate: DateTime(2025),
                                                          );

                                                          if (pickedDate != null) {
                                                            String formattedDate = DateFormat('dd. MM. yyyy').format(pickedDate);
                                                            setState(() {
                                                              _dateController.text = formattedDate;
                                                            });

                                                            TimeOfDay? pickedTime = await showTimePicker(
                                                              context: context,
                                                              initialTime: TimeOfDay.fromDateTime(existingDate),
                                                            );

                                                            if (pickedTime != null) {
                                                              final now = DateTime.now();
                                                              final dt = DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
                                                              String formattedTime = DateFormat('HH:mm').format(dt);
                                                              _dateController.text = '$formattedDate ($formattedTime)';
                                                            }
                                                          }
                                                        },
                                                      ),
                                                      TextField(
                                                        controller: _descriptionController,
                                                        decoration: InputDecoration(
                                                          labelText: 'Popis',
                                                          labelStyle: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                      ),
                                                      TextField(
                                                        controller: _workerController,
                                                        decoration: InputDecoration(
                                                          labelText: 'Pracovník',
                                                          labelStyle: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () async {
                                                      try {
                                                        await FirebaseFirestore.instance
                                                            .collection('devices')
                                                            .doc(widget.device.id)
                                                            .collection('parts')
                                                            .doc(widget.partId)
                                                            .collection('maintenances')
                                                            .doc(maintenance.id)
                                                            .delete();

                                                        Navigator.of(context).pop();

                                                        await fetchPartData();

                                                      } catch (error) {
                                                        print('Chyba při mazání záznamu: $error');
                                                      }
                                                    },
                                                    style: TextButton.styleFrom(
                                                      backgroundColor: Colors.red,
                                                      minimumSize: Size(100, 50),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                        side: BorderSide(color: Colors.black),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      'Vymazať',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      setState(() {
                                                        _isDateErrorVisible = false;
                                                      });
                                                      String date = _dateController.text;
                                                      String description = _descriptionController.text;
                                                      String worker = _workerController.text;

                                                      try {
                                                        DateTime parsedDate = DateFormat('dd. MM. yyyy (HH:mm)').parse(date);
                                                        Timestamp timestamp = Timestamp.fromDate(parsedDate);

                                                        await FirebaseFirestore.instance
                                                            .collection('devices')
                                                            .doc(widget.device.id)
                                                            .collection('parts')
                                                            .doc(widget.partId)
                                                            .collection('maintenances')
                                                            .doc(maintenance.id)
                                                            .update({
                                                          'date': timestamp,
                                                          'description': description,
                                                          'worker': worker,
                                                        });

                                                        Navigator.of(context).pop();

                                                        await fetchPartData();

                                                      } catch (error) {
                                                        print('Chyba pri aktualizácií záznamu: $error');
                                                      }
                                                    },
                                                    style: TextButton.styleFrom(
                                                      backgroundColor: customYellow,
                                                      minimumSize: Size(100, 50),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                        side: BorderSide(color: Colors.black),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      'Uložiť',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color: customDarkGrey,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
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
                      },
                    );
                  }
                },
              ),
            ),
          ),

          SizedBox(height: 20),

          //------------------------------ Create maintenance
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      _dateController.text = "";
                      _descriptionController.text = "";
                      _workerController.text = "";
                      return AlertDialog(
                        title: Text(
                          'Vykonať údržbu',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),

                        ),
                        content: Container(
                          width: 300,
                          height: 300,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextFormField(
                                controller: _dateController,
                                decoration: InputDecoration(
                                  labelText: 'Dátum údržby',
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  errorText: _isDateErrorVisible ? 'Musíte zadať dátum a čas' : null,
                                ),
                                readOnly: true,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2025),
                                  );

                                  if (pickedDate != null) {
                                    String formattedDate = DateFormat('dd. MM. yyyy').format(pickedDate);
                                    setState(() {
                                      _dateController.text = formattedDate;
                                    });

                                    TimeOfDay? pickedTime = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );

                                    if (pickedTime != null) {
                                      final now = DateTime.now();
                                      final dt = DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
                                      String formattedTime = DateFormat('HH:mm').format(dt);
                                      _dateController.text = '$formattedDate ($formattedTime)';
                                    }
                                  }
                                },
                              ),

                              TextField(
                                controller: _descriptionController,
                                decoration: InputDecoration(
                                  labelText: 'Popis',
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),

                              TextField(
                                controller: _workerController,
                                decoration: InputDecoration(
                                  labelText: 'Pracovník',
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () async {
                              if (_dateController.text.isEmpty) {
                                setState(() {
                                  _isDateErrorVisible = true;
                                });
                              } else {
                                setState(() {
                                  _isDateErrorVisible = false;
                                });
                                String date = _dateController.text;
                                String description = _descriptionController.text;
                                String worker = _workerController.text;

                                try {
                                  DateTime parsedDate = DateFormat('dd. MM. yyyy (HH:mm)').parse(date);
                                  Timestamp timestamp = Timestamp.fromDate(parsedDate);

                                  DateTime now = DateTime.now();
                                  Timestamp createdAt = Timestamp.fromDate(now);

                                  await FirebaseFirestore.instance
                                      .collection('devices')
                                      .doc(widget.device.id)
                                      .collection('parts')
                                      .doc(widget.partId)
                                      .collection('maintenances')
                                      .add({
                                    'date': timestamp,
                                    'description': description,
                                    'worker': worker,
                                    'createdAt': createdAt,
                                  });

                                  Navigator.of(context).pop();

                                  await fetchPartData();

                                } catch (error) {
                                  print('Chyba pri vytváraní záznamu: $error');
                                }
                              }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: customYellow,
                              minimumSize: Size(100, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: Colors.black),
                              ),
                            ),
                            child: Text(
                              'Uložiť',
                              style: TextStyle(
                                fontSize: 18,
                                color: customDarkGrey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  );
                },
              );
            },
            child: Text(
              'Vykonať údržbu',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: customDarkGrey,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: customYellow,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.black),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Future<void> fetchPartData() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('devices')
          .doc(widget.device.id)
          .collection('parts')
          .doc(widget.partId)
          .get();

      if (documentSnapshot.exists) {
        Part fetchedPart = Part(
          id: documentSnapshot.id,
          name: documentSnapshot['name'],
          maintDescription: documentSnapshot['maintenance_description'],
          maintDays: documentSnapshot['maintenance_period_days'],
          maintHours: documentSnapshot['maintenance_period_hours'],
        );

        setState(() {
          part = fetchedPart;
        });
      } else {
        throw Exception('Document does not exist');
      }
    } catch (error) {
      throw Exception('Error fetching part data: $error');
    }
  }
}

