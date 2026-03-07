import 'package:firstproject/model/authservices.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Signupcontroller extends GetxController {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController usernamecontroller = TextEditingController();
  final globalkey = GlobalKey<FormState>();

  Future<void> signup(String name, String email, String password) async {
    try {
      await Get.find<AuthServices>().signup(name, email, password);
      await Get.find<AuthServices>().login(email, password);
      await Get.find<AuthServices>().createemailverification(
        'http://localhost:3030/#/verificationpage',
      );

      Get.snackbar(
        'Success',
        'Verification mail has been sent to your mail succesfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.offAllNamed('/');
    } catch (e) {
      Get.snackbar(
        'failure',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      throw Exception(e.toString());
    }
  }
}
