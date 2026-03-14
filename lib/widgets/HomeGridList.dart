import 'package:flutter/material.dart';

import '../components/AppColors.dart';
import 'Text.dart';

class GridItem extends StatelessWidget {
  final String icon;
  final String text;
  final String subtitle;

  const GridItem({
    super.key,
    required this.icon,
    required this.text,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(icon, style: const TextStyle(fontSize: 40)),
          SimpleText(text: text, color: AppColors.black),
          SubtitleText(text: subtitle, color: AppColors.black),
        ],
      ),
    );
  }
}
