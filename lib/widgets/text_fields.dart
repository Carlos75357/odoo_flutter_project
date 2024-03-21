import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget icon;
  final bool isPassword;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
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
        controller: widget.controller,
        obscureText: widget.isPassword && _isHidden,
        decoration: InputDecoration(
          icon: widget.icon,
          labelText: widget.hintText,
          border: InputBorder.none,
          suffixIcon: widget.isPassword
              ? IconButton(
            icon: Icon(_isHidden ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _isHidden = !_isHidden;
              });
            },
          )
              : null,
        ),
      ),
    );
  }
}

