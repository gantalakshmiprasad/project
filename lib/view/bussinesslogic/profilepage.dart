import 'dart:ui';
import 'package:firstproject/customs/customwidgets.dart';
import 'package:firstproject/viewmodel/bussinesslogicctl/profilepagecontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Profilepage extends StatelessWidget {
  const Profilepage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Profilepagecontroller());
    return Scaffold(
      backgroundColor: const Color(0xFF0B1517),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.5, -0.6),
            radius: 1.3,
            colors: [Color(0x1A2DD4BF), Color(0xFF0B1517)],
          ),
        ),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                width: 850,
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: const Color(0x0DFFFFFF),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0x1AFFFFFF),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Form(
                      key: controller.formkey,
                      child: Column(
                        children: [
                          buildTextField(
                            hint: 'Business Terminal Title',
                            controller: controller.bussiness,
                          ),
                          const SizedBox(height: 18),
                          buildTextField(
                            hint: 'Physical Node Location Address',
                            controller: controller.address,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildModuleSelector(
                          index: 1,
                          label: "Pharmacy System",
                          activeIcon: Icons.local_pharmacy,
                          inactiveIcon: Icons.local_pharmacy_outlined,
                          controller: controller,
                        ),
                        const SizedBox(width: 32),
                        _buildModuleSelector(
                          index: 2,
                          label: "Restaurant POS",
                          activeIcon: Icons.restaurant,
                          inactiveIcon: Icons.restaurant_menu_outlined,
                          controller: controller,
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    SizedBox(
                      width: 220,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2DD4BF),
                          foregroundColor: const Color(0xFF0B1517),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          // BUG FIX: Secure guard execution to block operations if forms are empty
                          if (controller.formkey.currentState?.validate() ??
                              false) {
                            final String title =
                                (controller.selectedIconIndex.value == 2)
                                ? 'food'
                                : 'pharmacy';
                            controller.formsubmit(
                              controller.address.text.trim(),
                              controller.bussiness.text.trim(),
                              title,
                            );
                          }
                        },
                        child: const Text(
                          'Save Configuration',
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
    );
  }

  Widget _buildModuleSelector({
    required int index,
    required String label,
    required IconData activeIcon,
    required IconData inactiveIcon,
    required Profilepagecontroller controller,
  }) {
    return Obx(() {
      bool isSelected = controller.selectedIconIndex.value == index;
      return Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            width: 160,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF0F262A)
                  : const Color(0x05FFFFFF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF2DD4BF)
                    : const Color(0x1AFFFFFF),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                IconButton(
                  iconSize: 54,
                  color: isSelected
                      ? const Color(0xFF2DD4BF)
                      : const Color(0xFF64748B),
                  onPressed: () => controller.selectedIconIndex.value = index,
                  icon: Icon(isSelected ? activeIcon : inactiveIcon),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : const Color(0xFF64748B),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.verified, color: Color(0xFF2DD4BF), size: 22),
            ),
        ],
      );
    });
  }
}
