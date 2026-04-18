import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/AllPages.dart';
import '../../models/FaqModel.dart';
import '../../pages/main/FavouriteScreen.dart';
import '../../pages/main/HomeScreen.dart';
import '../../pages/main/LeaderBoardScreen.dart';
import '../../pages/main/QuranScreen.dart';
import '../../pages/main/SettingScreen.dart';

class MainScreenController extends GetxController {
  RxInt index = 4.obs;
  RxString userName = ''.obs;
  RxString userEmail = ''.obs;

  @override
  void onInit() {
    super.onInit();
    init();
    loadFaqs();
  }

  final pages = [
    SettingScreen(),
    FavouriteScreen(),
    QuranScreen(),
    LeaderBoardScreen(),
    HomeScreen(),
  ];

  RxList<FaqModel> faqList = <FaqModel>[].obs;
  RxBool showFaq = false.obs;

  Future<void> loadFaqs() async {
    try {
      final String response =
      await rootBundle.loadString('assets/json/faqs.json');

      final data = json.decode(response) as List;

      faqList.value =
          data.map((e) => FaqModel.fromJson(e)).toList();

      print("FAQs loaded: ${faqList.length}");
    } catch (e) {
      print("FAQ loading error: $e");
    }
  }

  Future<void> init() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userName.value = await sharedPreferences.getString('name') ?? 'name';
    userEmail.value =
        await sharedPreferences.getString('email') ?? 'example@emil.com';
  }

  Future<void> logout() async {
    bool? confirm = await Get.defaultDialog<bool>(
      title: "تصدیق",
      titleStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      content: Text(
        "کیا آپ واقعی لاگ آؤٹ کرنا چاہتے ہیں؟",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16),
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () {
          Get.back(result: true); // user confirmed
        },
        child: Text("ہاں", style: TextStyle(color: Colors.white)),
      ),
      cancel: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () {
          Get.back(result: false); // user canceled
        },
        child: Text("نہیں", style: TextStyle(color: Colors.white)),
      ),
    );

    if (confirm == true) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setBool('isLoggedIn', false);
      Get.offNamed(AppRoutes.signup);
    }
  }
}
