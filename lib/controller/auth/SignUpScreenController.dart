
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../components/AllPages.dart';
import '../../components/GetxComponents.dart';
import '../../models/UserModel.dart';

class SignUpScreenController extends GetxController {
  final TextEditingController referralController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  RxBool isLoading = false.obs;

  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  var referralError = ''.obs;
  var nameError = ''.obs;
  var emailError = ''.obs;
  var passwordError = ''.obs;

  void validateInput() {
    nameError.value = '';
    emailError.value = '';
    passwordError.value = '';

    String referralCode = referralController.text.trim();
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text;

    bool isValid = true;

    if (name.isEmpty) {
      nameError.value = 'نام خالی نہیں ہو سکتا';
      isValid = false;
    }

    if (email.isEmpty) {
      emailError.value = 'ای میل خالی نہیں ہو سکتا';
      isValid = false;
    } else if (!RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email)) {
      emailError.value = 'براہ کرم درست ای میل درج کریں';
      isValid = false;
    }

    if (password.isEmpty) {
      passwordError.value = 'پاسورڈ خالی نہیں ہو سکتا';
      isValid = false;
    } else if (password.length < 6) {
      passwordError.value = 'پاسورڈ میں کم از کم 6 حروف ہونے چاہئیں';
      isValid = false;
    }

    if (isValid) {
      signUp(referralCode, name, email, password);
    }
  }

  Future<void> signUp(
      String referralCode,
      String name,
      String email,
      String password,
      ) async {
    isLoading.value = true;

    try {
      // Firebase me user create karna
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      var referrerUserId="";
      if (userCredential.user != null) {
        // Email verification bhejna
        await userCredential.user?.sendEmailVerification();

        bool successfullyReferred = false;
        final now = DateTime.now().toIso8601String(); // ek hi jagah current time store karna

        // Referral code handle karna
        if (referralCode.isNotEmpty) {
          var referralDoc =
          await db.collection('referralCodes').doc(referralCode.trim()).get();

          if (!referralDoc.exists) {
            referralError.value = "یہ ریفرل کوڈ موجود نہیں ہے";
            isLoading.value = false;
            return;
          }

          referrerUserId = referralDoc.get('userId');
          var referrerUser =
          await db.collection('users').doc(referrerUserId).get();

          if (!referrerUser.exists) {
            referralError.value = "ریفرر یوزر موجود نہیں ہے";
            isLoading.value = false;
            return;
          }

          var referrerTodayCount = referrerUser.get('todayCount');
          var referrerMonthCount = referrerUser.get('monthCount');
          var referrerTotalCount = referrerUser.get('totalCount');
          var referralCount = referrerUser.get('referralCount');

          if (referralCount >= 6) {
            referralError.value = "اس ریفرل کوڈ والے یوزر کی حد پوری ہو گئی ہے";
            isLoading.value = false;
            return;
          }

          // Referral successful
          successfullyReferred = true;

          // Referral record add karna
          await db.collection('referrals').doc().set({
            "createdAt": now,
            "pointsAwarded": 200,
            "referralCode": referralCode,
            "referredId": userCredential.user?.uid,
            "referrerId": referrerUserId,
          });

          // Referrer points update karna
          await db.collection('users').doc(referrerUserId).update({
            "todayCount":referrerTodayCount+200,
            "monthCount": referrerMonthCount + 200,
            "totalCount": referrerTotalCount + 200,
            "referralCount": referralCount + 1,
          });
        }

        // New user model create karna
        UserModel userModel = UserModel(
          name: name,
          email: email,
          dailyGoal: 0,
          monthlyGoal: 0,
          monthCount: successfullyReferred ? 200 : 0,
          streak: 0,
          isBlocked: false,
          todayCount: successfullyReferred ? 200 : 0,
          totalCount: successfullyReferred ? 200 : 0,
          lastLoginDate: now,
          lastMonthResetDate: now,
          referredBy: successfullyReferred?referrerUserId:"",
          referredAt: now,
          referralCode: "",
          referralCount:0,
          payout: {},
        );

        // Firestore me user save karna
        await db.collection('users').doc(userCredential.user?.uid).set(
          userModel.toMap(),
        );

        isLoading.value = false;

        // Login page par redirect
        Get.offNamed(AppRoutes.login);

        // Success snackbar
        GetxComponents.showSnackBar(Get.context!,
          'اکاؤنٹ کامیابی سے بنایا گیا',
          'لاگ ان کرنے کے لیے اپنی ای میل کی تصدیق کریں',
        );
      } else {
        isLoading.value = false;
        GetxComponents.showSnackBar(Get.context!,'', 'نامعلوم غلطی پیش آگئی');
      }
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      if (e.code == 'email-already-in-use') {
        GetxComponents.showSnackBar(Get.context!,'خرابی', 'یہ ای میل پہلے سے موجود ہے');
      } else if (e.code == 'weak-password') {
        GetxComponents.showSnackBar(Get.context!,'خرابی', 'پاسورڈ بہت کمزور ہے');
      } else if (e.code == 'invalid-email') {
        GetxComponents.showSnackBar(Get.context!,'خرابی', 'براہ کرم درست ای میل درج کریں');
      } else {
        GetxComponents.showSnackBar(Get.context!,
          'خرابی',
          'FirebaseAuth ایرر: ${e.message}',
        );
        print(e.message);
      }
    } catch (e) {
      isLoading.value = false;
      GetxComponents.showSnackBar(Get.context!,'کوئی ایرر پیش آیا', '$e');
      print(e);
    }
  }
}
