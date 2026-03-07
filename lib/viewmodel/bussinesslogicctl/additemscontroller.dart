// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:appwrite/enums.dart';
import 'package:firstproject/customs/config.dart';
import 'package:firstproject/model/authservices.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Homepagecontroller extends GetxController {
  final isDownloading = false.obs;
  final imageurl = ''.obs;
  final errorMessage = ''.obs;
  final TextEditingController prompt = TextEditingController();
  final service = Get.find<AuthServices>();
  final userid = ''.obs;
  Future<void> clicked(String promptText, String price) async {
    try {
      if (promptText.isEmpty) {
        errorMessage.value = 'Please enter a search query';
        return;
      }
      isDownloading.value = true;
      errorMessage.value = '';

      final execution = await service.function.createExecution(
        functionId: ApiConfig().functionid,
        method: ExecutionMethod.pOST,

        body: '{"prompt":"$promptText"}',
      );

      final image = jsonDecode(execution.responseBody);

      imageurl.value = image['result'];
      final urltobytes = await Get.find<AuthServices>().urlToBytes(
        imageurl.value,
      );
      final userid = await Get.find<AuthServices>().getaccount();
      await Get.find<AuthServices>().uploadFileWeb(
        urltobytes,
        promptText,
        userid,
      );
      await Get.find<AuthServices>().createEntry({
        'productName': promptText,
        'price': price,
        'imageurl': imageurl.value,
        'userid': userid,
      });
    } catch (e) {
      errorMessage.value = 'Error fetching image: $e';
      print(e.toString());
    } finally {
      isDownloading.value = false;
    }
  }
}
