// ignore_for_file: avoid_print

import 'dart:ui';
import 'package:firstproject/customs/customwidgets.dart';
import 'package:firstproject/customs/uicustoms.dart';
import 'package:firstproject/viewmodel/Authenticationctl/resetpasswordctl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Resetpassword extends StatelessWidget {
  const Resetpassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ResetPasswordController());
    return Scaffold(
      body: Container(
        // Background Gradient
        decoration: BoxDecoration(gradient: Appcolors().gradient1),
        child: Center(
          child: SizedBox(
            width: 500,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  // This creates the "frosted" blur effect
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(151, 255, 255, 255),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: const Color.fromARGB(131, 255, 255, 255),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        // UBS Logo Circle
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: const Text(
                              'UBS',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Brand Name
                        const Text(
                          'Universal Billing Service',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Obx(() {
                          if (controller.isloading.value) {
                            return CircularProgressIndicator();
                          }
                          if (controller.passwordupdated.value) {
                            return Row(
                              children: [
                                Icon(
                                  Icons.verified,
                                  color: Colors.green,
                                  size: 50,
                                ),
                                Text(
                                  'Password updated',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 50,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Form(
                              key: controller.globalKey,
                              child: Column(
                                children: [
                                  const SizedBox(height: 20),
                                  // Password Field
                                  buildTextField(
                                    hint: 'Enter New Password',
                                    isPassword: false,
                                    controller:
                                        controller.newPasswordController,
                                  ),
                                  SizedBox(height: 20),
                                  buildTextField(
                                    hint: 'confirm New Password',
                                    isPassword: false,
                                    controller:
                                        controller.confirmpasswordController,
                                  ),
                                  SizedBox(height: 25),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 55,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (controller
                                                .newPasswordController
                                                .text !=
                                            controller
                                                .confirmpasswordController
                                                .text) {
                                          controller.error.value =
                                              'Password is not matched';
                                          return;
                                        }
                                        controller.resetPassword(
                                          controller
                                              .confirmpasswordController
                                              .text
                                              .trim(),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Appcolors().buttoncolor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: const Text(
                                        'Enter',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    controller.error.value,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        }),

                        // Sign In Button
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
