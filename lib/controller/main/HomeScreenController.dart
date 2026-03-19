
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/AllPages.dart';
import '../../components/AppColors.dart';
import '../../components/GetxComponents.dart';
import '../../widgets/Text.dart';

class HomeScreenController extends GetxController {

  // ==========================================================
  // 🔹 Firebase Instances
  // ==========================================================
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  // ==========================================================
  // 🔹 Reactive Variables
  // ==========================================================
  RxInt todayCount = 0.obs;
  RxInt monthCount = 0.obs;
  RxInt totalCount = 0.obs;
  RxInt streak = 0.obs;

  RxInt dailyGoal = 0.obs;
  RxInt monthlyGoal = 0.obs;

  RxDouble monthlyIncome = 0.0.obs;

  RxBool isLoading = false.obs;
  RxBool buttonPressed = false.obs;

  RxInt monthlyDaroodRecite = 0.obs;
  RxInt totalDaroodRecite = 0.obs;
  RxInt totalUser = 0.obs;

  // ==========================================================
// 🔹 HOME GRID DATA
// ==========================================================

  List<Map<String, dynamic>> get pages => [
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
  ];
  // ==========================================================
  // 🔹 Auto Tap Detection
  // ==========================================================
  final List<int> _tapTimes = [];
  final int _maxTapCheck = 10;

  // ==========================================================
  // 🔹 INIT
  // ==========================================================
  @override
  void onInit() {
    super.onInit();

    checkIfBlocked().then((blocked) {
      if (!blocked) {
        loadUserData();

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await showIntroDialog();
          showAnnouncementDialog();
        });
      }
    });
  }

  // ==========================================================
  // 🔹 BLOCK CHECK
  // ==========================================================
  Future<bool> checkIfBlocked() async {
    final uid = auth.currentUser?.uid;
    if (uid == null) return false;

    try {
      final doc = await db.collection('users').doc(uid).get();
      bool blocked = doc.data()?['isBlocked'] ?? false;

      if (blocked) {
        _showBlockedDialog();
        return true;
      }

      return false;
    } catch (e) {
      print("Block check error: $e");
      return false;
    }
  }

  void _showBlockedDialog() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.block, size: 60, color: AppColors.green),
                const SizedBox(height: 20),
                const Text("اکاؤنٹ بلاک ہے",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text("براہ کرم لاگ آؤٹ کریں۔"),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _logoutUser,
                  child: const Text("لاگ آؤٹ کریں"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _logoutUser() async {
    await auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed(AppRoutes.login);
  }

  // ==========================================================
  // 🔹 INTRO DIALOG
  // ==========================================================
  Future<void> showIntroDialog() async {
    try {
      final benefitsDoc =
      await db.collection('benefits').doc('current').get();
      final statsDoc =
      await db.collection('appStatistics').doc('current').get();

      if (!benefitsDoc.exists || !statsDoc.exists) return;

      final List benefits = benefitsDoc.data()?['benefits'] ?? [];
      if (benefits.isEmpty) return;

      monthlyDaroodRecite.value =
          statsDoc.data()?['monthlyDaroodRecites'] ?? 0;
      totalDaroodRecite.value =
          statsDoc.data()?['totalDaroodRecites'] ?? 0;
      totalUser.value =
          statsDoc.data()?['totalUsers'] ?? 0;

      List<Map<String, String>> items =
      benefits.map<Map<String, String>>((item) {
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

                          TitleText(
                            text: 'خوش آمدید',
                            color: AppColors.greenLight,
                          ),
                          SubtitleText(
                            text: 'روحانی سکون اور برکت کے لیے',
                            color: AppColors.grey,
                          ),

                          const SizedBox(height: 22),

                          _buildTotalCard(),

                          const SizedBox(height: 20),

                          Row(
                            children: [
                              Expanded(
                                child: _miniCard(
                                  icon: Icons.insights,
                                  color1: Colors.blue.shade400,
                                  color2: Colors.blue.shade700,
                                  value: formatNumber(
                                      monthlyDaroodRecite.value),
                                  label: 'اس ماہ کا درود',
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: _miniCard(
                                  icon: Icons.groups,
                                  color1: Colors.orange.shade400,
                                  color2: Colors.deepOrange,
                                  value:
                                  formatNumber(totalUser.value),
                                  label: 'کل صارفین',
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 28),

                          ...items.map((item) =>
                              _buildBenefitItem(item)),
                        ],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close,
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
      print("Intro dialog error: $e");
    }
  }

  // ==========================================================
  // 🔹 MINI CARD (NOW INCLUDED)
  // ==========================================================
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
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, 6),
            color: Colors.black12,
          )
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
            style: const TextStyle(
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

  // ==========================================================
  // 🔹 TOTAL CARD
  // ==========================================================
  Widget _buildTotalCard() {
    return Container(
      padding:
      const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [AppColors.green, AppColors.greenLight],
        ),
      ),
      child: Column(
        children: [
          const Icon(Icons.auto_awesome,
              color: Colors.white, size: 38),
          const SizedBox(height: 10),
          const Text(
            'کل درود شریف',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            formatNumber(totalDaroodRecite.value),
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Text(
            'تمام صارفین کی طرف سے پڑھا گیا',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(Map<String, String> item) {
    double imageHeight = Get.width * 0.5;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
              blurRadius: 8,
              color: Colors.black12,
              offset: Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(16)),
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
              crossAxisAlignment: CrossAxisAlignment.end,
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
  }

  // ==========================================================
  // 🔹 LOAD USER DATA + STREAK + REWARDS
  // ==========================================================
  Future<void> loadUserData() async {
    isLoading.value = true;

    final uid = auth.currentUser?.uid;
    if (uid == null) return;

    try {
      final doc = await db.collection('users').doc(uid).get();
      if (!doc.exists) return;

      final data = doc.data()!;
      DateTime now = DateTime.now();
      DateTime lastLogin =
          DateTime.tryParse(data['lastLoginDate'] ?? '')?.toLocal() ?? now;

      int currentStreak = data['streak'] ?? 0;
      int today = data['todayCount'] ?? 0;
      int month = data['monthCount'] ?? 0;
      int total = data['totalCount'] ?? 0;
      int totalStreakEver = data['totalStreakEver'] ?? 0;
      List claimedRewards = data['claimedRewards'] ?? [];

      dailyGoal.value = data['dailyGoal'] ?? 0;
      monthlyGoal.value = data['monthlyGoal'] ?? 0;

      if (!_isSameDay(lastLogin, now)) today = 0;
      if (lastLogin.month != now.month ||
          lastLogin.year != now.year) {
        month = 0;
      }

      if (_isPreviousDay(lastLogin, now)) {
        currentStreak++;
      } else if (!_isSameDay(lastLogin, now)) {
        currentStreak = 1;
      }

      if (currentStreak > totalStreakEver) {
        totalStreakEver = currentStreak;
      }

      Map<int, int> rewards = {
        10: 300,
        20: 500,
        30: 700,
        40: 900,
        50: 1500,
      };

      rewards.forEach((milestone, reward) {
        if (totalStreakEver >= milestone &&
            !claimedRewards.contains(milestone)) {
          month += reward;
          total += reward;
          claimedRewards.add(milestone);
        }
      });

      await db.collection('users').doc(uid).update({
        'streak': currentStreak,
        'todayCount': today,
        'monthCount': month,
        'totalCount': total,
        'lastLoginDate': now.toUtc().toIso8601String(),
        'totalStreakEver': totalStreakEver,
        'claimedRewards': claimedRewards,
      });

      streak.value = currentStreak;
      todayCount.value = today;
      monthCount.value = month;
      totalCount.value = total;
      monthlyIncome.value = month * 0.1;

    } finally {
      isLoading.value = false;
    }
  }

  // ==========================================================
  // 🔹 RECITE DUROOD
  // ==========================================================
  Future<void> reciteDurood() async {
    final uid = auth.currentUser?.uid;
    if (uid == null || buttonPressed.value) return;

    buttonPressed.value = true;

    try {
      bool autoClick = _detectAutoClick();

      todayCount.value++;
      monthCount.value++;
      totalCount.value++;
      monthlyIncome.value = monthCount.value * 0.1;

      if (!autoClick) {
        await Future.delayed(const Duration(seconds: 1));
        await db.collection('users').doc(uid).update({
          'todayCount': todayCount.value,
          'monthCount': monthCount.value,
          'totalCount': totalCount.value,
        });
      }

    } finally {
      buttonPressed.value = false;
    }
  }

  bool _detectAutoClick() {
    int now = DateTime.now().millisecondsSinceEpoch;
    _tapTimes.add(now);

    if (_tapTimes.length > _maxTapCheck) {
      _tapTimes.removeAt(0);
    }

    if (_tapTimes.length < 5) return false;

    List<int> gaps = [];
    for (int i = 1; i < _tapTimes.length; i++) {
      gaps.add(_tapTimes[i] - _tapTimes[i - 1]);
    }

    int maxGap = gaps.reduce((a, b) => a > b ? a : b);
    int minGap = gaps.reduce((a, b) => a < b ? a : b);

    return (maxGap - minGap) < 50 && maxGap < 1000;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isPreviousDay(DateTime a, DateTime b) {
    final yesterday =
    DateTime(b.year, b.month, b.day)
        .subtract(const Duration(days: 1));
    return _isSameDay(a, yesterday);
  }

  String formatNumber(num value) =>
      NumberFormat('#,##0').format(value);


  Future<void> showAnnouncementDialog() async {
    try {
      final doc =
      await db.collection('announcements').doc("current").get();
      if (!doc.exists) return;

      final data = doc.data()!;
      String title = data['title'] ?? "Announcement";
      String message = data['message'] ?? "";
      String? imageUrl = data['imageUrl'];

      Get.dialog(
        Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (imageUrl != null)
                  Image.network(imageUrl, height: 150),
                const SizedBox(height: 15),
                TitleText(text: title, color: AppColors.black),
                const SizedBox(height: 10),
                SubtitleText(
                    text: message,
                    color: AppColors.blackLight,
                    align: TextAlign.center),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text("ٹھیک ہے (سمجھ آ گیا)"),
                )
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );

    } catch (e) {
      print("Announcement Error: $e");
    }
  }
}


