import 'package:firstproject/model/authservices.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Signincontroller extends GetxController {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final globalkey = GlobalKey<FormState>();

  Future<void> signin(String email, String password) async {
    try {
      await Get.find<AuthServices>().login(email, password);
      Get.offAllNamed('/homepage');
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
