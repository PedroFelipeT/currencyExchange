// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomBottom extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color color;
  final Color colorText;
  final double sizeText;

  const CustomBottom({
    super.key,
    required this.onPressed,
    required this.text,
    required this.color,
    required this.colorText,
    required this.sizeText,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        backgroundColor: color,
        textStyle: const TextStyle(
          fontSize: 20,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40), // Define as bordas quadradas
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: sizeText,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
          color: colorText,
          overflow: TextOverflow.ellipsis,
        ),
        maxLines: 1,
      ),
    );
  }
}
