import 'package:flutter/material.dart';

InputDecoration textFieldInputDeco(String hintText) {
  return InputDecoration(
    hintText: '$hintText',
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        gapPadding: 2,
        borderSide: BorderSide(color: Colors.grey[300], width: 2)),
    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 11),
  );
}
