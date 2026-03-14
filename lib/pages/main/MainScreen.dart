
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:get/get.dart';

import '../../components/AppColors.dart';
import '../../controller/main/MainScreenController.dart';
import '../../widgets/Text.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainScreenController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: IconButton(
          onPressed: () {
            controller.logout();
          },
          icon: Icon(Icons.logout_outlined),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              children: [
                Obx(
                  () => SubtitleText(
                    text: controller.userName.value,
                    color: AppColors.black,
                  ),
                ),
                Obx(
                  () => SimpleText(
                    text: controller.userEmail.value,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(width: 7),
              ],
            ),
            SizedBox(width: 7),
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppColors.green, AppColors.greenLight],
                  ),
                ),
                alignment: Alignment.center,
                child: TitleText(text: 'م', color: AppColors.white),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.white,
      body: Obx(() => controller.pages[controller.index.value]),
      bottomNavigationBar: Container(
        color: AppColors.white,
        child: SafeArea(
          child: Obx(
            () => GNav(
              gap: 8,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              tabBackgroundColor: AppColors.greenLight,
              selectedIndex: controller.index.value,
              onTabChange: (index) => controller.index.value = index,
              activeColor: AppColors.white,
              tabs: const [
                GButton(icon: Icons.settings, text: 'سیٹنگز'),
                GButton(icon: Icons.favorite, text: 'پسندیدہ'),
                GButton(icon: Icons.menu_book, text: 'قرآن'),
                GButton(icon: Icons.leaderboard, text: 'لیڈر بورڈ'),
                GButton(icon: Icons.home, text: 'ہوم'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
