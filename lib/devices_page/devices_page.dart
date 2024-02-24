import 'package:flutter/material.dart';
import 'package:maintenace/custom_widgets/customAppBar.dart';
import 'package:maintenace/main_pages/home_page.dart';
import 'package:maintenace/utilities/globalVar.dart';
import 'device.dart';

class DevicesPage extends StatefulWidget {
  DevicesPage({Key? key}) : super(key: key);

  @override
  _DevicesPageState createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  final List<Device> devices = [
    Device(name: 'KR ZVAR', imageUrl: 'images/zvar.jpg', info: '- info o zariadení'),
    Device(name: 'KR MAN 1', imageUrl: 'images/MAN_1.jpg', info: '- info o zariadení'),
    Device(name: 'KR MAN 2', imageUrl: 'images/MAN_2.jpg', info: '- info o zariadení'),
    Device(name: 'Magicwave', imageUrl: 'images/question.png', info: '- info o zariadení'),
    Device(name: 'Nástrojový stojan', imageUrl: 'images/drziak.jpg', info: '- info o zariadení'),
    Device(name: 'Fotoneo snímače', imageUrl: 'images/senzor.jpg', info: '- info o zariadení'),
  ];

  late List<bool> showDetails;

  @override
  void initState() {
    super.initState();
    showDetails = List<bool>.generate(devices.length, (index) => false);
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
                                SizedBox(height: 15,),
                                Text(
                                  devices[index].info,
                                  style: TextStyle(
                                    fontSize: 22,
                                  ),
                                ),

                                SizedBox(height: 15,),

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



                                SizedBox(height: 15,),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => HomePage()),
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
