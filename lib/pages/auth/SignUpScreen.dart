
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../components/AllPages.dart';
import '../../components/AppColors.dart';
import '../../components/GlobalValues.dart';
import '../../controller/auth/SignUpScreenController.dart';
import '../../widgets/MyElevatedButton.dart';
import '../../widgets/MyTextField.dart';
import '../../widgets/Text.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final SignUpScreenController controller = Get.put(SignUpScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greenForeground,
      body: SafeArea(
        child: Center(
          child: Obx(() {
            if (controller.isLoading.value) {
              return Lottie.asset(
                'assets/lottie/loading.json',
                width: 200,
                height: 200,
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 40,
                    horizontal: 16,
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 10,
                    color: AppColors.white,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🔹 Header with gradient
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.greenLight, AppColors.green],
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              child: Column(
                                children: [
                                  TitleText(
                                    text: GlobalText.signupTitle,
                                    color: AppColors.white,
                                  ),
                                  const SizedBox(height: 5),
                                  SubtitleText(
                                    text: GlobalText.signupSubtitle,
                                    color: AppColors.white,
                                    align: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // 🔹 Form Fields
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 30,
                              horizontal: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // Name
                                SimpleText(
                                  text: GlobalText.referral,
                                  color: AppColors.black,
                                  align: TextAlign.start,
                                ),
                                const SizedBox(height: 5),
                                Obx(
                                      () => MyTextField(
                                    controller: controller.referralController,
                                    hint: GlobalText.referralHint,
                                    isPassword: false,
                                    errorMessage:
                                    controller.referralError.value.isEmpty
                                        ? null
                                        : controller.referralError.value,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                SimpleText(
                                  text: GlobalText.fullName,
                                  color: AppColors.black,
                                  align: TextAlign.start,
                                ),
                                Obx(
                                  () => MyTextField(
                                    controller: controller.nameController,
                                    hint: GlobalText.fullNameHint,
                                    isPassword: false,
                                    errorMessage:
                                        controller.nameError.value.isEmpty
                                        ? null
                                        : controller.nameError.value,
                                  ),
                                ),
                                const SizedBox(height: 15),

                                // Email
                                SimpleText(
                                  text: GlobalText.email,
                                  color: AppColors.black,
                                  align: TextAlign.start,
                                ),
                                const SizedBox(height: 5),
                                Obx(
                                  () => MyTextField(
                                    controller: controller.emailController,
                                    hint: GlobalText.emailHint,
                                    isPassword: false,
                                    errorMessage:
                                        controller.emailError.value.isEmpty
                                        ? null
                                        : controller.emailError.value,
                                  ),
                                ),
                                const SizedBox(height: 15),

                                // Password
                                SimpleText(
                                  text: GlobalText.password,
                                  color: AppColors.black,
                                  align: TextAlign.start,
                                ),
                                const SizedBox(height: 5),
                                Obx(
                                  () => MyTextField(
                                    controller: controller.passwordController,
                                    hint: GlobalText.passwordHint,
                                    isPassword: true,
                                    errorMessage:
                                        controller.passwordError.value.isEmpty
                                        ? null
                                        : controller.passwordError.value,
                                  ),
                                ),
                                const SizedBox(height: 25),

                                // Signup Button
                                Center(
                                  child: MyElevatedButton(
                                    text: GlobalText.createAccountBtn,
                                    textColor: AppColors.white,
                                    method: controller.validateInput,
                                      gradient1: AppColors.greenLight,
                                      gradient2: AppColors.green
                                  ),
                                ),
                                const SizedBox(height: 15),

                                // Already have account
                                Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.offNamed(AppRoutes.login);
                                    },
                                    child: SubtitleText(
                                      text: GlobalText.alreadyHaveAccount,
                                      color: AppColors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          }),
        ),
      ),
    );
  }
}
