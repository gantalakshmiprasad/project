import 'package:firstproject/model/authservices.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Forgotpasswordctl extends GetxController {
  final TextEditingController email = TextEditingController();

  Future<void> enter(String email) async {
    await Get.find<AuthServices>().sendForgotPasswordEmail(email);
    Get.offAllNamed('/');
  }
}
