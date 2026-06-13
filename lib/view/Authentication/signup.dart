// ignore_for_file: avoid_print

import 'dart:ui';
import 'package:firstproject/customs/customwidgets.dart';
import 'package:firstproject/viewmodel/Authenticationctl/signupcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Signupcontroller());

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
                460, // Sized perfectly for desktop console proportion systems
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
                          'Universal Billing Service',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF94A3B8), // Sleek Slate text
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // --- INPUT FIELDS MODULE ---
                        Form(
                          key: controller.globalkey,
                          child: Column(
                            children: [
                              buildTextField(
                                hint: 'Username',
                                controller: controller.usernamecontroller,
                              ),
                              const SizedBox(height: 18),
                              buildTextField(
                                hint: 'Email Address',
                                controller: controller.emailcontroller,
                              ),
                              const SizedBox(height: 18),
                              buildTextField(
                                hint: 'Password',
                                isPassword: true,
                                controller: controller.passwordcontroller,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // --- SIGN UP ACTION BUTTON WITH OVERLAY DISPATCH ---
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              if (controller.globalkey.currentState
                                      ?.validate() ??
                                  false) {
                                Get.showOverlay(
                                  asyncFunction: () async {
                                    try {
                                      await controller.signup(
                                        controller.usernamecontroller.text
                                            .trim(),
                                        controller.emailcontroller.text.trim(),
                                        controller.passwordcontroller.text
                                            .trim(),
                                      );
                                    } catch (e) {
                                      // Graceful snackbar error reporting window
                                      Get.snackbar(
                                        'Registration Error',
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
                              'Create System Account',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // --- SIGN IN ROUTING BLOCK ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account?',
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 4),
                            TextButton(
                              onPressed: () => Get.offAllNamed(
                                '/login',
                              ), // Clear the routing stack history upon reversal
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF2DD4BF),
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Sign In',
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
