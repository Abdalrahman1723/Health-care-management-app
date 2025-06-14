import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;
  final Widget? suffixIcon;
  final String label;
  final bool isEmail;
  final bool isPassword;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final bool readOnly; // تم إضافة هذا الباراميتر

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.formKey,
    required this.label,
    this.suffixIcon,
    this.isEmail = false,
    this.isPassword = false,
    this.keyboardType,
    this.onTap,
    this.readOnly = false, // افتراضي false
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      keyboardType: widget.keyboardType,
      readOnly: widget.readOnly, // تم تمرير الخاصية هنا
      onTap: widget.onTap,
      decoration: InputDecoration(
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscureText ? Icons.remove_red_eye_outlined : Icons.visibility_off,
            color: const Color(0xFF0BDCDC),
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        )
            : widget.suffixIcon,
        fillColor: Colors.white,
        filled: true,
        hintText: widget.label,
        hintStyle: const TextStyle(color: Color(0xFF0BDCDC)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your ${widget.isEmail ? "email" : "password"}';
        }
        if (widget.isEmail) {
          String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
          RegExp regExp = RegExp(pattern);
          if (!regExp.hasMatch(value)) {
            return 'Please enter a valid email';
          }
        }
        if (widget.isPassword && value.length < 6) {
          return 'Password must be at least 6 characters long';
        }
        return null;
      },
    );
  }
}