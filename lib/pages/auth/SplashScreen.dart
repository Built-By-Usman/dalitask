import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/AppColors.dart';
import '../../components/GlobalValues.dart';
import '../../controller/auth/SplashScreenController.dart';
import '../../widgets/Text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashScreenController controller = Get.put(SplashScreenController());

  @override
  void initState() {
    super.initState();
    // Call after build completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.startApp();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greenForeground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo.png", height: 120),
            const SizedBox(height: 20),
            TitleText(
              text: GlobalText.appName,
              color: AppColors.black,
            ),
          ],
        ),
      ),
    );
  }
}