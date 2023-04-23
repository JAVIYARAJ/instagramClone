import 'package:flutter/material.dart';

class ReusableButton extends StatelessWidget {
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final String text;

  const ReusableButton(
      {Key? key,
      required this.backgroundColor,
      required this.text,
      required this.borderColor,
      required this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 40,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              fontSize: 20, color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
