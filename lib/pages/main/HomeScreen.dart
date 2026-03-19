import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';

import '../../components/AppColors.dart';
import '../../controller/main/HomeScreenController.dart';
import '../../widgets/HomeGridList.dart';
import '../../widgets/HomeListContainer.dart';
import '../../widgets/HomeProgressBar.dart';
import '../../widgets/Text.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeScreenController controller = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldLight,
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
                padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      /// Top Information Containers
                      HomeListContainer(
                        gradientColor1: const Color(0xFFF6EECF),
                        gradientColor2: const Color(0xFFF8E7AF),
                        title: 'ہر صحیح درود = 1 پوائنٹ = 0.1 روپے',
                        subtitle:
                            'آپ کا تمام درود پاک کی تعداد کے مطابق آپ کو انعام ملتے رہیں گے',
                      ),
                      const SizedBox(height: 15),
                      HomeListContainer(
                        gradientColor1: const Color(0xFFDBF2F6),
                        gradientColor2: const Color(0xFFAFF8F6),
                        title: 'ہر مہینے کی 29 تاریخ کو انعامات کا اعلان',
                        subtitle:
                            'ہر مہینے کی 29 تاریخ کو فاتحین کا اعلان کیا جاتا ہے',
                      ),
                      const SizedBox(height: 15),
                      HomeListContainer(
                        gradientColor1: const Color(0xFFF8E4E0),
                        gradientColor2: const Color(0xFFF8CFC8),
                        title: 'پہلا انعام 5000 روپے نقد',
                        subtitle:
                            'مہینہ مقابلے میں پہلے نمبر پر آنے والے کو 5000 روپے نقد انعام دیا جائے گا',
                      ),
                      const SizedBox(height: 20),

                      Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.31,
                        ),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.5,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: controller.pages.length,
                          itemBuilder: (context, index) {
                            var item = controller.pages[index];
                            return Obx(() {
                              var value = item['value'];
                              if (value is RxInt || value is RxDouble) {
                                value = value.value;
                              }
                              return GridItem(
                                icon: item['icon'] ?? '',
                                text: item['text'] ?? '',
                                subtitle: item['value'] is RxDouble
                                    ? (item['value'] as RxDouble).value
                                    .toStringAsFixed(2)
                                    : item['value'].toString(),
                              );
                            });
                          },
                        ),
                      ),

                      /// Progress Section
                      Obx(
                        () => HomeProgressBar(
                          text: 'روزانہ کا مقصد',
                          count: controller.todayCount.value,
                          goal: controller.dailyGoal.value,
                        ),
                      ),
                      SizedBox(height: 10),
                      Obx(
                        () => HomeProgressBar(
                          text: 'ماہانہ کا مقصد',
                          count: controller.monthCount.value,
                          goal: controller.monthlyGoal.value,
                        ),
                      ),

                      SizedBox(height: 20),

                      ///Darood Button
                      GestureDetector(
                        onTap: () {
                          controller.reciteDurood();
                        },
                        child: Obx(
                          () => !controller.buttonPressed.value
                              ? Container(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.17,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(80),
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.greenLight,
                                        AppColors.green,
                                      ],
                                    ),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TitleText(
                                          text: 'درود',
                                          color: AppColors.white,
                                        ),
                                        TitleText(
                                          text: controller.todayCount.value
                                              .toString(),
                                          color: AppColors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.17,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(80),
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.grey,
                                        AppColors.grey,
                                      ],
                                    ),
                                  ),
                                  child: Center(
                                    child: Lottie.asset(
                                      'assets/lottie/loading.json',
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ],
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
