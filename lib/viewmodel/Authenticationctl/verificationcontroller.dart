// ignore_for_file: avoid_print

import 'package:firstproject/model/authservices.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Verificationcontroller extends GetxController {
  // Your Appwrite Account instance
  final RxBool isverified = false.obs;
  final RxBool isloading = false.obs;
  @override
  void onInit() {
    super.onInit();
    _handleRedirectParams();
  }

  void _handleRedirectParams() async {
    // 1. Retrieve the parameters from GetX
    isloading.value = true;
    final uri = Uri.base; // full current URL
    final userId = uri.queryParameters['userId'];
    final secret = uri.queryParameters['secret'];
    print(userId);
    print(secret);
    if (userId != null && secret != null) {
      try {
        await Get.find<AuthServices>().updateemailverification(userId, secret);
        isverified.value = true;

        // Success! Navigate away
      } catch (e) {
        isverified.value = false;
        Get.snackbar(
          'Error',
          e.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isloading.value = false;
      }
    }
  }
}
