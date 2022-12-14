import 'package:flutter/material.dart';

class FormTextFieldWidget extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Function(String? value)? onChanged;

  const FormTextFieldWidget({
    Key? key,
    required this.hintText,
    required this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(width: 0.5, color: Color(0xffD9D9D9)),
        ),
        hintText: hintText,
      ),
      onChanged: onChanged,
    );
  }
}
