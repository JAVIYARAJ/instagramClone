import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPassword;
  final String hintText;
  final TextInputType inputType;


  const TextFieldInput(
      {Key? key, required this.textEditingController, required this.hintText, required this.inputType, this.isPassword = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder=OutlineInputBorder(
      borderSide: Divider.createBorderSide(context)
    );
    return TextField(
      controller:textEditingController,
      decoration: InputDecoration(
          hintText:hintText,
          border:inputBorder,
          focusedBorder:inputBorder,
          enabledBorder:inputBorder,
          filled: true,
          contentPadding: const EdgeInsets.all(8)
      ),
      obscureText:isPassword,
      keyboardType:inputType,

    );
  }
}
