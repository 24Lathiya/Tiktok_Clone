import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController textEditingController;
  final IconData icon;
  final String hintText;
  final String labelText;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final bool isObscure;
  const TextInputField(
      {Key? key,
      required this.textEditingController,
      required this.icon,
      required this.hintText,
      required this.labelText,
      required this.textInputType,
      this.textInputAction = TextInputAction.next,
      this.isObscure = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        TextField(
          controller: textEditingController,
          decoration: InputDecoration(
              prefixIcon: Icon(icon), hintText: hintText, labelText: labelText, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
          keyboardType: textInputType,
          textInputAction: textInputAction,
          obscureText: isObscure,
        ),
      ],
    );
  }
}
