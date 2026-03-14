
import 'package:flutter/material.dart';

import 'Text.dart';

class MyElevatedButton extends StatelessWidget {
  final VoidCallback? method;
  final String text;
  final Color gradient1;
  final Color gradient2;
  final Color textColor;

  const MyElevatedButton({
    super.key,
    this.method,
    required this.text,
    required this.textColor, required this.gradient1, required this.gradient2,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: method,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [gradient1, gradient2],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: SubtitleText(text: text, color: textColor),
        ),
      ),
    );
  }
}
