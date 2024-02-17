import 'package:flutter/material.dart';
import 'package:maintenace/utilities/globalVar.dart';

class CustomInputField extends StatefulWidget {

  final TextEditingController controller;
  final String labelText;
  final bool isPasswordField;

  const CustomInputField({
    required this.controller,
    required this.labelText,
    this.isPasswordField = false,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();

}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: widget.controller,
        style: TextStyle(color: Colors.black),
        obscureText: widget.isPasswordField == true? _obscureText : false,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(
            fontFamily: 'Roboto',
            color: Colors.black,
            fontSize: 19,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: customLightGrey,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(13),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(13),
          ),
          suffixIcon: widget.isPasswordField
              ? GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: _obscureText ? Colors.grey : Colors.blue,
            ),
          )
              : null,
        ),
      ),
    );
  }
}
