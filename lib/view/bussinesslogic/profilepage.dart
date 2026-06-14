// ignore_for_file: avoid_print

import 'dart:ui';
import 'package:firstproject/customs/customwidgets.dart';
import 'package:firstproject/viewmodel/bussinesslogicctl/profilepagecontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Profilepage extends StatelessWidget {
  const Profilepage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Profilepagecontroller());

    // Consolidated Design Palette Constants
    const Color canvasDark = Color(0xFF0B1517);
    const Color tealAccent = Color(0xFF2DD4BF);

    return Scaffold(
      backgroundColor: canvasDark,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.5, -0.6),
            radius: 1.3,
            colors: [
              Color(0x1A2DD4BF), // Hex opacity spotlight bloom layer
              canvasDark,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: 720, // Clean, proportional mid-sized panel layout
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: const Color(
                        0x0DFFFFFF,
                      ), // 0.05 glass opacity transparency
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(
                          0x1AFFFFFF,
                        ), // 0.1 border highlight wireframe
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
                          'Profile setup',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,

                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Set up your environment',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 36),

                        // --- INPUT FIELDS MODULE ---
                        Form(
                          key: controller.formkey,
                          child: Column(
                            children: [
                              buildTextField(
                                hint: 'Business Title',
                                controller: controller.bussiness,
                              ),
                              const SizedBox(height: 20),
                              buildTextField(
                                hint: 'Location Address',
                                controller: controller.address,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // --- SYSTEM MODE SELECTOR COMPONENT ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: _buildModuleSelector(
                                index: 1,
                                label: "Pharmacy System",
                                activeIcon: Icons.local_pharmacy,
                                inactiveIcon: Icons.local_pharmacy_outlined,
                                controller: controller,
                                tealAccent: tealAccent,
                                mutedText: const Color.fromARGB(
                                  255,
                                  246,
                                  247,
                                  249,
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: _buildModuleSelector(
                                index: 2,
                                label: "Restaurant POS",
                                activeIcon: Icons.restaurant,
                                inactiveIcon: Icons.restaurant_menu_outlined,
                                controller: controller,
                                tealAccent: tealAccent,
                                mutedText: const Color.fromARGB(
                                  255,
                                  244,
                                  246,
                                  250,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),

                        // --- ACTION DISPATCH SUBMIT BUTTON ---
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: tealAccent,
                              foregroundColor: canvasDark,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              if (controller.formkey.currentState?.validate() ??
                                  false) {
                                final String title =
                                    (controller.selectedIconIndex.value == 2)
                                    ? 'food'
                                    : 'pharmacy';

                                Get.showOverlay(
                                  asyncFunction: () async {
                                    try {
                                      await controller.formsubmit(
                                        controller.address.text.trim(),
                                        controller.bussiness.text.trim(),
                                        title,
                                      );
                                    } catch (e) {
                                      // Unified error handling snackbar popup tracking
                                      Get.snackbar(
                                        'Configuration Error',
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
                            child: const Text(
                              'Save Console Configuration',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
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

  // Refactored Private Module Selection Grid Item
  Widget _buildModuleSelector({
    required int index,
    required String label,
    required IconData activeIcon,
    required IconData inactiveIcon,
    required Profilepagecontroller controller,
    required Color tealAccent,
    required Color mutedText,
  }) {
    return Obx(() {
      bool isSelected = controller.selectedIconIndex.value == index;
      return Stack(
        alignment: Alignment.topRight,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF0F262A)
                  : const Color(0x05FFFFFF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? tealAccent : const Color(0x1AFFFFFF),
                width: 1.5,
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () => controller.selectedIconIndex.value = index,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSelected ? activeIcon : inactiveIcon,
                    size: 48,
                    color: isSelected ? tealAccent : mutedText,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : mutedText,
                      fontSize: 14,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isSelected)
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Icon(Icons.verified_rounded, size: 20),
            ),
        ],
      );
    });
  }
}
