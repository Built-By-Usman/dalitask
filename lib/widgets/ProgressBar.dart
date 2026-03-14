import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final int count;
  final int goal;

  ProgressBar({required this.count, required this.goal});

  @override
  Widget build(BuildContext context) {
    double progress = goal > 0 ? count / goal : 0.0;
    if (progress > 1.0) progress = 1.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              // Filled progress right to left
              Align(
                alignment: Alignment.centerRight, // Right side سے start
                child: Container(
                  width: constraints.maxWidth * progress,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              // Percentage text
              Center(
                child: Text(
                  "${(progress * 100).toInt()}%",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}