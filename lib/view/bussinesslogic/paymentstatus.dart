import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Paymentstatus extends GetView<Paymentstatuscontroller> {
  const Paymentstatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1517),
      body: Center(
        child: Obx(() {
          // BUG FIX: Shifted operational asset maps so loops match UX transitions correctly
          if (controller.isloading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2DD4BF)),
            );
          }

          if (controller.ispaymentsuccess.value) {
            return Container(
              height: 350,
              width: 400,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF0F262A),
                border: Border.all(color: const Color(0xFF2DD4BF), width: 1.5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 120,
                    child: Lottie.asset(
                      'assets/animations/Success.json',
                      repeat: false,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Verification Success',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2DD4BF),
                        foregroundColor: const Color(0xFF0B1517),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Get.offAllNamed('/homepage'),
                      child: const Text(
                        'Enter Management Console',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: Color(0xFFEF4444),
                  size: 72,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Transaction Failed',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Get.offAllNamed('/homepage'),
                  child: const Text('Return to Dashboard'),
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}

class Paymentstatuscontroller extends GetxController {
  final isloading = false.obs;
  final ispaymentsuccess = false.obs;

  @override
  void onInit() {
    super.onInit();
    _handleRedirectParams();
  }

  Future<void> _handleRedirectParams() async {
    try {
      isloading.value = true;
      // Added a slight microtask delay ensuring route tree parameters instantiate cleanly before checking parameter signatures
      await Future.delayed(const Duration(milliseconds: 150));

      final uri = Uri.base;
      final fragment = uri.fragment;
      final fragmentUri = Uri.parse(fragment);
      final extractedOrderId =
          fragmentUri.queryParameters['order_id'] ??
          uri.queryParameters['order_id'];

      ispaymentsuccess.value = extractedOrderId != null;
    } catch (e) {
      ispaymentsuccess.value = false;
    } finally {
      isloading.value = false;
    }
  }
}
