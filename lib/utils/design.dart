import 'package:flutter/material.dart';

InputDecoration getTextFieldDeco(String hint, Icon icon) {
  return InputDecoration(
    hintText: hint,
    prefixIcon: icon,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[300], width: 1),
      borderRadius: BorderRadius.circular(12),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[300], width: 1),
      borderRadius: BorderRadius.circular(12),
    ),
    fillColor: Colors.grey[100],
    filled: true,
  );
}