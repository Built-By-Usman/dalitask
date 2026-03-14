
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/AllPages.dart';
import '../../components/AppColors.dart';
import '../../components/GetxComponents.dart';
import '../../widgets/Text.dart';

class HomeScreenController extends GetxController {
  RxInt countDurood = 0.obs;
  RxInt todayCount = 0.obs;
  RxInt monthCount = 0.obs;
  RxDouble monthlyIncome = 0.0.obs;
  RxInt streak = 0.obs;
  RxInt dailyGoal = 0.obs;
  RxInt monthlyGoal = 0.obs;
  RxInt totalCount = 0.obs;
  RxBool isLoading = false.obs;
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  RxBool buttonPressed = false.obs;
  List<int> _tapTimestamps = [];
  final int _maxTapsToCheck = 10;
  RxInt monthlyDaroodRecite = 0.obs;
  RxInt totalDaroodRecite = 0.obs;
  RxInt totalUser = 0.obs;

  List<Map<String, dynamic>> pages = [];


  @override
  void onInit() {
    super.onInit();

    // یہاں pages کو بھریں
    pages.addAll([
      {
        'icon': '📆',
        'text': 'ماہانہ شمار',
        'value': monthCount, // RxDouble
      },
      {
        'icon': '📆',
        'text': 'آج کا شمار',
        'value': todayCount, // RxInt
      },

      {
        'icon': '⏳',
        'text': 'مسلسل وقفہ',
        'value': streak, // RxInt
      },
      {
        'icon': '💰',
        'text': 'کل کمائی',
        'value': monthlyIncome, // بعد میں سیٹ کریں گے
      },
    ]);

    checkIsBlocked().then((isBlocked) {
      if (isBlocked) return;

      loadUserData();
      print(dailyGoal.value);
      print(monthlyGoal.value);

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await show();
        showAnnouncementDialog();
      });
    });
  }
  Future<bool> checkIsBlocked() async {
    final userId = auth.currentUser?.uid;
    if (userId == null) return false;

    try {
      DocumentSnapshot doc = await db.collection('users').doc(userId).get();
      if (!doc.exists) return false;

      bool isBlocked = doc['isBlocked'] ?? false;

      if (isBlocked) {
        _showBlockedDialog();
        return true;
      }

      return false;
    } catch (e) {
      print("[ERROR] Failed to check isBlocked: $e");
      return false;
    }
  }

  Future<void> show() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final docSnapshot =
      await firestore.collection('benefits').doc('current').get();
      if (!docSnapshot.exists) return;

      final appStatistics = await firestore.collection('appStatistics').doc('current').get();
      if (!docSnapshot.exists) return;

      final List benefits = docSnapshot['benefits'] ?? [];
      if (benefits.isEmpty) return;

      monthlyDaroodRecite.value= appStatistics['monthlyDaroodRecites']??0;
      totalDaroodRecite.value= appStatistics['totalDaroodRecites']??0;
      totalUser.value= appStatistics['totalUsers']??0;


      final List<Map<String, String>> items = benefits.map<Map<String, String>>((item) {
        return {
          'image': item['iconUrl'] ?? '',
          'title': item['title'] ?? '',
          'subtitle': item['description'] ?? '',
        };
      }).toList();

      await Get.dialog(
        WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            child: Stack(
              children: [

                /// MAIN FULLSCREEN BODY
                Container(
                  width: double.infinity,
                  height: Get.height,
                  color: Colors.white,
                  child: SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 70),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [

                          /// ========= HEADER (SHOW ONCE) =========
                          TitleText(
                            text: 'خوش آمدید',
                            color: AppColors.greenLight,
                          ),
                          SubtitleText(
                            text: 'روحانی سکون اور برکت کے لیے',
                            color: AppColors.grey,
                          ),

                          const SizedBox(height: 22),

                          /// ========= BIG CARD =========
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 28, horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.green,
                                  AppColors.greenLight
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 18,
                                  offset: Offset(0, 10),
                                  color: Colors.black26,
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.auto_awesome,
                                    color: Colors.white, size: 38),
                                const SizedBox(height: 8),

                                TitleText(
                                  text: 'کل درود شریف',
                                  color: Colors.white,
                                ),

                                const SizedBox(height: 6),

                                Text(
                                  formatNumber(totalDaroodRecite.value),
                                  style: TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),

                                SubtitleText(
                                  text: 'تمام صارفین کی طرف سے پڑھا گیا',
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// ========= SMALL CARDS =========
                          Row(
                            children: [

                              Expanded(
                                child: _miniCard(
                                  icon: Icons.insights,
                                  color1: Colors.blue.shade400,
                                  color2: Colors.blue.shade700,
                                  value: formatNumber(monthlyDaroodRecite.value),
                                  label: 'اس ماہ کا درود',
                                ),
                              ),

                              const SizedBox(width: 14),

                              Expanded(
                                child: _miniCard(
                                  icon: Icons.groups_rounded,
                                  color1: Colors.orange.shade400,
                                  color2: Colors.deepOrange,
                                  value: formatNumber(totalUser.value),
                                  label: 'کل صارفین',
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 28),

                          /// ========= ITEMS LIST =========
                          ...items.map((item) {

                            double imageHeight = Get.width * 0.5;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 8,
                                      color: Colors.black12,
                                      offset: Offset(0, 4))
                                ],
                              ),
                              child: Column(
                                children: [

                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16)),
                                    child: Image.network(
                                      item['image']!,
                                      height: imageHeight,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: [

                                        Text(
                                          item['title']!,
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color: AppColors.green,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(height: 8),

                                        Text(
                                          item['subtitle']!,
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),

                /// CLOSE BUTTON
                Positioned(
                  top: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close,
                          color: Colors.white, size: 28),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
    } catch (e) {
      print('Error loading intro dialog: $e');
    }
  }




  void _showBlockedDialog() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false, // 100% block. No dismiss.
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false, // back button disable
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.block, size: 60, color: AppColors.green),
                  SizedBox(height: 16),

                  Text("اکاؤنٹ بلاک ہے",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                  SizedBox(height: 12),
                  Text("براہ کرم لاگ آؤٹ کریں۔",
                      textAlign: TextAlign.center),

                  SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: () async {
                      await auth.signOut();
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.clear();
                      Get.offAllNamed(AppRoutes.login);
                    },
                    child: Text("لاگ آؤٹ کریں"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  String formatNumber(num value) {
    return NumberFormat('#,##0').format(value);
  }

  Widget _miniCard({
    required IconData icon,
    required Color color1,
    required Color color2,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(colors: [color1, color2]),
        boxShadow: [
          BoxShadow(
              blurRadius: 10,
              offset: Offset(0, 6),
              color: Colors.black12)
        ],
      ),
      child: Column(
        children: [

          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Icon(icon, color: color2),
          ),

          const SizedBox(height: 10),

          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          SubtitleText(
            text: label,
            color: Colors.white,
          ),
        ],
      ),
    );
  }



  void showAnnouncementDialog() async {
    try {
      DocumentSnapshot doc = await db
          .collection('announcements')
          .doc("current")
          .get();

      if (!doc.exists) return;

      var data = doc.data() as Map<String, dynamic>;

      String title = data['title'] ?? "Announcement";
      String message = data['message'] ?? "";
      String? imageUrl = data['imageUrl'];

      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.volume_up, color: AppColors.greenLight, size: 80),
                  SizedBox(height: 16),

                  if (imageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                  SizedBox(height: 16),
                  TitleText(text: title, color: AppColors.black),
                  SizedBox(height: 12),
                  SubtitleText(
                    text: message,
                    color: AppColors.blackLight,
                    align: TextAlign.center,
                  ),
                  SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                        Navigator.of(Get.context!).pop();
                    },
                    child: Text(
                      "ٹھیک ہے (سمجھ آ گیا)",
                      style: TextStyle(color: AppColors.green),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );

    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  /// Load user data and handle streak/dailyCount update
  Future<void> loadUserData() async {
    isLoading.value = true;

    final userId = auth.currentUser?.uid;
    if (userId == null) {
      isLoading.value = false;
      GetxComponents.showSnackBar(Get.context!,'Error', 'User not logged in');
      return;
    }

    try {
      final doc = await db.collection('users').doc(userId).get();
      if (!doc.exists) {
        isLoading.value = false;
        GetxComponents.showSnackBar(Get.context!,'Error', 'User data not found');
        return;
      }

      final data = doc.data()!;

      // Dates
      DateTime lastLogin = DateTime.tryParse(data['lastLoginDate'] ?? '')?.toLocal() ?? DateTime.now();
      DateTime now = DateTime.now();

      // Load counts
      int currentStreak = data['streak'] ?? 0;         // current consecutive streak
      int todayCountVal = data['todayCount'] ?? 0;
      int monthCountVal = data['monthCount'] ?? 0;
      int totalCountVal = data['totalCount'] ?? 0;
      dailyGoal.value=data['dailyGoal']?? 0;
      monthlyGoal.value=data['monthlyGoal']?? 0;
      int totalStreakEver = data['totalStreakEver'] ?? 0; // new field to track max streak for rewards
      List<dynamic> claimedRewards = data['claimedRewards'] ?? [];

      // Reset daily count if new day
      if (!_isSameDay(lastLogin, now)) {
        todayCountVal = 0;
      }

      // Reset monthly count if new month
      if (lastLogin.month != now.month || lastLogin.year != now.year) {
        monthCountVal = 0;
      }

      // 🔹 Update streak
      if (_isPrevDay(lastLogin, now)) {
        currentStreak++; // consecutive login
      } else if (!_isSameDay(lastLogin, now)) {
        currentStreak = 1; // missed day → start new streak
      } // else same day, do not increment

      // Update totalStreakEver for reward tracking
      if (currentStreak > totalStreakEver) {
        totalStreakEver = currentStreak;
      }

      // 🔹 Define reward milestones
      final Map<int, int> streakRewards = {
        10: 300,
        20: 500,
        30: 700,
        40: 900,
        50: 1500,
      };

      // Apply reward if milestone reached AND not claimed before
      streakRewards.forEach((milestone, reward) {
        if (totalStreakEver >= milestone && !claimedRewards.contains(milestone)) {
          monthCountVal += reward;
          totalCountVal += reward;
          claimedRewards.add(milestone);
        }
      });

      // 🔹 Update Firestore once
      await db.collection('users').doc(userId).update({
        'streak': currentStreak,
        'todayCount': todayCountVal,
        'monthCount': monthCountVal,
        'totalCount': totalCountVal,
        'lastLoginDate': now.toUtc().toIso8601String(),
        'totalStreakEver': totalStreakEver,
        'claimedRewards': claimedRewards,
      });

      // 🔹 Update reactive UI
      streak.value = currentStreak;
      todayCount.value = todayCountVal;
      monthCount.value = monthCountVal;
      totalCount.value = totalCountVal;
      monthlyIncome.value = monthCount.value * 0.1;

    } catch (e) {
      print("[ERROR] Exception fetching user data: $e");
      GetxComponents.showSnackBar(Get.context!,'Error', '$e');
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> reciteDurood() async {
    final userId = auth.currentUser?.uid;
    if (userId == null) {
      print("[ERROR] User not logged in for reciteDurood");
      return;
    }

    // Check if button is already pressed
    if (buttonPressed.value) {
      print("[INFO] reciteDurood already in progress, ignoring tap.");
      return; // ignore multiple taps
    }

    buttonPressed.value = true;

    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      _tapTimestamps.add(now);
      if (_tapTimestamps.length > _maxTapsToCheck) {
        _tapTimestamps.removeAt(0); // keep only last N taps
      }

      // Detect auto-clicking: if all gaps are nearly equal
      bool autoClickerDetected = false;
      if (_tapTimestamps.length >= 5) {
        List<int> gaps = [];
        for (int i = 1; i < _tapTimestamps.length; i++) {
          gaps.add(_tapTimestamps[i] - _tapTimestamps[i - 1]);
        }

        int maxGap = gaps.reduce((a, b) => a > b ? a : b);
        int minGap = gaps.reduce((a, b) => a < b ? a : b);

        if ((maxGap - minGap) < 50 && maxGap < 1000) {
          // gap difference < 50ms and all gaps < 1s → likely auto-clicker
          autoClickerDetected = true;
        }
      }

      // Update local counters only
      countDurood++;
      todayCount.value++;
      monthCount.value++;
      totalCount.value++;
      monthlyIncome.value = monthCount.value * 0.1;

      print("[INFO] ReciteDurood → Local counters updated.");

      if (!autoClickerDetected) {
        // Only update Firestore if not auto-clicking
        await Future.delayed(const Duration(seconds: 1)); // simulate delay
        await db.collection('users').doc(userId).update({
          'todayCount': todayCount.value,
          'monthCount': monthCount.value,
          'totalCount': totalCount.value,
        });
        print("[SUCCESS] Firestore updated at ${DateTime.now()}");
      } else {
        print("[WARNING] Auto-clicker detected! Firestore not updated.");
      }
    } catch (e) {
      print("[ERROR] Exception during reciteDurood update: $e");
    } finally {
      buttonPressed.value = false;
    }
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isPrevDay(DateTime a, DateTime b) {
    final yesterday = DateTime(
      b.year,
      b.month,
      b.day,
    ).subtract(const Duration(days: 1));
    return a.year == yesterday.year &&
        a.month == yesterday.month &&
        a.day == yesterday.day;
  }
}
