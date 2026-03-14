import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../components/AppColors.dart';
import '../../controller/main/NameController.dart';
import '../../widgets/Text.dart';

class NamesScreen extends StatelessWidget {
  final String? type; // 'allah' or 'muhammad'
  NamesScreen({super.key, this.type});

  final NamesController controller = Get.put(NamesController());

  @override
  Widget build(BuildContext context) {
    final String argType = Get.arguments?['type'] ?? type ?? 'allah';

    // Load names once after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadNames(argType);
    });

    return Scaffold(
      backgroundColor: AppColors.greenForeground,
      appBar: AppBar(
        title: Obx(
              () => Text(
            controller.title.value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: AppColors.green,
      ),
      body: Obx(() {
        if (controller.namesList.isEmpty) {
          return Center(child: Lottie.asset('assets/lottie/loading.json',width: 200,height: 200));
        }

        // Wrap GridView with Directionality to reverse horizontal order
        return Directionality(
          textDirection: TextDirection.rtl, // <-- Important
          child: GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 items per row
              crossAxisSpacing: 7,
              mainAxisSpacing: 7,
              childAspectRatio: 3 / 2,
            ),
            itemCount: controller.namesList.length,
            itemBuilder: (context, index) {
              final item = controller.namesList[index];

              return Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center, // Right aligned
                    children: [
                      TitleText(
                        text: item['name'] ?? '',
                        color: Colors.black,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item['meaning'] ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl, // RTL for Urdu/Arabic
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}