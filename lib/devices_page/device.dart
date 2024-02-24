import 'package:flutter/material.dart';

class Device{
  final String name;
  final String imageUrl;
  final String info;
  late int maintenance;
  late int malfunctions;

  Device({
    required this.name,
    required this.imageUrl,
    required this.info,
  });
}

