import 'package:flutter/material.dart';

enum InputType { text, email, password }

class TextFieldCustom extends StatelessWidget {
  final String title;
  final String hintText;
  final bool secureText;
  final InputType type;
  final TextEditingController controller;
  void Function(String value)? onChanged;

  Map<InputType, TextInputType> selectedType = {
    InputType.text: TextInputType.text,
    InputType.email: TextInputType.emailAddress,
    InputType.password: TextInputType.visiblePassword,
  };

  TextFieldCustom({
    super.key,
    this.title = '',
    required this.hintText,
    required this.onChanged,
    required this.controller,
    this.type = InputType.text,
    this.secureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title != ''
              ? Column(children: [Text(title), const SizedBox(height: 6)])
              : const SizedBox(),
          TextField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: selectedType[type],
            obscureText: secureText,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Colors.black),
              ),
              contentPadding:
                  const EdgeInsets.only(top: 13, bottom: 13, left: 10),
            ),
          ),
        ],
      ),
    );
  }
}
