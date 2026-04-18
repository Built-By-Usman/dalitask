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
          icon: const Icon(Icons.logout_outlined),
          onPressed: controller.logout,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
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
              ],
            ),
            const SizedBox(width: 10),
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
                child: TitleText(
                  text: 'م',
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),

      // ================= BODY =================
      body: Stack(
        children: [
          /// MAIN PAGE
          Obx(() => controller.pages[controller.index.value]),

          /// FAQ BUTTON (RIGHT SIDE)
          Positioned(
            right: 0,
            top: MediaQuery.of(context).size.height * 0.4,
            child: GestureDetector(
              onTap: () => controller.showFaq.value = true,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.green,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: const RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    "سوالات و جوابات",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),

          /// FAQ MODAL OVERLAY
          Obx(
                () => controller.showFaq.value
                ? Positioned.fill(
              child: GestureDetector(
                onTap: () => controller.showFaq.value = false,
                child: Container(
                  color: Colors.black.withOpacity(0.6),

                  child: Center(
                    child: GestureDetector(
                      onTap: () {},

                      /// MAIN MODAL CARD
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        constraints: const BoxConstraints(maxHeight: 600),

                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 25,
                              spreadRadius: 5,
                            ),
                          ],
                        ),

                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(28),

                          child: Column(
                            children: [
                              /// ================= HEADER =================
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.green,
                                      AppColors.greenLight
                                    ],
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.close,
                                          color: Colors.white),
                                      onPressed: () =>
                                      controller.showFaq.value = false,
                                    ),
                                    const Text(
                                      "سوالات و جوابات",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              /// ================= LIST =================
                              Expanded(
                                child: Obx(
                                      () => ListView.builder(
                                    padding: const EdgeInsets.all(12),
                                    itemCount: controller.faqList.length,
                                    itemBuilder: (context, index) {
                                      final faq =
                                      controller.faqList[index];

                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 6),
                                        decoration: BoxDecoration(
                                          color: AppColors.greyLight,
                                          borderRadius:
                                          BorderRadius.circular(16),
                                          border: Border.all(
                                            color: AppColors.greenLightest,
                                          ),
                                        ),

                                        child: Theme(
                                          data: Theme.of(context).copyWith(
                                            dividerColor: Colors.transparent,
                                          ),

                                          child: ExpansionTile(
                                            iconColor: AppColors.green,
                                            collapsedIconColor:
                                            AppColors.grey,
                                            tilePadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 12),

                                            title: Align(
                                              alignment:
                                              Alignment.centerRight,
                                              child: Text(
                                                faq.question,
                                                style: const TextStyle(
                                                  fontWeight:
                                                  FontWeight.w600,
                                                  fontSize: 15,
                                                  color:
                                                  AppColors.blackLight,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                            ),

                                            children: [
                                              Container(
                                                width: double.infinity,
                                                padding:
                                                const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  color: AppColors
                                                      .greenLightest
                                                      .withOpacity(0.4),
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      12),
                                                ),
                                                child: Text(
                                                  faq.answer,
                                                  textAlign:
                                                  TextAlign.right,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color:
                                                    AppColors.black,
                                                    height: 1.4,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
                : const SizedBox(),
          )
        ],
      ),

      // ================= BOTTOM NAV =================
      bottomNavigationBar: SafeArea(
        child: Obx(
              () => GNav(
            gap: 8,
            iconSize: 24,
            padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
    );
  }
}