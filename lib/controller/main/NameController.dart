import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NamesController extends GetxController {
  var namesList = <Map<String, String>>[].obs;
  var title = ''.obs;

  Future<void> loadNames(String type) async {
    try {
      String data = '';
      if (type == 'allah') {
        title.value = 'اسماء الحسنیٰ';
        data = await rootBundle.loadString('assets/json/allahNames.json');
      } else if (type == 'muhammad') {
        title.value = 'اسماء النبی ﷺ';
        data = await rootBundle.loadString('assets/json/muhammadNames.json');
      }

      final jsonResult = json.decode(data);

      namesList.value = (jsonResult['names'] as List)
          .map((item) => {
        'name': item['name']?.toString() ?? '',
        'meaning': item['meaning']?.toString() ?? '',
      })
          .toList();

      print('Loaded $type names: ${namesList.length}');
    } catch (e) {
      print("Error loading names: $e");
    }
  }
}