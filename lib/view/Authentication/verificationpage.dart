import 'dart:ui';

import 'package:firstproject/customs/uicustoms.dart';
import 'package:firstproject/viewmodel/Authenticationctl/verificationcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Verificationpage extends StatelessWidget {
  const Verificationpage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Verificationcontroller());
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: Appcolors().gradient1),
        child: Center(
          child: SizedBox(
            width: 500,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: 500,
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white10, width: 1.5),
                ),
                child: Column(
                  children: [
                    Text(
                      'Verification',
                      style: TextStyle(color: Colors.white, fontSize: 50),
                    ),
                    SizedBox(height: 150),
                    Obx(() {
                      if (controller.isloading.value) {
                        return CircularProgressIndicator();
                      }
                      return controller.isverified.value
                          ? Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white60,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(
                                        Icons.verified,
                                        color: Colors.green,
                                        size: 55,
                                      ),
                                      Text(
                                        "Verified",
                                        style: TextStyle(
                                          fontSize: 35,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 35),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 80,
                                      ),
                                      backgroundColor: Appcolors().buttoncolor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 0,
                                    ),
                                    onPressed: () {
                                      Get.offAllNamed('/');
                                    },
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white60,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                    size: 65,
                                  ),
                                  Text(
                                    'Not verified',
                                    style: TextStyle(
                                      fontSize: 35,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            );
                    }),
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
