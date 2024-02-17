import 'package:flutter/material.dart';
import '/utilities/globalVar.dart';

class CustomIconButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Widget Function() locationPage;

  CustomIconButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.locationPage,
  }) : super(key: key);

  @override
  State<CustomIconButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {

  Color buttonColor = customLightGrey;
  Color iconColor = customGrey;

  void _navigate() {
    setState(() {
      buttonColor = customYellow;
      iconColor = customDarkGrey;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget.locationPage()),
    ).then((_) {
      setState(() {
        buttonColor = customLightGrey;
        iconColor = customGrey;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _navigate,
      onLongPress: _navigate,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: buttonColor,
        minimumSize: Size(150, 150),
      ),
      child: Column(
        children: [
          Icon(
            widget.icon,
            color: iconColor,
            size: 80,
          ),

          SizedBox(height: 5),

          Text(
            widget.label,
            style: TextStyle(
              color: iconColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}