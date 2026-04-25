import 'package:firstproject/customs/config.dart';
import 'package:firstproject/services/authservices.dart';
import 'package:firstproject/services/databaseservice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Signincontroller extends GetxController {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final globalkey = GlobalKey<FormState>();
  final RxBool profileupdated = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await Get.find<AuthServices>().account.deleteSessions();
  }

  Future<void> signin(String email, String password) async {
    try {
      await Get.find<AuthServices>().login(email, password);
      final user = await Get.find<AuthServices>().getaccount();
      final profile = await Get.find<Databaseservice>().getEntries(
        user.$id,
        ApiConfig().profile,
      );
      if (profile['bussinessname'] != null) {
        Get.offAllNamed('/homepage');
      } else {
        Get.offAllNamed('/profilepage');
      }
    } on Exception catch (e) {
      throw e.toString();
    }
  }
}
