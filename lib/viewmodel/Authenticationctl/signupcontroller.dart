import 'package:firstproject/customs/config.dart';
import 'package:firstproject/services/authservices.dart';
import 'package:firstproject/services/databaseservice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Signupcontroller extends GetxController {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController usernamecontroller = TextEditingController();
  final globalkey = GlobalKey<FormState>();
  final Databaseservice dbservices = Get.find<Databaseservice>();
  final AuthServices authservice = Get.find<AuthServices>();
  Future<void> signup(String name, String email, String password) async {
    try {
      await authservice.signup(name, email, password);
      await authservice.login(email, password);
      await dbservices.createEntry({
        'name': name,
        'email': email,
      }, ApiConfig().collectionId);
      await authservice.createemailverification(
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
