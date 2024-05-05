import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../app-bar/customAppBar.dart';
import '../../utilities/globalVar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';


class DeviceFaults extends StatefulWidget {
  final device;

  const DeviceFaults({
    super.key,
    this.device,
  });

  @override
  State<DeviceFaults> createState() => _DeviceFaultsState();
}

class _DeviceFaultsState extends State<DeviceFaults> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _repairDateController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _workerController = TextEditingController();

  String? category;
  String? code;

  File? pickedImage;

  bool isRepaired = false;
  bool _isDateErrorVisible = false;

  Map<String, List<String>> codeCategories = {
    'Pohon, transporty': ['101 porucha mototra', '102 porucha brzdy', '103 porucha čerpadla', '103 porucha dopravníka', '103 porucha držiaku'],
    'Hydraulika': ['201 porucha čerpadla', '202 porucha držiaku', '203 porucha elektroventilu', '204 porucha filtra', '205 porucha hadice'],
    'Pneumatika': ['302 porucha elektroventilu', '303 porucha hadice', '305 porucha chladenia', '306 porucha klapky', '307 porucha prívodu vzduchu'],
    'Nosič náradia': ['401 porucha diarole', '402 porucha držiaku', '405 porucha nakladača', '407 porucha nosiča', '408 porucha obmedzovača'],
    'Riadiace jednotky-elektronika': ['501 porucha elektromagnetu', '502 porucha elektroniky', '503 porucha elektroventilu', '504 porucha hlukomera', '505 porucha chladenia'],
  };

  String? _selectedDate;
  String _description = '';
  String _worker = '';
  String? _selectedRepairDate;
  bool? _selectedState;


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
                  'Poruchy',
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
                    .collection('faults')
                //.orderBy('date', descending: true)
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
                        final date = fault['date'].toDate();
                        final formattedDate = DateFormat('dd. MM. yyyy (HH:mm)').format(date);

                        final repairDate = fault['repairDate'].toDate();
                        final formattedRepairDate = DateFormat('dd. MM. yyyy (HH:mm)').format(repairDate);

                        Widget decodedWidget = Container();

                        if (fault['image'] != null){
                          List<int> decodedImage = base64Decode(fault['image']);
                          Uint8List uint8list = Uint8List.fromList(decodedImage);

                          decodedWidget = Image.memory(
                            uint8list,
                            width: 200,
                            height: 200,
                          );
                        }

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
                                              TextSpan(text: 'Dátum poruchy: ', style: TextStyle(fontWeight: FontWeight.bold,)),
                                              TextSpan(text: '$formattedDate\n'),
                                              TextSpan(text: 'Popis: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                              TextSpan(text: '${fault['description']}\n'),
                                              TextSpan(text: 'Pracovník: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                              TextSpan(text: '${fault['worker']}\n'),
                                              TextSpan(text: 'Kód poruchy: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                              TextSpan(text: '${fault['category']} - ${fault['code']}\n'),
                                              TextSpan(text: 'Stav: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                              TextSpan(
                                                text: fault['isRepaired'] ? 'Opravená' : 'Neopravená',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: fault['isRepaired'] ? Colors.green : Colors.red,
                                                ),
                                              ),
                                              if(fault['isRepaired'])
                                                TextSpan(text: '\nDátum opravy: ', style: TextStyle(fontWeight: FontWeight.bold,)),
                                              if(fault['isRepaired'])
                                                TextSpan(text: '$formattedRepairDate'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      //---------------------------- EDIT
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          category = fault['category'];
                                          code = fault['code'];
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return StatefulBuilder(
                                                builder: (BuildContext context, StateSetter setState) {
                                                  DateTime existingDate = fault['date'].toDate();
                                                  String formattedDate = DateFormat('dd. MM. yyyy (HH:mm)').format(existingDate);
                                                  String existingDescription = fault['description'];
                                                  String existingWorker = fault['worker'];

                                                  isRepaired = fault['isRepaired'];

                                                  DateTime existingRepairDate = fault['repairDate'].toDate();
                                                  String formattedRepairDate = DateFormat('dd. MM. yyyy (HH:mm)').format(existingRepairDate);
                                                  _repairDateController.text = formattedRepairDate;

                                                  _dateController.text = formattedDate;
                                                  _descriptionController.text = existingDescription;
                                                  _workerController.text = existingWorker;

                                                  return WillPopScope(
                                                    onWillPop: () async {
                                                      setState(() {
                                                        category = null;
                                                        code = null;
                                                        pickedImage = null;
                                                      });
                                                      return true;
                                                    },
                                                    child: AlertDialog(
                                                      title: Text('Upraviť záznam'),
                                                      content: SingleChildScrollView(
                                                        child: Container(
                                                          width: 300,
                                                          height: 350,
                                                          child: ListView(
                                                            shrinkWrap: true,
                                                            children: <Widget>[
                                                              TextFormField(
                                                                controller: _dateController,
                                                                decoration: InputDecoration(
                                                                  labelText: 'Dátum',
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

                                                              DropdownButtonFormField<String>(
                                                                decoration: InputDecoration(
                                                                  labelText: 'Kategória',
                                                                  labelStyle: TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 18,
                                                                  ),
                                                                ),
                                                                value: category,
                                                                onChanged: (newValue) {
                                                                  setState(() {
                                                                    category = newValue!;
                                                                    code = null;
                                                                  });
                                                                },
                                                                items: codeCategories.keys.map<DropdownMenuItem<String>>((String value) {
                                                                  return DropdownMenuItem<String>(
                                                                    value: value,
                                                                    child: Text(value),
                                                                  );
                                                                }).toList(),
                                                              ),
                                                              DropdownButtonFormField<String>(
                                                                decoration: InputDecoration(
                                                                  labelText: 'Kód',
                                                                  labelStyle: TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 18,
                                                                  ),
                                                                ),
                                                                value: code,
                                                                onChanged: (newValue) {
                                                                  setState(() {
                                                                    code = newValue!;
                                                                  });
                                                                },
                                                                items: codeCategories[category]?.map<DropdownMenuItem<String>>((String value) {
                                                                  return DropdownMenuItem<String>(
                                                                    value: value,
                                                                    child: Text(value),
                                                                  );
                                                                }).toList(),
                                                              ),

                                                              DropdownButtonFormField<bool>(
                                                                decoration: InputDecoration(
                                                                  labelText: 'Stav',
                                                                  labelStyle: TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 18,
                                                                  ),
                                                                ),
                                                                value: isRepaired,
                                                                onChanged: (newValue) {
                                                                  isRepaired = newValue!;
                                                                  updateIsRepaired(newValue);
                                                                },
                                                                items: [
                                                                  DropdownMenuItem(
                                                                    value: true,
                                                                    child: Text('Opravená'),
                                                                  ),
                                                                  DropdownMenuItem(
                                                                    value: false,
                                                                    child: Text('Neopravená'),
                                                                  ),
                                                                ],
                                                              ),

                                                              TextFormField(
                                                                controller: _repairDateController,
                                                                decoration: InputDecoration(
                                                                  labelText: 'Dátum opravy',
                                                                  labelStyle: TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 18,
                                                                  ),
                                                                ),
                                                                readOnly: true,
                                                                onTap: () async {
                                                                  DateTime? pickedDate = await showDatePicker(
                                                                    context: context,
                                                                    initialDate: existingRepairDate,
                                                                    firstDate: DateTime(2000),
                                                                    lastDate: DateTime(2025),
                                                                  );

                                                                  if (pickedDate != null) {
                                                                    String formattedDate = DateFormat('dd. MM. yyyy').format(pickedDate);
                                                                    setState(() {
                                                                      _repairDateController.text = formattedDate;
                                                                    });

                                                                    TimeOfDay? pickedTime = await showTimePicker(
                                                                      context: context,
                                                                      initialTime: TimeOfDay.fromDateTime(existingRepairDate),
                                                                    );

                                                                    if (pickedTime != null) {
                                                                      final now = DateTime.now();
                                                                      final dt = DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
                                                                      String formattedTime = DateFormat('HH:mm').format(dt);
                                                                      _repairDateController.text = '$formattedDate ($formattedTime)';
                                                                    }
                                                                  }
                                                                },
                                                              ),

                                                              SizedBox(height: 20,),

                                                              TextButton(
                                                                onPressed: () async {
                                                                  final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
                                                                  if (pickedFile != null) {
                                                                    setState(() {
                                                                      pickedImage = File(pickedFile.path);
                                                                    });
                                                                  }
                                                                },
                                                                child: Text(
                                                                  'Pridať fotku',
                                                                  style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: customDarkGrey,
                                                                    decoration: TextDecoration.underline,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () async {
                                                            try {
                                                              await FirebaseFirestore.instance
                                                                  .collection('devices')
                                                                  .doc(widget.device.id)
                                                                  .collection('faults')
                                                                  .doc(fault.id)
                                                                  .delete();

                                                              await refreshData();

                                                              Navigator.of(context).pop();

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
                                                            String repairDate = _repairDateController.text;

                                                            try {
                                                              DateTime parsedDate = DateFormat('dd. MM. yyyy (HH:mm)').parse(date);
                                                              Timestamp timestamp = Timestamp.fromDate(parsedDate);
                                                              DateTime parsedDate2 = DateFormat('dd. MM. yyyy (HH:mm)').parse(repairDate);
                                                              Timestamp timestamp2 = Timestamp.fromDate(parsedDate2);

                                                              String base64Image = "";
                                                              if (pickedImage != null) {
                                                                print('Názov obrázka:');
                                                                List<int> imageBytes = pickedImage!.readAsBytesSync();
                                                                base64Image = base64Encode(imageBytes);
                                                              }

                                                              await FirebaseFirestore.instance
                                                                  .collection('devices')
                                                                  .doc(widget.device.id)
                                                                  .collection('faults')
                                                                  .doc(fault.id)
                                                                  .update({
                                                                'date': timestamp,
                                                                'description': description,
                                                                'worker': worker,
                                                                'category': category,
                                                                'code': code,
                                                                'isRepaired': isRepaired,
                                                                'repairDate': timestamp2,
                                                                if(pickedImage != null)
                                                                  'image': base64Image,
                                                              });
                                                              Navigator.of(context).pop();

                                                              await refreshData();

                                                            } catch (error) {
                                                              print('Chyba pri aktualizácií záznamu: $error');
                                                            }
                                                            category = null;
                                                            code = null;
                                                            pickedImage = null;
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
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      //---------------------------- PICTURE
                                      if (fault['image'] != null)
                                        IconButton(
                                          icon: Icon(Icons.image),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: SizedBox(
                                                    width: 300,
                                                    height: 300,
                                                    child: decodedWidget,
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                    ],
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

          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        _dateController.text = _selectedDate ?? '';
                        _descriptionController.text = _description;
                        _workerController.text = _worker;

                        return WillPopScope(
                          onWillPop: () async {
                            setState(() {
                              category = null;
                              code = null;
                              _selectedDate = null;
                              _description = '';
                              _worker = '';
                              pickedImage = null;
                            });
                            return true;
                          },
                          child: AlertDialog(
                            title: Text(
                              'Nová porucha',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                          
                            ),
                            content: SingleChildScrollView(
                              child: Container(
                                width: 300,
                                height: 400,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    TextFormField(
                                      controller: _dateController,
                                      decoration: InputDecoration(
                                        labelText: 'Dátum',
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
                                          initialDate: _selectedDate != null ? DateFormat('dd. MM. yyyy').parse(_selectedDate!) : DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2025),
                                        );
                                                        
                                        if (pickedDate != null) {
                                          String formattedDate = DateFormat('dd. MM. yyyy').format(pickedDate);
                                          setState(() {
                                            _dateController.text = formattedDate;
                                            _selectedDate = formattedDate;
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
                                            _selectedDate  = '$formattedDate ($formattedTime)';
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
                                      onChanged: (value) {
                                        _description = value;
                                      },
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
                                      onChanged: (value) {
                                        _worker = value;
                                      },
                                    ),

                                    DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        labelText: 'Kategória',
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      value: category,
                                      onChanged: (newValue) {
                                        setState(() {
                                          category = newValue!;
                                        });
                                      },
                                      items: codeCategories.keys.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                    DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        labelText: 'Kód',
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      value: code,
                                      onChanged: (newValue) {
                                        setState(() {
                                          code = newValue!;
                                        });
                                      },
                                      items: codeCategories[category]?.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),

                                    SizedBox(height: 20,),

                                    TextButton(
                                      onPressed: () async {
                                        final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
                                        if (pickedFile != null) {
                                          setState(() {
                                            pickedImage = File(pickedFile.path);
                                          });
                                        }
                                      },
                                      child: Text(
                                        'Pridať fotku',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: customDarkGrey,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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

                                      // Pripravíme dáta pre uloženie do databázy
                                      Map<String, dynamic> data = {
                                        'date': timestamp,
                                        'description': description,
                                        'worker': worker,
                                        'category': category,
                                        'code': code,
                                        'isRepaired': false,
                                        'repairDate': timestamp,
                                      };

                                      // Ak sme vybrali obrázok, pridáme ho k dátam
                                      if (pickedImage != null) {
                                        // Konvertujeme obrázok na base64 reťazec
                                        List<int> imageBytes = pickedImage!.readAsBytesSync();
                                        String base64Image = base64Encode(imageBytes);
                                        data['image'] = base64Image;
                                      }
                                      else{
                                        data['image'] = null;
                                      }

                                      // Uložíme dáta do databázy
                                      await FirebaseFirestore.instance
                                          .collection('devices')
                                          .doc(widget.device.id)
                                          .collection('faults')
                                          .add(data);

                                      Navigator.of(context).pop();
                                      await refreshData();
                                    } catch (error) {
                                      print('Chyba pri vytváraní záznamu: $error');
                                    }

                                    // Vynulujeme hodnoty po uložení
                                    category = null;
                                    code = null;
                                    _selectedDate = null;
                                    _description = '';
                                    _worker = '';
                                    pickedImage = null;
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
                          ),
                        );
                      }
                  );
                },
              );
            },
            child: Text(
              'Nová porucha',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: customDarkGrey,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: customYellow,
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

  Future<void> refreshData() async {
    try {
      await FirebaseFirestore.instance
          .collection('devices')
          .doc(widget.device.id)
          .collection('faults')
          .get();

      setState(() {
      });
    } catch (error) {
      throw Exception('Error refreshing data: $error');
    }
  }

  void updateIsRepaired(bool newValue) {
    setState(() {
      isRepaired = newValue;
    });
  }
}

