import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/authservices.dart';

class ResetPasswordController extends GetxController {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();
  final RxString error = ''.obs;
  final isloading = false.obs;
  final passwordupdated = false.obs;
  final GlobalKey globalKey = GlobalKey<FormState>();
  void resetPassword(String password) async {
    // 1. Grab the tokens Appwrite put in the URL

    final uri = Uri.base; // full current URL
    final userId = uri.queryParameters['userId'];
    final secret = uri.queryParameters['secret'];

    if (userId == null || secret == null) {
      Get.snackbar("Error", "Invalid or expired reset link.");
      return;
    }

    try {
      // 2. Update the password using the secret
      isloading.value = true;
      await Get.find<AuthServices>().account.updateRecovery(
        userId: userId,
        secret: secret,
        password: password,
      );
      passwordupdated.value = true;
      Get.offAllNamed('/login'); // Password changed!
      Get.snackbar(
        "Success",
        "Password updated successfully.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
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
