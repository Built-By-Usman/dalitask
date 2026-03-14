import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../components/AllPages.dart';
import '../../components/AppColors.dart';
import '../../controller/main/FavouriteScreenController.dart';
import '../../widgets/Text.dart';

class FavouriteScreen extends StatelessWidget {
  FavouriteScreen({super.key});

  final FavouriteScreenController controller =
  Get.put(FavouriteScreenController());

  final List<Map<String, String>> top = [
    {"image": "assets/images/muhammad.png", "title": "اسماء النبی ﷺ"},
    {"image": "assets/images/allah.png", "title": "اسماء الحسنی"},
  ];

  final List<Map<String, String>> favourite = [
    {"title": "پسندیدہ آیات", "type": "verse"},
    {"title": "پسندیدہ احادیث", "type": "hadith"},
  ];

  final List<Map<String, String>> dailyHadithVerse = [
    {"id": "ayat", "title": "آج کی آیت"},
    {"id": "hadith", "title": "آج کی حدیث"},
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.greenForeground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              _buildTopGrid(screenWidth),
              const SizedBox(height: 10),
              _buildFavouriteGrid(screenWidth),
              const SizedBox(height: 15),
              _buildDailyUpdatesList(),
            ],
          ),
        ),
      ),
    );
  }

  /// Top Grid
  Widget _buildTopGrid(double screenWidth) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: top.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        childAspectRatio: 1.3,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            final type = index == 0 ? 'muhammad' : 'allah';
            Get.toNamed(AppRoutes.names, arguments: {'type': type});
          },
          child: Card(
            color: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  top[index]["image"]!,
                  width: screenWidth * 0.18,
                  height: screenWidth * 0.18,
                ),
                const SizedBox(height: 10),
                TitleText(text: top[index]["title"]!, color: AppColors.black),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Favourite Grid
  Widget _buildFavouriteGrid(double screenWidth) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: favourite.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        childAspectRatio: 1.8,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            final type = favourite[index]['type']!;
            Get.toNamed(AppRoutes.favouriteHadithVerse,
                arguments: {'favouriteType': type});
          },
          child: Card(
            color: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.menu,
                  size: screenWidth * 0.1,
                  color: AppColors.green,
                ),
                const SizedBox(height: 10),
                SubtitleText(
                  text: favourite[index]["title"]!,
                  color: AppColors.black,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Daily Updates List
  Widget _buildDailyUpdatesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: dailyHadithVerse.map((item) {
        final isAyat = item["id"] == "ayat";

        return Card(
          color: AppColors.white,
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Obx(() {
              // define content, translation, reference inside Obx
              final content = isAyat
                  ? controller.dailyAyat.value
                  : controller.dailyHadees.value;
              final translation = isAyat
                  ? controller.ayatTranslation.value
                  : controller.hadeesTranslation.value;
              final reference = isAyat
                  ? controller.ayatReference.value
                  : controller.hadeesReference.value;

              final id = item['id']!;
              final isSaved = isAyat
                  ? controller.savedVerseIds.contains(id)
                  : controller.savedHadithIds.contains(id);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.toggleFavorite(
                                type: isAyat ? 'verse' : 'hadith',
                                content: content,
                                translation: translation,
                                reference: reference,
                                id: id,
                              );
                            },
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.greenForeground,
                              child: Icon(
                                isSaved ? Icons.bookmark : Icons.bookmark_border,
                                color: AppColors.black,
                                size: 23,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              final fullText = '''
${isAyat ? "آیت" : "حدیث"}:
$content

ترجمہ:
$translation

حوالہ:
$reference
''';
                              Share.share(fullText);
                            },
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.greenForeground,
                              child: const Icon(
                                Icons.share,
                                color: Colors.black,
                                size: 23,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TitleText(text: item["title"]!, color: AppColors.green),
                    ],
                  ),
                  const SizedBox(height: 13),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end, // Right-align content & translation
                    children: [
                      TitleText(text: content, color: AppColors.black),
                      const SizedBox(height: 6),
                      SubtitleText(text: translation, color: AppColors.blackLight),
                      const SizedBox(height: 5),
                      Align(
                        alignment: Alignment.centerLeft, // Left-align reference
                        child: SubtitleText(text: reference, color: AppColors.black),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
        );
      }).toList(),
    );
  }
}