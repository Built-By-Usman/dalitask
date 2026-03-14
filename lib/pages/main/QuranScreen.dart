import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../widgets/Text.dart';
import 'SurahScreen.dart';
import '../../components/AppColors.dart';

class QuranScreen extends StatelessWidget {
  final List<Map<String, dynamic>> suparaList = [
    {"number": 1, "name": "الم"},
    {"number": 2, "name": "سَيَقُولُ"},
    {"number": 3, "name": "تِلْكَ الرُّسُلُ"},
    {"number": 4, "name": "لَن تَنَالُوا۟"},
    {"number": 5, "name": "وَٱلْمُحْصَنَـٰتُ"},
    {"number": 6, "name": "لَا يُحِبُّ ٱللَّهُ"},
    {"number": 7, "name": "وَإِذَا سَمِعُوا۟"},
    {"number": 8, "name": "وَلَوْ أَنَّنَا"},
    {"number": 9, "name": "قَدْ أَفْلَحَ"},
    {"number": 10, "name": "وَٱعْلَمُوا۟"},
    {"number": 11, "name": "يَعْتَذِرُونَ"},
    {"number": 12, "name": "وَمَا مِن دَآبَّةٍ"},
    {"number": 13, "name": "وَمَا أُبَرِّئُ"},
    {"number": 14, "name": "رُبَمَا"},
    {"number": 15, "name": "سُبْحَـٰنَ ٱلَّذِى"},
    {"number": 16, "name": "قَالَ أَلَمْ"},
    {"number": 17, "name": "ٱقْتَرَبَ"},
    {"number": 18, "name": "قَدْ أَفْلَحَ ٱلْمُؤْمِنُونَ"},
    {"number": 19, "name": "وَقَالَ ٱلَّذِينَ"},
    {"number": 20, "name": "أَمَّنْ خَلَقَ"},
    {"number": 21, "name": "ٱتْلُ مَا أُوحِىَ"},
    {"number": 22, "name": "وَمَن يَّقْنُتْ"},
    {"number": 23, "name": "وَمَآ لِىَ"},
    {"number": 24, "name": "فَمَنِ ٱتَّقَىٰ"},
    {"number": 25, "name": "إِلَيْهِ يُرَدُّ"},
    {"number": 26, "name": "حمٓ"},
    {"number": 27, "name": "قَالَ فَمَا خَطْبُكُمْ"},
    {"number": 28, "name": "قَدْ سَمِعَ ٱللَّهُ"},
    {"number": 29, "name": "تَبَارَكَ ٱلَّذِى"},
    {"number": 30, "name": "عَمَّ يَتَسَآءَلُونَ"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greenForeground,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: suparaList.length,
        itemBuilder: (context, index) {
          final supara = suparaList[index];

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: AppColors.white,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                leading: CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.green,
                  child: Text(
                    supara["number"].toString(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                title: TitleText(
                  text: supara["name"],
                  color: AppColors.green,
                ),
                subtitle: SubtitleText(
                  text: "الجزء رقم ${supara["number"]}",
                  color: AppColors.greenLight,
                ),
                trailing: Icon(Icons.arrow_back_ios, color: AppColors.green),
                onTap: () => Get.to(
                      () => SurahScreen(
                    suparaNumber: supara["number"],
                    suparaName: supara["name"],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}