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
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(156, 124, 53, 5),
              const Color.fromARGB(84, 241, 69, 21),
            ],
            begin: AlignmentGeometry.topCenter,
            end: AlignmentGeometry.bottomCenter,
          ),
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Center(
              child: Container(
                width: 900,
                height: 550,
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(23, 255, 255, 255),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: const Color.fromARGB(226, 255, 255, 255),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Form(
                      key: controller.formkey,
                      child: Column(
                        children: [
                          buildTextField(
                            hint: 'Enter your bussiness title',
                            controller: controller.bussiness,
                          ),
                          SizedBox(height: 15),
                          buildTextField(
                            hint: 'Enter your address',
                            controller: controller.address,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // --- ICON 1 ---
                        Obx(() {
                          bool isOne = controller.selectedIconIndex.value == 1;
                          return Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Column(
                                children: [
                                  IconButton(
                                    iconSize: isOne ? 110 : 100,
                                    color: isOne ? Colors.white : Colors.black,
                                    style: IconButton.styleFrom(
                                      backgroundColor: isOne
                                          ? Colors.blue
                                          : Colors.grey[200],
                                      // Modern shadow for the selected icon
                                      elevation: isOne ? 10 : 0,
                                    ),
                                    onPressed: () =>
                                        controller.selectedIconIndex.value = 1,
                                    icon: Icon(
                                      isOne
                                          ? Icons.local_pharmacy
                                          : Icons.local_pharmacy_outlined,
                                    ),
                                  ),
                                  const Text(
                                    "Pharmacy",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              if (isOne)
                                Icon(
                                  Icons.verified,
                                  color: Colors.green,
                                  size: 25,
                                ),
                            ],
                          );
                        }),

                        const SizedBox(width: 40),

                        // --- ICON 2 ---
                        Obx(() {
                          bool isTwo = controller.selectedIconIndex.value == 2;
                          return Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Column(
                                children: [
                                  IconButton(
                                    iconSize: isTwo ? 110 : 100,
                                    color: isTwo ? Colors.white : Colors.black,
                                    style: IconButton.styleFrom(
                                      backgroundColor: isTwo
                                          ? Colors.blue
                                          : Colors.grey[200],
                                      elevation: isTwo ? 10 : 0,
                                    ),
                                    onPressed: () =>
                                        controller.selectedIconIndex.value = 2,
                                    icon: Icon(
                                      isTwo
                                          ? Icons.restaurant
                                          : Icons.restaurant_menu_outlined,
                                    ),
                                  ),
                                  const Text(
                                    "Restaurant",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              if (isTwo)
                                Icon(Icons.verified, color: Colors.green),
                            ],
                          );
                        }),
                      ],
                    ),
                    SizedBox(height: 85),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(15),
                        ),
                      ),
                      onPressed: () {
                        controller.formkey.currentState!.validate();
                        final String title;
                        if (controller.selectedIconIndex.value == 2) {
                          title = 'food';
                        } else {
                          title = 'pharmacy';
                        }
                        controller.formsubmit(
                          controller.address.text.trim(),
                          controller.bussiness.text.trim(),
                          title,
                        );
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white, fontSize: 25),
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
}
