import 'package:flutter/material.dart';

import '../components/AppColors.dart';
import 'ProgressBar.dart';
import 'Text.dart';

class HomeProgressBar extends StatelessWidget {
  final String text;
  final int count;
  final int goal;
  const HomeProgressBar({super.key, required this.text, required this.count, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding:
        const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SimpleText(
                  text: '$count/$goal',
                  color: AppColors.blackLight,
                ),
                SubtitleText(
                  text: text,
                  color: AppColors.black,
                ),
              ],
            ),
            const SizedBox(height: 10),
            ProgressBar(
              count: count,
              goal: goal,),
          ],
        ),
      ),
    );
  }
}
