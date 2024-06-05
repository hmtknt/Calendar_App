import 'package:flutter/material.dart';
import 'package:flutter_events_2023/View/theme/light_color.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundedTextField extends StatelessWidget {
  final String hint;
  final bool? obscureText;
  final Color color;
  final FocusNode? focusNode;
  final Color? cursorColor;
  final TextEditingController? controller;
  final Color borderColor;
  final Decoration? decoration;
  final InputDecoration? inputDecoration;
  final Widget? sIcon;
  final Widget? pIcon;
  final bool? onlyRead;
  final int? maxLine;
  final TextInputType? keyBoardType;

  const RoundedTextField({
    super.key,
    required this.hint,
    this.controller,
    required this.color,
    this.focusNode,
    this.cursorColor,
    required this.borderColor,
    this.decoration,
    this.inputDecoration,
    this.pIcon,
    this.sIcon,
    this.onlyRead,
    this.obscureText,
    this.maxLine,
    this.keyBoardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: onlyRead ?? false,
      obscureText: obscureText ?? false,
      focusNode: focusNode,
      controller: controller,
      cursorColor: cursorColor ?? LightColor.primary,
      maxLines: maxLine ?? 1,
      keyboardType: keyBoardType,
      decoration: inputDecoration ??
          InputDecoration(
            labelText: hint,
            labelStyle: GoogleFonts.poppins(
              color: LightColor.primary,
            ),
            prefixIcon: pIcon,
            suffixIcon: sIcon,
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: LightColor.primary, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: LightColor.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Color(0xffE64646)),
            ),
            disabledBorder: InputBorder.none,
          ),
    );
  }
}
