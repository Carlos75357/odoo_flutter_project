import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Container textFields(TextEditingController controller, String hintText, Widget icon) {
  return Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Colors.grey.shade200,
        ),
      ),
    ),
    child: TextField(
      controller: controller,
      obscureText: hintText.toLowerCase().contains('contaseña'),
      decoration: InputDecoration(
        icon: icon,
        labelText: hintText,
        border: InputBorder.none,
      ),
    ),
  );
}
