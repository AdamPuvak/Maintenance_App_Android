import 'package:flutter/material.dart';

class Device{
  final String name;
  final String imageUrl;
  final String info1;
  final String info2;
  final String info3;
  late String maintenance;
  late String malfunctions;

  Device({
    required this.name,
    required this.imageUrl,
    required this.info1,
    required this.info2,
    required this.info3,
  });
}

