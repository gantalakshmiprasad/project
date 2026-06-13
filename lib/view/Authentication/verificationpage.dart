// ignore_for_file: avoid_print

import 'dart:ui';
import 'package:firstproject/viewmodel/Authenticationctl/verificationcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Verificationpage extends StatelessWidget {
  const Verificationpage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Verificationcontroller());

    // Consolidated Console Design Constants
    const Color canvasDark = Color(0xFF0B1517);
    const Color tealAccent = Color(0xFF2DD4BF);
    const Color slateText = Color(0xFF94A3B8);
    const Color mutedText = Color(0xFF64748B);
    const Color errorRed = Color(0xFFFB7185);

    return Scaffold(
      backgroundColor: canvasDark,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.6, 0.7),
            radius: 1.3,
            colors: [
              Color(0x261E4D55), // Hex opacity bloom layer
              canvasDark,
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: Center(
          child: SizedBox(
            width: 460, // Sized perfectly for desktop console grid consistency
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
                      ), // 0.05 glass opacity transparency
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(
                          0x1AFFFFFF,
                        ), // 0.1 layout frame border line
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
                              color: tealAccent,
                              fontSize: 32,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Security Console',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: slateText,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Verifying application credentials...',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: mutedText, fontSize: 14),
                        ),
                        const SizedBox(height: 36),

                        // --- REACTIVE STATUS STATE STREAM PANEL ---
                        Obx(() {
                          if (controller.isloading.value) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 32),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  tealAccent,
                                ),
                                strokeWidth: 3,
                              ),
                            );
                          }

                          return controller.isverified.value
                              ? _buildSuccessPanel(
                                  context,
                                  tealAccent,
                                  canvasDark,
                                )
                              : _buildFailurePanel(errorRed);
                        }),
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

  // Dark Dashboard Success Layout Node
  Widget _buildSuccessPanel(
    BuildContext context,
    Color tealAccent,
    Color canvasDark,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0x102DD4BF), // Clean subtle translucent teal layer
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tealAccent.withOpacity(0.25), width: 1.2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified_user_rounded, color: tealAccent, size: 28),
              const SizedBox(width: 12),
              Text(
                "Verified Successfully",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: tealAccent,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: tealAccent,
                foregroundColor: canvasDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              onPressed: () {
                Get.offAllNamed('/');
              },
              child: const Text(
                'Proceed to Login',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Dark Dashboard Failure Layout Node
  Widget _buildFailurePanel(Color errorRed) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0x10FB7185), // Clean subtle translucent red layer
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: errorRed.withOpacity(0.25), width: 1.2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.gpp_bad_rounded, color: errorRed, size: 28),
          const SizedBox(width: 12),
          Text(
            'Verification Failed',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: errorRed,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
