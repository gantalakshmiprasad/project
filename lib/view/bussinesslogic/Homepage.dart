// ignore_for_file: file_names

import 'package:firstproject/view/bussinesslogic/desktop.dart';
import 'package:firstproject/view/bussinesslogic/mobile.dart';
import 'package:firstproject/view/bussinesslogic/tab.dart';
import 'package:firstproject/viewmodel/bussinesslogicctl/Homepagecontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Homepagecontroller());

    return Scaffold(
      backgroundColor: const Color(0xFF0B1517),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double adaptiveWidth = constraints.maxWidth;

          // BUG FIX: Added unified inclusive equality checks to prevent component flickering or layout dead zones
          if (adaptiveWidth <= 640) {
            return Mobile(controller: controller);
          } else if (adaptiveWidth > 640 && adaptiveWidth <= 1024) {
            return Tablet(controller: controller);
          } else {
            return Desktop(controller: controller);
          }
        },
      ),
    );
  }
}
