import 'package:flutter/material.dart';
import '../components/AppColors.dart';

// For title text
class TitleText extends StatelessWidget {
  final String text;
  final Color color;
  final TextAlign? align;

  TitleText({super.key, required this.text, required this.color, this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align ?? TextAlign.right, // default to right
      textDirection: TextDirection.rtl,    // right-to-left support
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}

// For subtitle text
class SubtitleText extends StatelessWidget {
  final String text;
  final Color color;
  final TextAlign? align;
  final double? size;

  SubtitleText({super.key, required this.text, required this.color, this.align, this.size});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align ?? TextAlign.right, // default to right
      textDirection: TextDirection.rtl,    // right-to-left support
      style: TextStyle(
        fontSize: size??11,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    );
  }
}

// For simple text
class SimpleText extends StatelessWidget {
  final String text;
  final Color color;
  final TextAlign? align;
  final double? size;

  SimpleText({super.key, required this.text, required this.color, this.align, this.size});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align ?? TextAlign.right, // default to right
      textDirection: TextDirection.rtl,    // right-to-left support
      style: TextStyle(
        fontSize: size??10,
        fontWeight: FontWeight.w500,
        color: color,
      ),
    );
  }
}