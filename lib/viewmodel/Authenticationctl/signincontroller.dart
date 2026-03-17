import 'package:firstproject/services/authservices.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Signincontroller extends GetxController {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final globalkey = GlobalKey<FormState>();

  @override
  void onInit() async {
    super.onInit();
    await Get.find<AuthServices>().account.deleteSessions();
  }

  Future<void> signin(String email, String password) async {
    await Get.find<AuthServices>().login(email, password);

    Get.offAllNamed('/homepage');
  }
}
