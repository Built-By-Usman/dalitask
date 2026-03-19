import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/AllPages.dart';
import '../../components/AppColors.dart';

class SplashScreenController extends GetxController {
  String userId = '';
  bool isLoggedIn = false;


  Future<void> startApp() async {
    bool shouldContinue = await checkAppVersion();

    if (!shouldContinue) {
      return; // stop if app outdated
    }

    await _initPrefsAndRoute();
  }

  Future<bool> checkAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = int.tryParse(packageInfo.buildNumber) ?? 1;
      print("📱 Current version: $currentVersion");

      final doc = await FirebaseFirestore.instance
          .collection('version')
          .doc('currentVersion')
          .get();

      if (!doc.exists) return true;

      final dynamic versionValue = doc['code'];
      final latestVersion = versionValue is int
          ? versionValue
          : int.tryParse(versionValue.toString()) ?? 1;

      if (currentVersion < latestVersion) {
        await _showUpdateDialog(latestVersion);
        return false;
      }

      return true;
    } catch (e) {
      print('❌ Version check failed: $e');
      return true;
    }
  }

  Future<void> _showUpdateDialog(int latestVersion) async {
    await Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.update, size: 60, color: AppColors.green),
              SizedBox(height: 16),
              Text(
                'اپڈیٹ ضروری ہے',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.green,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                'ایپ کا نیا ورژن $latestVersion دستیاب ہے۔\nجاری رکھنے کے لیے اپڈیٹ کریں۔',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final uri = Uri.parse(
                      'https://play.google.com/store/apps/details?id=com.abdullahiqbal.dalitask&hl=en',
                    );
                    try {
                      await launchUrl(uri,
                          mode: LaunchMode.externalApplication);
                    } catch (e) {
                      debugPrint('❌ Could not launch update URL: $e');
                    }
                  },
                  icon: Icon(Icons.download, color: Colors.white),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'ابھی اپڈیٹ کریں',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _initPrefsAndRoute() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('userId') ?? '';
      isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
    } catch (e) {
      print("❌ SharedPreferences init failed: $e");
    }

    Future.delayed(const Duration(seconds: 2), () {
      if (isLoggedIn) {
        Get.offNamed(AppRoutes.main);
      } else {
        Get.offNamed(AppRoutes.signup);
      }
    });
  }
}