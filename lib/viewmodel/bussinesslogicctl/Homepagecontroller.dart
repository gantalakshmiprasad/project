// ignore_for_file: file_names

import 'dart:convert';

import 'package:appwrite/enums.dart';
import 'package:firstproject/customs/config.dart';
import 'package:firstproject/model/authservices.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Homepagecontroller extends GetxController {
  final service = Get.find<AuthServices>();
  final RxList database = [].obs;
  final imageurl = ''.obs;

  final RxBool addclicked = false.obs;

  final isDownloading = false.obs;

  final errorMessage = ''.obs;

  final userid = ''.obs;
  final RxBool isimageclicked = false.obs;
  /*-----------------------controllers---------------------------------*/
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController pricecontroller = TextEditingController();
  //----------------------------------------------------------------------
  Future<void> submit(String promptText, String price) async {
    try {
      isimageclicked.value = true;
      final execution = await service.function.createExecution(
        functionId: ApiConfig().functionid,
        method: ExecutionMethod.pOST,

        body: '{"prompt":"$promptText"}',
      );

      final image = jsonDecode(execution.responseBody);

      imageurl.value = image['result'];
    } catch (e) {
      throw Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        showProgressIndicator: true,
        progressIndicatorBackgroundColor: Colors.red,
      );
    }
  }

  @override
  void onClose() {
    namecontroller.dispose();
    pricecontroller.dispose();
    super.onClose();
  }
}



/* 
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

*/