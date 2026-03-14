import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';

import '../../components/AppColors.dart';
import '../../controller/main/LeaderboardScreenController.dart';
import '../../widgets/Text.dart';

class LeaderBoardScreen extends StatelessWidget {
  LeaderBoardScreen({super.key});

  var gifts = ['۵۰۰۰ روپے نقد 💰', 'قرآن پاک 📖', 'تسبیح + کاؤنٹر 📿'];

  final LeaderboardScreenController controller = Get.put(
    LeaderboardScreenController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greenForeground,
      body: SafeArea(
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Dropdown menu to select winners
              Padding(
                padding: EdgeInsets.all(12),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down, color: AppColors.black),
                      value: controller.selectedWinners.value.isEmpty
                          ? null
                          : controller.selectedWinners.value,
                      hint: Align(
                        alignment: Alignment.centerRight,
                        // hint right-aligned
                        child: SubtitleText(
                          text: 'فاتحین منتخب کریں',
                          color: AppColors.black,
                        ),
                      ),
                      items: controller.winnerOptions
                          .map(
                            (winners) => DropdownMenuItem<String>(
                              value: winners,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Align(
                                  alignment: Alignment.centerRight, // Right-align for Urdu
                                  child: Text(
                                    winners,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          controller.changeWinners(value);
                        }
                      },
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Obx(
                      () {
                    if (controller.isLoading.value) {
                      return Center(child: Lottie.asset(
                        'assets/lottie/loading.json',
                        width: 200,
                        height: 200));
                    }

                    if (controller.winners.isEmpty) {
                      return Center(
                        child: Text('اوپر سے فاتحین کا انتخاب کریں'), // No winners available
                      );
                    }

                    return ListView.builder(
                      itemCount: controller.winners.length,
                      itemBuilder: (context, index) {
                        return index < 3
                            ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: controller.selectedWinners.value == 'ماہانہ فاتحین' &&
                                    controller.winners.length > index
                                    ? TitleText(
                                  text: gifts[index],
                                  color: AppColors.black,
                                )
                                    : null,
                                title: TitleText(
                                  text: controller.winners[index].name,
                                  color: AppColors.black,
                                ),
                                subtitle: SubtitleText(
                                  text: controller.getPoints(index),
                                  color: AppColors.blackLight,
                                ),
                                trailing: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    gradient: LinearGradient(
                                      colors: [AppColors.green, AppColors.greenLight],
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 7,
                                      horizontal: 16,
                                    ),
                                    child: TitleText(text: '${index+1}', color: AppColors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                            : ListTile(
                          title: TitleText(
                            text: controller.winners[index].name,
                            color: AppColors.black,
                          ),
                          subtitle: SubtitleText(
                            text: controller.getPoints(index),
                            color: AppColors.blackLight,
                          ),
                          trailing: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(
                                colors: [AppColors.green, AppColors.greenLight],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 7,
                                horizontal: 16,
                              ),
                              child: TitleText(text: '${index+1}', color: AppColors.white),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
