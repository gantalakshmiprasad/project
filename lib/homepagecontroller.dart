// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:appwrite/enums.dart';
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
        method: ExecutionMethod.pOST,
        headers: {'message': 'Hello this is lakshmiprasad'},
      );
      print(message.responseBody);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
