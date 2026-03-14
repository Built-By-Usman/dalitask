import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../components/AppColors.dart';
import '../../controller/main/SettingScreenController.dart';
import '../../widgets/MyTextField.dart';
import '../../widgets/SettingProfileContainer.dart';
import '../../widgets/Text.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});

  final SettingScreenController controller = Get.put(SettingScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greenForeground,
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? Center(
                  child: Lottie.asset(
                    'assets/lottie/loading.json',
                    width: 200,
                    height: 200,
                  ),
                )
              : RefreshIndicator(
                  backgroundColor: AppColors.greenLight,
                  color: AppColors.white,
                  onRefresh: () async {
                    await controller.loadData();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          /// Payment Card
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            color: AppColors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  TitleText(
                                    text: 'آپ کے پوائنٹس',
                                    color: AppColors.black,
                                  ),
                                  SizedBox(height: 5),
                                  TitleText(
                                    text: '     ${controller.totalCount}',
                                    color: AppColors.green,
                                  ),

                                  controller.checkBankDetails()
                                      ? SizedBox.shrink()
                                      : Container(
                                          margin: EdgeInsets.only(top: 10),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            color: AppColors.redLight
                                                .withOpacity(0.7),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: SimpleText(
                                              text:
                                                  'ادائیگی کی درخواست بھیجنے سے پہلے اپنی بینک کی تفصیلات مکمل کریں',
                                              color: AppColors.red,
                                            ),
                                          ),
                                        ),

                                  SizedBox(height: 20),

                                  SubtitleText(
                                    text: 'ادائیگی کی رقم',
                                    color: AppColors.black,
                                  ),
                                  SizedBox(height: 5),
                                  MyTextField(
                                    controller: controller.paymentController,
                                    hint: 'کم از کم 30000 پوائنٹس',
                                    isPassword: false,
                                    errorMessage:
                                        controller.payoutError.value.isEmpty
                                        ? null
                                        : controller.payoutError.value,
                                  ),
                                  SizedBox(height: 20),

                                  Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.sendPayoutRequest();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.greenLightest,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: SubtitleText(
                                            text: 'ادائیگی کی درخواست بھیجیں',
                                            color: AppColors.blackLight,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 10),

                          /// User profile management
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            color: AppColors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 20,
                              ),
                              child: Column(
                                children: [
                                  SettingProfileContainer(
                                    text: 'پروفائل',
                                    icon: Icons.person,
                                    dropDownContent: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        SubtitleText(
                                          text: 'مکمل نام',
                                          color: AppColors.black,
                                        ),
                                        SizedBox(height: 5),
                                        MyTextField(
                                          controller:
                                              controller.completeNameController,
                                          hint: controller.name.value,
                                          isPassword: false,
                                          errorMessage:
                                              controller.nameError.value.isEmpty
                                              ? null
                                              : controller.nameError.value,
                                        ),
                                        SizedBox(height: 10),
                                        Center(
                                          child: GestureDetector(
                                            onTap: () {
                                              controller.updateName();
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppColors.greenLightest,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  12.0,
                                                ),
                                                child: SubtitleText(
                                                  text: 'نام تبدیل کریں',
                                                  color: AppColors.blackLight,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 20),
                                  SettingProfileContainer(
                                    text: 'ای میل',
                                    icon: Icons.email,
                                    dropDownContent: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        SubtitleText(
                                          text: 'موجودہ ای میل',
                                          color: AppColors.black,
                                        ),
                                        SizedBox(height: 5),
                                        MyTextField(
                                          controller:
                                              controller.emailController,
                                          hint: controller.email.value,
                                          isPassword: false,
                                          errorMessage:
                                              controller
                                                  .emailError
                                                  .value
                                                  .isEmpty
                                              ? null
                                              : controller.emailError.value,
                                        ),
                                        SizedBox(height: 10),
                                        Center(
                                          child: GestureDetector(
                                            onTap: () {
                                              controller.updateEmail();
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppColors.greenLightest,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  12.0,
                                                ),
                                                child: SubtitleText(
                                                  text: 'ای میل اپڈیٹ کریں',
                                                  color: AppColors.blackLight,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),

                                  ///Referral Program
                                  SettingProfileContainer(
                                    text: 'ریفرل پروگرام',
                                    icon: Icons.people_alt,
                                    dropDownContent: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(
                                              Icons.group,
                                              color: AppColors.greenLight,
                                            ),
                                            RichText(
                                              textAlign: TextAlign.right,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: 'آپ نے\n ',
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '${controller.referralCount.value}\n',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 24,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: ' لوگوں کو مدعو کیا',
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Card(
                                            elevation: 4,
                                            color: Colors.green.shade50,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  RichText(
                                                    textAlign: TextAlign.right,
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              'آپ کا ریفرل کوڈ ہے\n',
                                                          style: TextStyle(
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: controller
                                                              .referralCode
                                                              .value,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 22,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 12),
                                                  Center(
                                                    child: ElevatedButton.icon(
                                                      onPressed: () {
                                                        controller
                                                            .copyReferralCode();
                                                      },
                                                      icon: Icon(
                                                        Icons.copy,
                                                        color: Colors.white,
                                                      ),
                                                      label: Text(
                                                        'اپنا کوڈ کاپی کریں',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      style: ElevatedButton.styleFrom(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 24,
                                                              vertical: 12,
                                                            ),
                                                        backgroundColor:
                                                            Colors.green,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                        elevation: 4,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 20),
                                                  // Step by step explanation with RichText
                                                  TitleText(
                                                    text:
                                                        'یہ کیسے کام کرتا ہے؟',
                                                    color: Colors.black,
                                                  ),
                                                  SizedBox(height: 8),
                                                  Directionality(
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    child: RichText(
                                                      textAlign:
                                                          TextAlign.right,
                                                      text: TextSpan(
                                                        style: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 15,
                                                          height: 1.5,
                                                        ),
                                                        children: [
                                                          TextSpan(
                                                            text: '1. ',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                'اپنے دوستوں کو اپنا ریفرل کوڈ بھیجیں\n',
                                                          ),
                                                          TextSpan(
                                                            text: '2. ',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                'جب وہ سائن اپ کر لیں تو ریفرل پروگرام پیج پر آپ کا کوڈ استعمال کریں\n',
                                                          ),
                                                          TextSpan(
                                                            text: '3. ',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                'دونوں کو 200 پوائنٹس ملیں گے!',
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 20),

                                  /// Bank info
                                  // SettingProfileContainer(
                                  //   text: 'بینک کی تفصیلات',
                                  //   icon: Icons.credit_card,
                                  //   dropDownContent: Column(
                                  //     crossAxisAlignment:
                                  //         CrossAxisAlignment.end,
                                  //     children: [
                                  //       SizedBox(height: 10),
                                  //       Obx(
                                  //         () => DropdownButtonHideUnderline(
                                  //           child: Container(
                                  //             padding: EdgeInsets.symmetric(
                                  //               horizontal: 12,
                                  //             ),
                                  //             decoration: BoxDecoration(
                                  //               color: Colors.grey[200],
                                  //               borderRadius:
                                  //                   BorderRadius.circular(8),
                                  //               border: Border.all(
                                  //                 color: Colors.grey.shade400,
                                  //               ),
                                  //             ),
                                  //             child: DropdownButton<String>(
                                  //               hint: Align(
                                  //                 alignment:
                                  //                     Alignment.centerRight,
                                  //                 child: Text(
                                  //                   controller
                                  //                               .selectBankOption
                                  //                               .value ==
                                  //                           ''
                                  //                       ? "بینک منتخب کریں"
                                  //                       : controller
                                  //                             .selectBankOption
                                  //                             .value,
                                  //                   textAlign: TextAlign.right,
                                  //                   style: TextStyle(
                                  //                     color: AppColors.black,
                                  //                     fontSize: 16,
                                  //                   ),
                                  //                 ),
                                  //               ),
                                  //               value:
                                  //                   controller.bankOptions
                                  //                           .contains(
                                  //                             controller
                                  //                                 .selectBankOption
                                  //                                 .value,
                                  //                           ) &&
                                  //                       controller
                                  //                           .selectBankOption
                                  //                           .value
                                  //                           .isNotEmpty
                                  //                   ? controller
                                  //                         .selectBankOption
                                  //                         .value
                                  //                   : null,
                                  //               isExpanded: true,
                                  //               icon: Icon(
                                  //                 Icons.keyboard_arrow_down,
                                  //                 color: AppColors.black,
                                  //               ),
                                  //               items: controller.bankOptions
                                  //                   .map(
                                  //                     (
                                  //                       bank,
                                  //                     ) => DropdownMenuItem(
                                  //                       value: bank,
                                  //                       child: Align(
                                  //                         alignment: Alignment
                                  //                             .centerRight,
                                  //                         child: Text(
                                  //                           bank,
                                  //                           textAlign:
                                  //                               TextAlign.right,
                                  //                           style: TextStyle(
                                  //                             color: AppColors
                                  //                                 .black,
                                  //                             fontSize: 16,
                                  //                           ),
                                  //                         ),
                                  //                       ),
                                  //                     ),
                                  //                   )
                                  //                   .toList(),
                                  //               onChanged: (value) {
                                  //                 controller.changeBank(value!);
                                  //               },
                                  //               dropdownColor: Colors.grey[200],
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //       SizedBox(height: 10),
                                  //       SubtitleText(
                                  //         text: 'اکاؤنٹ ہولڈر کا نام',
                                  //         color: AppColors.black,
                                  //       ),
                                  //       SizedBox(height: 5),
                                  //       MyTextField(
                                  //         controller:
                                  //             controller.accountNameController,
                                  //         hint: controller.accountName.value,
                                  //         isPassword: false,
                                  //         errorMessage:
                                  //             controller
                                  //                 .accountNameError
                                  //                 .value
                                  //                 .isEmpty
                                  //             ? null
                                  //             : controller
                                  //                   .accountNameError
                                  //                   .value,
                                  //       ),
                                  //       SizedBox(height: 10),
                                  //       SubtitleText(
                                  //         text: 'اکاؤنٹ / موبائل نمبر',
                                  //         color: AppColors.black,
                                  //       ),
                                  //       SizedBox(height: 5),
                                  //       MyTextField(
                                  //         controller: controller
                                  //             .accountNumberController,
                                  //         hint: controller.accountNumber.value,
                                  //         isPassword: false,
                                  //         errorMessage:
                                  //             controller
                                  //                 .accountNumberError
                                  //                 .value
                                  //                 .isEmpty
                                  //             ? null
                                  //             : controller
                                  //                   .accountNumberError
                                  //                   .value,
                                  //       ),
                                  //       SizedBox(height: 10),
                                  //       SubtitleText(
                                  //         text: 'شناختی کارڈ نمبر',
                                  //         color: AppColors.black,
                                  //       ),
                                  //       SizedBox(height: 5),
                                  //       MyTextField(
                                  //         controller: controller.cnicController,
                                  //         hint: controller.cnic.value,
                                  //         isPassword: false,
                                  //         errorMessage:
                                  //             controller.cnicError.value.isEmpty
                                  //             ? null
                                  //             : controller.cnicError.value,
                                  //       ),
                                  //       SizedBox(height: 10),
                                  //       Center(
                                  //         child: GestureDetector(
                                  //           onTap: () {
                                  //             controller.updateAccountDetails();
                                  //           },
                                  //           child: Container(
                                  //             decoration: BoxDecoration(
                                  //               color: AppColors.greenLightest,
                                  //               borderRadius:
                                  //                   BorderRadius.circular(8),
                                  //             ),
                                  //             child: Padding(
                                  //               padding: const EdgeInsets.all(
                                  //                 12.0,
                                  //               ),
                                  //               child: SubtitleText(
                                  //                 text: 'تفصیلات محفوظ کریں',
                                  //                 color: AppColors.blackLight,
                                  //               ),
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  // SizedBox(height: 20),

                                  /// Daily / Monthly goals
                                  SettingProfileContainer(
                                    text: 'روزانہ / ماہانہ مقصد',
                                    icon: Icons.ac_unit_rounded,
                                    dropDownContent: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        SubtitleText(
                                          text: 'روزانہ کا مقصد',
                                          color: AppColors.black,
                                        ),
                                        SizedBox(height: 5),
                                        MyTextField(
                                          controller:
                                              controller.dailyGoalController,
                                          hint: controller.dailyGoal.value
                                              .toString(),
                                          isPassword: false,
                                          errorMessage:
                                              controller
                                                  .dailyGoalError
                                                  .value
                                                  .isEmpty
                                              ? null
                                              : controller.dailyGoalError.value,
                                        ),
                                        SizedBox(height: 10),
                                        SubtitleText(
                                          text: 'ماہانہ کا مقصد',
                                          color: AppColors.black,
                                        ),
                                        SizedBox(height: 5),
                                        MyTextField(
                                          controller:
                                              controller.monthlyGoalController,
                                          hint: controller.monthlyGoal.value
                                              .toString(),
                                          isPassword: false,
                                          errorMessage:
                                              controller
                                                  .monthlyGoalError
                                                  .value
                                                  .isEmpty
                                              ? null
                                              : controller
                                                    .monthlyGoalError
                                                    .value,
                                        ),
                                        SizedBox(height: 10),
                                        Center(
                                          child: GestureDetector(
                                            onTap: () {
                                              controller
                                                  .updateDailyMonthlyGoal();
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppColors.greenLightest,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  12.0,
                                                ),
                                                child: SubtitleText(
                                                  text: 'مقاصد اپڈیٹ کریں',
                                                  color: AppColors.blackLight,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 20),

                                  /// Terms & conditions
                                  SettingProfileContainer(
                                    text: 'قواعد و ضوابط',
                                    icon: Icons.security,
                                    dropDownContent: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Card(
                                          elevation: 5,
                                          color: AppColors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                TitleText(
                                                  text: 'انعامات کے قوانین',
                                                  color: AppColors.black,
                                                ),
                                                SizedBox(height: 10),
                                                SubtitleText(
                                                  text:
                                                      '• یہاں آپ کو ماہانہ اور مجموعی انعامات کے لیے اہلیت، فاتح کے انتخاب کا طریقہ کار، اور پوائنٹس کے دعوے کی شرائط و ضوابط ملیں گے.\n'
                                                      '• ہر مہینے کی 29 تاریخ کو اعلان کیا جائے گا.\n'
                                                      '• ادائیگی کے دعوے کے لیے کم از کم 30,000 پوائنٹس درکار ہیں.\n'
                                                      '• ادائیگی کی تفصیلات (بینک/ایزی پیسہ/جاز کیش) کا مکمل اندراج ضروری ہے۔ نامکمل تفصیلات کی صورت میں آپ کی زیر التواء درخواستیں خود بخود منسوخ کر دی جائیں گی.\n'
                                                      '• پوائنٹس صرف ایک بار ہی کلیم کیے جا سکتے ہیں.',
                                                  color: AppColors.blackLight,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Card(
                                          elevation: 5,
                                          color: AppColors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                TitleText(
                                                  text: 'پرائیویسی پالیسی',
                                                  color: AppColors.black,
                                                ),
                                                SizedBox(height: 10),
                                                SubtitleText(
                                                  text:
                                                      '• یہ پالیسی وضاحت کرتی ہے کہ ہم آپ کا ذاتی ڈیٹا کیسے جمع، استعمال اور محفوظ کرتے ہیں۔ آپ کے ای میل اور گنتی کے پوائنٹس صرف انتظامی اور سروس کے مقاصد کے لیے استعمال ہوتے ہیں.',
                                                  color: AppColors.blackLight,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Card(
                                          elevation: 5,
                                          color: AppColors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                TitleText(
                                                  text: 'استعمال کی شرائط',
                                                  color: AppColors.black,
                                                ),
                                                SizedBox(height: 10),
                                                SubtitleText(
                                                  text:
                                                      'ایپ استعمال کرنے سے پہلے آپ کو صارف کے تمام حقوق اور ذمہ داریوں کو قبول کرنا ہوگا۔ دھوکہ دہی کی صورت میں اکاؤنٹ بلاک کر دیا جائے گا۔',
                                                  color: AppColors.blackLight,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 20),

                                  ///Referral Program
                                  SettingProfileContainer(
                                    text: 'مدد اور تعاون',
                                    icon: Icons.support_agent,
                                    dropDownContent: Card(
                                      elevation: 6,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      color: AppColors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(height: 10),

                                            /// آئیکن سرکل
                                            Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.greenLight,
                                              ),
                                              padding: EdgeInsets.all(14),
                                              child: Icon(
                                                Icons.support_agent,
                                                color: AppColors.green,
                                                size: 26,
                                              ),
                                            ),

                                            SizedBox(height: 12),

                                            Text(
                                              'ہم سے رابطہ کریں',
                                              style: TextStyle(
                                                color: AppColors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),

                                            SizedBox(height: 8),

                                            Text(
                                              'اگر آپ کو کسی قسم کا مسئلہ درپیش ہے یا آپ کوئی سوال پوچھنا چاہتے ہیں تو براہِ کرم واٹس ایپ کے ذریعے ہم سے رابطہ کریں۔',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: AppColors.grey,
                                                fontSize: 13,
                                              ),
                                            ),

                                            SizedBox(height: 20),

                                            /// رابطہ کارڈ
                                            Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.symmetric(vertical: 15),
                                              decoration: BoxDecoration(
                                                color: AppColors.greyLight,
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'عبداللہ اقبال',
                                                    style: TextStyle(
                                                      color: AppColors.black,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    '+92 318 2258363',
                                                    style: TextStyle(
                                                      color: AppColors.grey,
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            SizedBox(height: 20),

                                            /// واٹس ایپ بٹن
                                            SizedBox(
                                              width: double.infinity,
                                              height: 50,
                                              child: ElevatedButton.icon(
                                                onPressed: controller.openWhatsApp,
                                                icon: Icon(Icons.chat, color: Colors.white),
                                                label: Text(
                                                  'واٹس ایپ پر پیغام بھیجیں',
                                                  style: TextStyle(fontSize: 15,color: AppColors.white),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: AppColors.green,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(15),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 10),

                          /// Payment history
                          Obx(() {
                            List<Widget> requestWidgets = [];

                            requestWidgets.add(
                              TitleText(
                                text: 'ادائیگی کی تاریخ',
                                color: AppColors.black,
                              ),
                            );
                            requestWidgets.add(SizedBox(height: 10));

                            if (controller.payoutRequests.isEmpty) {
                              requestWidgets.add(
                                Center(
                                  child: SubtitleText(
                                    text: 'کوئی درخواست نہیں ہے',
                                    color: AppColors.blackLight,
                                  ),
                                ),
                              );
                            } else {
                              requestWidgets.addAll(
                                controller.payoutRequests.map((request) {
                                  return SizedBox(
                                    width: double.infinity,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      color: AppColors.greyLight,
                                      margin: EdgeInsets.symmetric(vertical: 8),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 20,
                                          horizontal: 20,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // Status with color

                                                Row(
                                                  children: [

                                                    IconButton(onPressed: (){
                                                      controller.deletePayoutRequest(request['id']);
                                                    }, icon: Icon(Icons.delete,color: AppColors.red,)),

                                                    Builder(
                                                      builder: (context) {
                                                        String statusText;
                                                        Color statusColor;

                                                        switch ((request['status'] ??
                                                            '')
                                                            .toString()
                                                            .toLowerCase()) {
                                                          case 'pending':
                                                            statusText =
                                                            'زرا التواء';
                                                            statusColor =
                                                                Colors.orange;
                                                            break;
                                                          case 'accepted':
                                                            statusText = 'قبول شدہ';
                                                            statusColor =
                                                                Colors.green;
                                                            break;
                                                          case 'rejected':
                                                            statusText =
                                                            'نامنظور شدہ';
                                                            statusColor =
                                                                Colors.red;
                                                            break;
                                                          default:
                                                            statusText = 'نامعلوم';
                                                            statusColor = AppColors
                                                                .blackLight;
                                                        }

                                                        return TitleText(
                                                          text: statusText,
                                                          color: statusColor,
                                                        );
                                                      },
                                                    ),



                                                    // Points
                                                  ],
                                                ),
                                                TitleText(
                                                  text:
                                                      ' ${request['pointsAtRequest'] ?? 'نامعلوم'}  پوائنٹس',
                                                  color: AppColors.black,
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: 10),
                                            SubtitleText(
                                              text:
                                                  'تاریخ: ${request['requestDate'] != null ? (request['requestDate'] as Timestamp).toDate().toLocal().toString().split(' ')[0] : 'نامعلوم'}',
                                              color: AppColors.blackLight,
                                            ),

                                            if (request['paymentProofUrl'] !=
                                                    null &&
                                                request['paymentProofUrl']
                                                    .toString()
                                                    .isNotEmpty)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 10,
                                                ),
                                                child: Column(
                                                  children: [
                                                    SizedBox(height: 5),
                                                    TitleText(
                                                      text: 'ادائیگی کا ثبوت',
                                                      color: AppColors.black,
                                                    ),
                                                    SizedBox(height: 5),

                                                    Image.network(
                                                      request['paymentProofUrl'],
                                                      height: 120,
                                                      width: double.infinity,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            }

                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              color: AppColors.white,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 20,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: requestWidgets,
                                ),
                              ),
                            );
                          }),

                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
