import 'package:flutter/material.dart';

class ReusableButton extends StatelessWidget {
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final String text;
  final VoidCallback onClick;

  const ReusableButton(
      {Key? key,
      required this.backgroundColor,
      required this.text,
      required this.borderColor,
      required this.textColor,required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        margin: const EdgeInsets.all(10),
        height: 35,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 20, color: textColor, fontWeight: FontWeight.normal),
          ),
        ),
      ),
    );
  }
}
