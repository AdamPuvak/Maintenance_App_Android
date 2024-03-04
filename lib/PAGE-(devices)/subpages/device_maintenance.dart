import 'package:flutter/material.dart';
import '../../app-bar/customAppBar.dart';
import '../device.dart';

class DeviceMaintenance extends StatefulWidget {
  final Device device;

  const DeviceMaintenance({
    super.key,
    required this.device
  });

  @override
  State<DeviceMaintenance> createState() => _DeviceMaintenanceState();
}

class _DeviceMaintenanceState extends State<DeviceMaintenance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: Column(
          children: [
            Text("UDRZBA"),
            SizedBox(height: 20),
            Text(widget.device.name),
          ],
        ),
      ),
    );
  }
}