
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/AppColors.dart';
import '../../controller/main/FavouriteHadithVerseController.dart';
import '../../widgets/Text.dart';

class FavouriteHadithVerse extends StatelessWidget {
  final String favouriteType;
  FavouriteHadithVerse({super.key, required this.favouriteType});

  final FavouriteHadithVerseController controller =
  Get.put(FavouriteHadithVerseController());

  @override
  Widget build(BuildContext context) {
    controller.loadFavourites(favouriteType);

    return Scaffold(
      backgroundColor: AppColors.greenForeground,
      appBar: AppBar(
        title: Text(
          favouriteType == 'hadith' ? 'پسندیدہ حدیث' : 'پسندیدہ آیت',
        ),
        backgroundColor: AppColors.green,
      ),
      body: Obx(() {
        if (controller.favouriteItems.isEmpty) {
          return const Center(child: Text('کوئی پسندیدہ نہیں ملا۔'));
        }
        print(favouriteType);
        return ListView.builder(

          itemCount: controller.favouriteItems.length,
          itemBuilder: (context, index) {
            final item = controller.favouriteItems[index];

            final content = favouriteType == 'verse'
                ? item['verse'] ?? ''
                : item['hadith'] ?? '';
            final translation = item['urduTranslation'] ?? '';
            final reference = item['reference'] ?? '';
            final docId = item['id'];

            return Card(
              color: AppColors.white,
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.unsaveItem(docId);
                              },
                              child: _buildIconButton(Icons.bookmark_remove),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                controller.shareItem(content);
                              },
                              child: _buildIconButton(Icons.share),
                            ),
                          ],
                        ),
                        TitleText(
                          text: favouriteType == 'verse'
                              ? 'Ayat'
                              : 'Hadith',
                          color: AppColors.green,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TitleText(text: content, color: AppColors.black),
                    const SizedBox(height: 6),
                    SubtitleText(text: translation, color: AppColors.black),
                    const SizedBox(height: 4),
                    SimpleText(text: reference, color: AppColors.black),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.greenLight.withOpacity(0.2),
      ),
      child: Icon(icon, color: AppColors.green),
    );
  }
}