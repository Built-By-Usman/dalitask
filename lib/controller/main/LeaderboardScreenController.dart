import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../models/UserModel.dart';

class LeaderboardScreenController extends GetxController {
  RxString selectedWinners = ''.obs;
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  RxBool isLoading = false.obs;
  RxList<UserModel> winners = <UserModel>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  var winnerOptions = ['آج کے فاتحین', 'ماہانہ فاتحین', 'ہمیشہ کے فاتحین'];

  void changeWinners(String newWinners) {
    selectedWinners.value = newWinners;
    getWinners();
  }

  Future<void> getWinners() async {
    isLoading.value = true;
    try {
      if (selectedWinners.value == '') {
      } else {
        QuerySnapshot querySnapshot;
        if (selectedWinners.value == 'آج کے فاتحین') {
          querySnapshot = await db
              .collection('users')
              .orderBy('todayCount', descending: true)
              .get();
        } else if (selectedWinners.value == 'ماہانہ فاتحین') {
          querySnapshot = await db
              .collection('users')
              .orderBy('monthCount', descending: true)
              .get();
        } else {
          querySnapshot = await db
              .collection('users')
              .orderBy('totalCount', descending: true)
              .get();
        }
        winners.clear();

        for (var doc in querySnapshot.docs) {
          winners.add(UserModel.fromMap(doc.data() as Map<String, dynamic>));
        }

        print(winners);
      }
    } catch (e) {
      print("Error fetching winners: $e");
    } finally {
      isLoading.value = false;
    }
  }


  String getPoints(int index) {
    if (selectedWinners.value == 'آج کے فاتحین') {
      return 'یومیہ پوائنٹس: ${winners[index].todayCount}';
    } else if (selectedWinners.value == 'ماہانہ فاتحین') {
      return 'ماہانہ پوائنٹس: ${winners[index].monthCount}';
    } else {
      return 'کل پوائنٹس: ${winners[index].totalCount}';
    }
  }
}
