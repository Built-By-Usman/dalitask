import 'package:flutter/material.dart';
import '../components/AppColors.dart';
import 'Text.dart';

class SettingProfileContainer extends StatefulWidget {
  final String text;
  final IconData icon;
  final Widget? dropDownContent; // 👈 pass custom widget here

  const SettingProfileContainer({
    super.key,
    required this.text,
    required this.icon,
    this.dropDownContent,
  });

  @override
  State<SettingProfileContainer> createState() => _SettingProfileContainerState();
}

class _SettingProfileContainerState extends State<SettingProfileContainer> {
  bool _isExpanded = false; // 👈 track dropdown state

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded; // toggle dropdown
            });
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.grey.shade400),
              color: AppColors.greyLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.arrow_forward_ios_rounded,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SubtitleText(text: widget.text, color: AppColors.black),
                      const SizedBox(width: 10),
                      Icon(widget.icon),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // 👇 Dropdown content appears here
        if (_isExpanded && widget.dropDownContent != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
            child: widget.dropDownContent!,
          ),
      ],
    );
  }
}