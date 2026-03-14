// import 'package:get/get.dart';
// import 'package:quran_flutter/quran_flutter.dart' as quran_pkg; // alias the package
// import '../../models/SurahModel.dart';
//
// class QuranController extends GetxController {
//   var isLoading = true.obs;
//   var surahList = <Surah>[].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchSurahs();
//   }
//
//   Future<void> fetchSurahs() async {
//     try {
//       isLoading(true);
//
//       // Get all Surah objects from quran_flutter
//       final List<quran_pkg.Surah> surahObjects = quran_pkg.Quran.getSurahAsList();
//
//       // Map them to your local Surah model
//       surahList.value = surahObjects
//           .map((s) => Surah(number: s.number, name: s.name))
//           .toList();
//
//     } catch (e) {
//       print('Error fetching surahs: $e');
//     } finally {
//       isLoading(false);
//     }
//   }
//
//   Future<List<quran_pkg.Verse>> fetchSurahVerses(int surahNo) async {
//     try {
//       final versesMap = await quran_pkg.Quran.getSurahVersesAsList(surahNo, language: quran_pkg.QuranLanguage.urdu);
//       return versesMap;
//     } catch (e) {
//       print('Error fetching verses: $e');
//       return [];
//     }
//   }
// }