import 'package:flutter/material.dart';
import '../../app-bar/customAppBar.dart';
import '../device.dart';

class DeviceMalfunctions extends StatefulWidget {
  final Device device;

  const DeviceMalfunctions({
    super.key,
    required this.device
  });

  @override
  State<DeviceMalfunctions> createState() => _DeviceMalfunctionsState();
}

class _DeviceMalfunctionsState extends State<DeviceMalfunctions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: Column(
          children: [
            Text("PORUCHY"),
            SizedBox(height: 20),
            Text(widget.device.name),
          ],
        ),
      ),
    );
  }
}