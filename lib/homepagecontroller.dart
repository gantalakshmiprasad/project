// ignore_for_file: avoid_print

import 'package:firstproject/authservices.dart';
import 'package:firstproject/important.dart';
import 'package:get/get.dart';

class Homepagecontroller extends GetxController {
  final message = ''.obs;
  final email = 'chuchu.aadhavan@gmail.com';
  final password = '12345678';
  Future<void> clicked() async {
    try {
      final message = await Get.find<AuthServices>().function.createExecution(
        functionId: functionid,
        body: 'This is a function',
      );
      print(message.responseBody);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
