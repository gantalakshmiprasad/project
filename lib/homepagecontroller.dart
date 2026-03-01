// ignore_for_file: avoid_print

import 'package:appwrite/enums.dart';
import 'package:firstproject/authservices.dart';
import 'package:firstproject/important.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Homepagecontroller extends GetxController {
  final message = ''.obs;
  final email = 'chuchu.aadhavan@gmail.com';
  final password = '12345678';
  final service = Get.find<AuthServices>();
  final TextEditingController prompt = TextEditingController();
  Future<void> clicked(String prompt) async {
    try {
      await service.account.deleteSessions();
      await service.login(email, password);

      final result = await Get.find<AuthServices>().function.createExecution(
        functionId: functionid,
        method: ExecutionMethod.pOST,
        body: prompt,
      );

      print(result.responseBody);
      message.value = result.responseBody;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
