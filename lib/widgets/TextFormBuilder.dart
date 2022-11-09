import 'package:flutter/material.dart';

class TextFormBuilder extends StatelessWidget {
  TextFormBuilder({
    Key? key,
    required this.flexPad,
    required this.controller,
    required this.inputPad,
    required this.labelText,
    this.inputType = TextInputType.text,
    this.maxLines = 1,
    this.expands = false,
    this.onEditingComplete,
    this.readOnly = false,
    this.onTap,
  }) : super(key: key);

  EdgeInsets flexPad;
  TextEditingController controller;
  EdgeInsets inputPad;
  String labelText;
  TextInputType inputType;
  bool expands;
  var maxLines = 1;
  var onEditingComplete;
  bool readOnly;
  var onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: flexPad,
      child: TextFormField(
        onEditingComplete: onEditingComplete,
        maxLines: maxLines,
        expands: expands,
        keyboardType: inputType,
        controller: controller,
        decoration: InputDecoration(
          contentPadding: inputPad,
          border: UnderlineInputBorder(),
          labelText: labelText,
        ),
        readOnly: readOnly,
        onTap: onTap,
      ),
    );
  }
}
