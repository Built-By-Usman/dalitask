
import 'package:flutter/material.dart';

import '../components/AppColors.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool isPassword;
  final String? errorMessage;

  const MyTextField({super.key, required this.controller, required this.hint,required this.isPassword, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return TextField(
      textDirection: TextDirection.rtl,
      obscureText: isPassword?true:false,
      controller: controller,
      cursorColor: AppColors.black,
      decoration: InputDecoration(
        errorText: errorMessage,
        hintTextDirection: TextDirection.rtl,
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide(color: AppColors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide(color: AppColors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide(color: AppColors.grey),
        ),
      ),
    );
  }
}
