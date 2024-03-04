import 'package:flutter/material.dart';
import '../../app-bar/customAppBar.dart';
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
      body: Center(
        child: Column(
          children: [
            Text("ORPAVY"),
            SizedBox(height: 20),
            Text(widget.device.name),
          ],
        ),
      ),
    );
  }
}