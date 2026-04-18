import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/AllPages.dart';
import '../../components/GetxComponents.dart';
import '../../models/UserModel.dart';
import '../../models/WinnerModel.dart';

class SettingScreenController extends GetxController {
  RxString selectBankOption = ''.obs;

  final TextEditingController paymentController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController completeNameController = TextEditingController();
  final TextEditingController accountNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController cnicController = TextEditingController();
  final TextEditingController dailyGoalController = TextEditingController();
  final TextEditingController monthlyGoalController = TextEditingController();

  // Separate error observables for each field
  RxString paymentError = ''.obs;
  RxString nameError = ''.obs;
  RxString accountNameError = ''.obs;
  RxString accountNumberError = ''.obs;
  RxString emailError = ''.obs;
  RxString cnicError = ''.obs;
  RxString dailyGoalError = ''.obs;
  RxString monthlyGoalError = ''.obs;
  RxList<Map<String, dynamic>> payoutRequests = <Map<String, dynamic>>[].obs;


  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  RxBool isLoading = false.obs;
  RxInt totalCount = 0.obs;
  RxString name = ''.obs;
  RxString referralCode = ''.obs;
  RxInt referralCount = 0.obs;
  RxString method = ''.obs;
  RxString accountName = ''.obs;
  RxString accountNumber = ''.obs;
  RxString cnic = ''.obs;
  RxInt dailyGoal = 0.obs;
  RxInt monthlyGoal = 0.obs;
  var email=''.obs;
  RxList<WinnerModel> winners = <WinnerModel>[].obs;


  final List<String> bankOptions = ["جاز کیش", "ایزی پیسہ", "بینک"];

  @override
  void onInit() {
    super.onInit();
    loadData();
    fetchWinners();
    loadPayoutRequests();
  }

  void changeBank(String newBank) {
    selectBankOption.value = newBank;
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      DocumentSnapshot documentSnapshot = await db
          .collection('users')
          .doc(auth.currentUser?.uid)
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
        documentSnapshot.data() as Map<String, dynamic>;

        // Ensure referralCode and referralCount exist
        if (!data.containsKey('referralCode') || data['referralCode'] == null) {
          data['referralCode'] = generateReferralCode();
        }
        if (!data.containsKey('referralCount') || data['referralCount'] == null) {
          data['referralCount'] = 0;
        }

        // Update Firestore if missing
        await db.collection('users').doc(auth.currentUser?.uid).update({
          'referralCode': data['referralCode'],
          'referralCount': data['referralCount'],
        });

        UserModel user = UserModel.fromMap(data);

        totalCount.value = user.totalCount;
        completeNameController.text = user.name;
        selectBankOption.value = user.payout['method'] ?? '';
        accountNameController.text = user.payout['accountName'] ?? '';
        accountNumberController.text = user.payout['accountNumber'] ?? '';
        cnicController.text = user.payout['cnic'] ?? '';
        dailyGoalController.text = user.dailyGoal.toString();
        monthlyGoalController.text = user.monthlyGoal.toString();

        name.value = user.name;
        method.value = user.payout['method'] ?? '';
        accountName.value = user.payout['accountName'] ?? '';
        accountNumber.value = user.payout['accountNumber'] ?? '';
        cnic.value = user.payout['cnic'] ?? '';
        dailyGoal.value = user.dailyGoal;
        monthlyGoal.value = user.monthlyGoal;

        referralCode.value = user.referralCode;
        referralCount.value = user.referralCount;
        email.value = auth.currentUser?.email ?? '';
        emailController.text = email.value;
      }
    } catch (e) {
      GetxComponents.showSnackBar(
          Get.context!,'Error', 'An unknown error occurred during loading');
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  bool checkBankDetails() {
    return accountName.value.isEmpty || accountNumber.value.isEmpty || cnic.value.isEmpty || method.value.isEmpty ? false : true;
  }
  void copyReferralCode() {
    if (referralCode.value.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: referralCode.value));
      GetxComponents.showSnackBar(Get.context!,
        'کامیابی',
        'آپ کا ریفرل کوڈ کاپی کر دیا گیا ہے',

      );
    } else {
      GetxComponents.showSnackBar(Get.context!,
        'خرابی',
        'کوڈ دستیاب نہیں ہے'
      );
    }
  }

  void updateName() async {
    String newName = completeNameController.text.trim();
    if (newName.isEmpty) {
      nameError.value = "نام خالی نہیں ہو سکتا";
      return;
    }

    if (name.value != newName) {
      try {
        isLoading.value = true;
        await db.collection('users').doc(auth.currentUser?.uid).update({
          'name': newName,
        });
        name.value = newName;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userName', newName);

        nameError.value = '';
        GetxComponents.showSnackBar(Get.context!,"کامیابی", "نام کامیابی کے ساتھ اپ ڈیٹ ہو گیا");
      } catch (e) {
        nameError.value = "نام اپ ڈیٹ کرنے میں ناکامی";
      } finally {
        isLoading.value = false;
      }
    }
  }


  Future<void> openWhatsApp() async {
    final Uri url = Uri.parse(
      "https://wa.me/923182258363?text=السلام علیکم، مجھے مدد درکار ہے۔",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'واٹس ایپ کھولنے میں مسئلہ پیش آیا';
    }
  }

  void updateAccountDetails() async {
    String newMethod = selectBankOption.value;
    String newAccountName = accountNameController.text.trim();
    String newAccountNumber = accountNumberController.text.trim();
    String newCnic = cnicController.text.trim();

    accountNameError.value = '';
    accountNumberError.value = '';
    cnicError.value = '';

    if (newMethod.isEmpty || newAccountName.isEmpty || newAccountNumber.isEmpty || newCnic.isEmpty) {
      if (newAccountName.isEmpty) accountNameError.value = "درکار ہے";
      if (newAccountNumber.isEmpty) accountNumberError.value = "درکار ہے";
      if (newCnic.isEmpty) cnicError.value = "درکار ہے";
      return;
    }

    bool hasChanges = method.value != newMethod ||
        accountName.value != newAccountName ||
        accountNumber.value != newAccountNumber ||
        cnic.value != newCnic;

    if (hasChanges) {
      try {
        isLoading.value = true;
        await db.collection('users').doc(auth.currentUser?.uid).update({
          'payout': {
            'method': newMethod,
            'accountName': newAccountName,
            'accountNumber': newAccountNumber,
            'cnic': newCnic,
          },
        });

        method.value = newMethod;
        accountName.value = newAccountName;
        accountNumber.value = newAccountNumber;
        cnic.value = newCnic;

        accountNameError.value = '';
        accountNumberError.value = '';
        cnicError.value = '';
        GetxComponents.showSnackBar(Get.context!,"کامیابی", "اکاؤنٹ کی تفصیلات کامیابی کے ساتھ اپ ڈیٹ ہو گئیں");
      } catch (e) {
        accountNameError.value = "اپ ڈیٹ میں ناکامی";
      } finally {
        isLoading.value = false;
      }
    }
  }

  void updateDailyMonthlyGoal() async {
    int newDailyGoal = int.tryParse(dailyGoalController.text.trim()) ?? 0;
    int newMonthlyGoal = int.tryParse(monthlyGoalController.text.trim()) ?? 0;

    dailyGoalError.value = '';
    monthlyGoalError.value = '';

    if (newDailyGoal <= 0) {
      dailyGoalError.value = "روزانہ مقصد صفر یا اس سے کم نہیں ہو سکتا";
      return;
    }

    if (newMonthlyGoal <= 0) {
      monthlyGoalError.value = "ماہانہ مقصد صفر یا اس سے کم نہیں ہو سکتا";
      return;
    }

    bool hasChanges = dailyGoal.value != newDailyGoal || monthlyGoal.value != newMonthlyGoal;
    if (!hasChanges) {
      dailyGoalError.value = "کوئی تبدیلی نہیں ہوئی";
      return;
    }

    try {
      isLoading.value = true;
      await db.collection('users').doc(auth.currentUser?.uid).update({
        'dailyGoal': newDailyGoal,
        'monthlyGoal': newMonthlyGoal,
      });

      dailyGoal.value = newDailyGoal;
      monthlyGoal.value = newMonthlyGoal;

      dailyGoalError.value = '';
      monthlyGoalError.value = '';
      GetxComponents.showSnackBar(Get.context!,"کامیابی", "روزانہ اور ماہانہ کے اہداف کامیابی کے ساتھ اپ ڈیٹ ہو گئے");
    } catch (e) {
      dailyGoalError.value = "اہداف اپ ڈیٹ کرنے میں ناکامی";
    } finally {
      isLoading.value = false;
    }
  }

  RxString payoutError = ''.obs;

  Future<void> fetchWinners() async {
    try {
      isLoading.value = true;

      final snapshot = await db
          .collection('winners') // 👈 apni collection ka exact name likho
          .orderBy('dateAwarded', descending: true)
          .get();

      winners.value = snapshot.docs
          .map((doc) =>
          WinnerModel.fromFirestore(doc.id, doc.data()))
          .toList();
    } catch (e) {
      print("Error fetching winners: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendPayoutRequest() async {
    payoutError.value = '';

    final requestedPoints = int.tryParse(paymentController.text);
    if (requestedPoints == null) {
      payoutError.value = "براہ مہربانی صحیح عددی قیمت درج کریں۔";
      return;
    }

    if (requestedPoints <= 0) {
      payoutError.value = "درخواست شدہ پوائنٹس صفر یا اس سے کم نہیں ہو سکتے۔";
      return;
    }

    if (requestedPoints < 100000) {
      payoutError.value = "درخواست شدہ پوائنٹس کم از کم 1 لاکھ ہونے چاہئیں۔";
      return;
    }

    if (requestedPoints > totalCount.value) {
      payoutError.value = "درخواست شدہ پوائنٹس آپ کے کل پوائنٹس سے زیادہ نہیں ہو سکتے۔";
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      payoutError.value = "لاگ ان معلومات دستیاب نہیں ہیں۔ دوبارہ لاگ ان کریں۔";
      return;
    }

    final userId = user.uid;

    final pendingRequests = await FirebaseFirestore.instance
        .collection('payoutRequests')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .get();

    if (pendingRequests.docs.isNotEmpty) {
      payoutError.value = "آپ کی پہلے سے ایک زیر التواء درخواست موجود ہے۔";
      return;
    }

    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final userName = sharedPreferences.getString('name') ?? "نام دستیاب نہیں";

      final requestData = {
        'pointsAtRequest': requestedPoints,
        'requestDate': Timestamp.now(),
        'status': 'pending',
        'userId': userId,
        'userName': userName,
      };

      await FirebaseFirestore.instance
          .collection('payoutRequests')
          .add(requestData);

      payoutError.value = '';
      paymentController.clear();
      GetxComponents.showSnackBar(Get.context!,"کامیابی", "آپ کی درخواست کامیابی کے ساتھ بھیج دی گئی!");
    } catch (e) {
      payoutError.value = "درخواست بھیجنے میں مسئلہ ہوا۔ دوبارہ کوشش کریں۔";
    }
  }

  Future<void> deletePayoutRequest(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('payoutRequests')
          .doc(id)
          .delete();

      payoutRequests.removeWhere((element) => element['id'] == id);

      GetxComponents.showSnackBar(
          Get.context!, "کامیابی", "درخواست کامیابی سے حذف کر دی گئی");
    } catch (e) {
      Get.snackbar("Error", "Delete failed: $e");
    }
  }
  Future<void> loadPayoutRequests() async {
    if (auth.currentUser == null) return;

    isLoading.value = true;
    try {
      final querySnapshot = await db
          .collection('payoutRequests')
          .where('userId', isEqualTo: auth.currentUser!.uid)
          .orderBy('requestDate', descending: true)
          .get();

      payoutRequests.value = querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // save document ID if needed
        return data;
      }).toList();
    } catch (e) {
      Get.snackbar("Error", "Failed to load payout requests: $e");
    } finally {
      isLoading.value = false;
    }
  }

  String generateReferralCode({int length = 8}) {
    const String alphabet =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

    final Random random = Random.secure();
    final List<String> code = List.generate(
      length,
          (_) => alphabet[random.nextInt(alphabet.length)],
    );

    return code.join();
  }

}






  // void myLaunchURL() async {
    //add this dependency in pubspec.yml
    // url_launcher: ^6.1.10

    // final Uri url = Uri.parse('https://devmuhammadosman.com');
    //
    // try {
    //   await launchUrl(
    //     url,
    //     mode: LaunchMode.externalApplication, // browser میں کھولے
    //   );
    // } catch (e) {
    //   debugPrint('Error launching URL: $e');
    // }
  // }

