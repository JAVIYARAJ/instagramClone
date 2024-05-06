import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/utils/colors.dart';
class TextFormWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String value)? onChanged;
  final VoidCallback? onSuffixTap;
  final bool suffixIconVisible;
  final IconData? prefixIcon;
  final String hintText;


  const TextFormWidget({super.key,required this.controller,this.onChanged,this.suffixIconVisible=false,this.onSuffixTap,this.prefixIcon,required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: primaryColor,
      style: GoogleFonts.roboto()
          .copyWith(fontSize: 18, color: primaryColor),
      onChanged: (value) {
       onChanged?.call(value);
      },
      onSubmitted: (value) {

      },
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.withOpacity(0.3),
          contentPadding: const EdgeInsets.all(5),
          hintText: hintText,
          hintStyle: GoogleFonts.roboto().copyWith(
              fontSize: 18, color: primaryColor.withOpacity(0.7)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: Colors.grey)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: Colors.grey)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: Colors.grey)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: Colors.grey)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: Colors.grey)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: Colors.grey)),
          suffixIcon:suffixIconVisible ? GestureDetector(
            onTap: () {
              onSuffixTap?.call();
            },
            child: Icon(
              Icons.close,
              color: primaryColor.withOpacity(0.7),
              size: 30,
            ),
          )
              : const SizedBox(),
          prefixIcon: Icon(
            prefixIcon,
            color: primaryColor.withOpacity(0.7),
            size: 30,
          )),
    );
  }
}
