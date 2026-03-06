// ignore_for_file: avoid_print

import 'dart:ui';
import 'package:firstproject/customs/customwidgets.dart';
import 'package:firstproject/customs/uicustoms.dart';

import 'package:firstproject/viewmodel/signupcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Signupcontroller());
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
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
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
                        // Email Field
                        Form(
                          key: controller.globalkey,
                          child: Column(
                            children: [
                              buildTextField(
                                hint: 'username',
                                controller: controller.usernamecontroller,
                              ),
                              const SizedBox(height: 20),
                              // Password Field
                              buildTextField(
                                hint: 'Email',

                                controller: controller.emailcontroller,
                              ),
                              const SizedBox(height: 20),
                              // Password Field
                              buildTextField(
                                hint: 'Password',
                                isPassword: true,
                                controller: controller.passwordcontroller,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),
                        // Sign In Button
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.globalkey.currentState!.validate();
                              controller.signup(
                                controller.usernamecontroller.text.trim(),
                                controller.emailcontroller.text.trim(),
                                controller.passwordcontroller.text.trim(),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Appcolors().buttoncolor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Already have an account?',
                              style: TextStyle(color: Colors.white),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.offAllNamed('/');
                              },
                              child: Text(
                                'signin',
                                style: TextStyle(color: Colors.white),
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
