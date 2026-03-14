
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/AllPages.dart';
import '../../components/GetxComponents.dart';

class LoginScreenController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  RxBool isLoading=false.obs;

  var emailError = ''.obs;
  var passwordError = ''.obs;

  // Input validation
  void validateInput() {
    emailError.value = '';
    passwordError.value = '';

    var email = emailController.text.trim();
    var password = passwordController.text.trim();

    bool isValid = true;

    if (email.isEmpty) {
      emailError.value = 'براہ کرم ای میل درج کریں';
      isValid = false;
    }

    if (password.isEmpty) {
      passwordError.value = 'براہ کرم پاسورڈ درج کریں';
      isValid = false;
    }

    if (isValid) {
      login(email, password);
    }
  }

  // Login function
  Future<void> login(String email, String password) async {
    isLoading.value = true;

    try {
      UserCredential userCredential =
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user == null) return;

      // 🔥 IMPORTANT: Reload to get latest email after verification
      await user.reload();
      user = auth.currentUser;

      if (user == null) return;

      final authEmail = user.email ?? '';

      DocumentSnapshot snapshot =
      await db.collection('users').doc(user.uid).get();

      if (!snapshot.exists) {
        isLoading.value = false;
        GetxComponents.showSnackBar(
            Get.context!, 'خرابی', 'یوزر کا ڈیٹا نہیں ملا');
        return;
      }

      final name = snapshot.get('name');

      /// 🔥 Sync Firestore email if changed
      if (snapshot.get('email') != authEmail) {
        await db.collection('users').doc(user.uid).update({
          'email': authEmail,
        });
      }

      /// 🔥 Save latest values in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', user.uid);
      await prefs.setString('name', name);
      await prefs.setString('email', authEmail);
      await prefs.setBool('isLoggedIn', true);

      isLoading.value = false;

      Get.offNamed(AppRoutes.main);

      GetxComponents.showSnackBar(
        Get.context!,
        'خوش آمدید',
        'آپ کامیابی کے ساتھ لاگ ان ہو گئے ہیں',
      );

    } on FirebaseAuthException catch (e) {
      isLoading.value = false;

      if (e.code == 'user-not-found') {
        GetxComponents.showSnackBar(
            Get.context!, 'خرابی', 'ای میل موجود نہیں ہے');
      } else if (e.code == 'wrong-password') {
        GetxComponents.showSnackBar(
            Get.context!, 'خرابی', 'پاسورڈ غلط ہے');
      } else if (e.code == 'invalid-email') {
        GetxComponents.showSnackBar(
            Get.context!, 'خرابی', 'براہ کرم درست ای میل درج کریں');
      } else {
        GetxComponents.showSnackBar(
            Get.context!, 'خرابی', e.message ?? 'ایرر');
      }
    } catch (e) {
      isLoading.value = false;
      GetxComponents.showSnackBar(
          Get.context!, 'کوئی ایرر پیش آیا', '$e');
    }
  }
}
