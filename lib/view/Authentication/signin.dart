// ignore_for_file: avoid_print

import 'dart:ui';
import 'package:firstproject/customs/customwidgets.dart';
import 'package:firstproject/viewmodel/Authenticationctl/signincontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Signincontroller());

    return Scaffold(
      backgroundColor: const Color(0xFF0B1517), // Match landing canvas base
      body: Container(
        width: double.infinity - 5,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.6, 0.7),
            radius: 1.3,
            colors: [
              Color(
                0x261E4D55,
              ), // Alpha hex replacement for opacity spotlight bloom
              Color(0xFF0B1517),
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: Center(
          child: SizedBox(
            width:
                430, // Sized slightly narrower for perfect desktop proportions
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
                        // --- BRAND IDENTITY LOGO REFACTOR ---
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
                            'Billify',
                            style: TextStyle(
                              color: Color(0xFF2DD4BF), // Unified theme teal
                              fontSize: 32,

                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Universal Billing Service',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF94A3B8), // Sleek Slate text
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 36),

                        // --- INPUT FIELDS MODULE ---
                        Form(
                          key: controller.globalkey,
                          child: Column(
                            children: [
                              buildTextField(
                                hint: 'Email Address',

                                controller: controller.emailcontroller,
                              ),
                              const SizedBox(height: 18),
                              Obx(() {
                                final showpassword =
                                    controller.showpassword.value;
                                return buildTextField(
                                  hint: 'Password',
                                  isPassword: showpassword,

                                  onSuffixPressed: () {
                                    controller.showpassword.value =
                                        !controller.showpassword.value;
                                  },
                                  passwordVisible: true,
                                  controller: controller.passwordcontroller,
                                );
                              }),
                            ],
                          ),
                        ),

                        // --- FORGOT PASSWORD NAVIGATION ---
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 24),
                            child: TextButton(
                              onPressed: () => Get.toNamed(
                                '/forgotpassword',
                              ), // Use .toNamed to prevent clearing routing stack memory
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF94A3B8),
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Forgot password?',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // --- REFACTORED SIGN IN ACTION BUTTON ---
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              // BUG FIX 1: Run form validator logic to halt empty fields before dispatching loaders
                              if (controller.globalkey.currentState
                                      ?.validate() ??
                                  false) {
                                Get.showOverlay(
                                  asyncFunction: () async {
                                    try {
                                      await controller.signin(
                                        controller.emailcontroller.text.trim(),
                                        controller.passwordcontroller.text
                                            .trim(),
                                      );
                                    } catch (e) {
                                      // BUG FIX 2: Pop up a graceful UI snackbar warning instead of failing silently on screen
                                      Get.snackbar(
                                        'Authentication Error',
                                        e.toString().replaceAll(
                                          'Exception: ',
                                          '',
                                        ),
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: const Color(
                                          0xFF7F1D1D,
                                        ), // Dark functional red
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
                              'Sign In to System',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // --- SIGN UP ROUTING BLOCK ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'New to the console?',
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 14,
                              ),
                            ),

                            TextButton(
                              onPressed: () => Get.toNamed('/signup'),
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF2DD4BF),
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Create account',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
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
