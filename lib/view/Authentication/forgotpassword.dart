// ignore_for_file: avoid_print

import 'dart:ui';
import 'package:firstproject/customs/customwidgets.dart';
import 'package:firstproject/viewmodel/Authenticationctl/forgotpasswordctl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Forgotpassword extends StatelessWidget {
  const Forgotpassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Forgotpasswordctl());
    // Create a local fallback key if one isn't defined inside your forgot password controller
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: const Color(0xFF0B1517), // Match landing canvas base
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.6, 0.7),
            radius: 1.3,
            colors: [
              Color(0x261E4D55), // Alpha hex opacity spotlight bloom
              Color(0xFF0B1517),
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: Center(
          child: SizedBox(
            width:
                460, // Sized perfectly for desktop console proportion consistency
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: const Color(
                        0x0DFFFFFF,
                      ), // 0.05 clean white glass transparency
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(
                          0x1AFFFFFF,
                        ), // 0.1 border highlight line
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // --- BRAND IDENTITY LOGO MODULE ---
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F262A),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF1E4D55),
                              width: 1.5,
                            ),
                          ),
                          child: const Text(
                            'UBS',
                            style: TextStyle(
                              color: Color(0xFF2DD4BF), // Unified theme teal
                              fontSize: 32,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Account Recovery',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF94A3B8), // Sleek Slate text
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Enter your email to receive password reset instructions',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // --- INPUT FIELDS MODULE ---
                        Form(
                          key: formKey,
                          child: buildTextField(
                            hint: 'Email Address',
                            controller: controller.email,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // --- ACTION BUTTON WITH OVERLAY DISPATCH ---
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState?.validate() ?? false) {
                                Get.showOverlay(
                                  asyncFunction: () async {
                                    try {
                                      await controller.enter(
                                        controller.email.text.trim(),
                                      );
                                    } catch (e) {
                                      // Graceful snackbar error reporting window
                                      Get.snackbar(
                                        'Recovery Error',
                                        e.toString().replaceAll(
                                          'Exception: ',
                                          '',
                                        ),
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: const Color(
                                          0xFF7F1D1D,
                                        ), // Dark operational red
                                        colorText: Colors.white,
                                        borderRadius: 12,
                                        margin: const EdgeInsets.all(16),
                                        duration: const Duration(seconds: 4),
                                      );
                                    }
                                  },
                                  loadingWidget: Center(
                                    child: Lottie.asset(
                                      'assets/animations/loading.json',
                                      width: 120,
                                      height: 120,
                                    ),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                0xFF2DD4BF,
                              ), // Bright functional teal interaction layer
                              foregroundColor: const Color(
                                0xFF0B1517,
                              ), // Rich high-contrast dark text
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Send Recovery Link',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // --- BACK TO LOGIN LINK ---
                        TextButton(
                          onPressed: () =>
                              Get.back(), // Navigates back down the routing stack gracefully
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF2DD4BF),
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Back to Sign In',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
