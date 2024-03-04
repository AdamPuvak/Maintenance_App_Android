import 'package:flutter/material.dart';
import 'package:maintenace/PAGE-(devices)/subpages/device_maintenance.dart';
import 'package:maintenace/PAGE-(devices)/subpages/device_malfunctions.dart';
import 'package:maintenace/PAGE-(devices)/subpages/device_repairs.dart';
import '../app-bar/customAppBar.dart';
import '../utilities/globalVar.dart';
import 'device.dart';

class DeviceDetail extends StatefulWidget {
  final Device device;

  const DeviceDetail({
    required this.device,
    Key? key,
  }) : super(key: key);

  @override
  State<DeviceDetail> createState() => _DeviceDetailState();
}

class _DeviceDetailState extends State<DeviceDetail> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
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
            child: Text(
              widget.device.name,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: customSuperLightGrey,
              ),
            ),
          ),

          SizedBox(height: 20,),

          Row(
            children: [
              SizedBox(width: 15,),

              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Image.asset(
                          widget.device.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 8,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    widget.device.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(width: 15,),

              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.device.info1.isNotEmpty) DeviceInfos(info: widget.device.info1),
                  if (widget.device.info2.isNotEmpty) DeviceInfos(info: widget.device.info2),
                  if (widget.device.info3.isNotEmpty) DeviceInfos(info: widget.device.info3),
                ],
              ),
            ],
          ),

          SizedBox(height: 40,),

          ActionPlate(text1: "ÚDRŽBA", text2: "Kontrola bude o toľko dní", icon: Icons.settings, color: Colors.blue, locationPage: () => DeviceMaintenance(device: this.widget.device,),),

          SizedBox(height: 15,),

          ActionPlate(text1: "PORUCHY", text2: "Žiadne aktuálne poruchy", icon: Icons.warning, color: Colors.red, locationPage: () => DeviceMalfunctions(device: this.widget.device,)),

          SizedBox(height: 15,),

          ActionPlate(text1: "OPRAVY", text2: "", icon: Icons.build, color: Colors.green, locationPage: () => DeviceRepairs(device: this.widget.device,)),
        ],
      ),
    );
  }
}


class DeviceInfos extends StatelessWidget {
  final String info;

  const DeviceInfos({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.fiber_manual_record,
          color: Colors.black,
          size: 10,
        ),
        SizedBox(width: 5),
        Text(
          '$info',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}

class ActionPlate extends StatefulWidget {
  final String text1;
  final String text2;
  final IconData icon;
  final Color color;
  final Widget Function() locationPage;

  const ActionPlate({
    Key? key,
    required this.text1,
    required this.text2,
    required this.icon,
    required this.color,
    required this.locationPage,
  }) : super(key: key);

  @override
  _ActionPlateState createState() => _ActionPlateState();
}

class _ActionPlateState extends State<ActionPlate> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widget.locationPage()),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
          border: Border(
            left: BorderSide(
              color: widget.color,
              width: 4,
            ),
          ),
        ),
        constraints: BoxConstraints(maxWidth: 400),
        child: SizedBox(
          height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  if (widget.text1.isNotEmpty)
                    Text(
                      widget.text1,
                      style: TextStyle(
                        color: widget.color,
                        fontSize: 17,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  SizedBox(height: 7,),
                  if (widget.text2.isNotEmpty)
                    Text(
                      widget.text2,
                      style: TextStyle(
                        color: widget.color,
                        fontSize: 17,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  SizedBox(height: 10,),
                ],
              ),
              Spacer(),
              Icon(
                widget.icon,
                size: 40,
                color: widget.color,
              ),
              SizedBox(width: 15),
            ],
          ),
        ),
      ),
    );
  }
}
