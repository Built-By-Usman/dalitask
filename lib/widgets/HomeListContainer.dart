import 'package:flutter/material.dart';

import '../components/AppColors.dart';
import 'Text.dart';

class HomeListContainer extends StatelessWidget {
  final Color gradientColor1;
  final Color gradientColor2;
  final String title;
  final String subtitle;
  const HomeListContainer({super.key, required this.gradientColor1, required this.gradientColor2, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [gradientColor1, gradientColor2],
        ),
      ),

      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SubtitleText(
              text: title,
              color: AppColors.black,
            ),
            SizedBox(height: 5,),
            SimpleText(text: subtitle, color: AppColors.black)
          ],
        ),
      ),
    );
  }
}
