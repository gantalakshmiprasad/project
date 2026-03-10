// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:appwrite/enums.dart';
import 'package:firstproject/customs/config.dart';
import 'package:firstproject/services/authservices.dart';
import 'package:firstproject/services/storageservice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Additemcontroller extends GetxController {
  final isDownloading = false.obs;
  final imageurl = ''.obs;
  final errorMessage = ''.obs;
  final TextEditingController prompt = TextEditingController();
  final storageservice = Get.find<Storageservice>();
  final authservice = Get.find<AuthServices>();
  final userid = ''.obs;
  Future<void> clicked(String promptText, String price) async {
    try {
      if (promptText.isEmpty) {
        errorMessage.value = 'Please enter a search query';
        return;
      }
      isDownloading.value = true;
      errorMessage.value = '';

      final execution = await authservice.function.createExecution(
        functionId: ApiConfig().functionid,
        method: ExecutionMethod.pOST,

        body: '{"prompt":"$promptText"}',
      );

      final image = jsonDecode(execution.responseBody);

      imageurl.value = image['result'];
      final urltobytes = await storageservice.urlToBytes(imageurl.value);
      final userid = await Get.find<AuthServices>().getaccount();
      await storageservice.uploadFileWeb(urltobytes, promptText, userid);
    } catch (e) {
      errorMessage.value = 'Error fetching image: $e';
      print(e.toString());
    } finally {
      isDownloading.value = false;
    }
  }
}
