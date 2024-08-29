import 'package:flutter/material.dart';

class CustomFiled extends StatelessWidget {
  final String hinttext;
  final TextEditingController? controller;
  final bool isObsecure;
  final bool readonly;
  final VoidCallback? onTap;
  const CustomFiled({
    super.key,
    required this.hinttext,
    required this.controller,
    this.isObsecure = false,
    this.readonly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readonly,
      controller: controller,
      decoration: InputDecoration(
        hintText: hinttext,
      ),
      obscureText: isObsecure,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return "$hinttext is missing !";
        }
        return null;
      },
    );
  }
}
