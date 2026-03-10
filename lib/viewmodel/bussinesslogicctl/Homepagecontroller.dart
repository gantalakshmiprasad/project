// ignore_for_file: avoid_print, file_names

import 'package:firstproject/customs/config.dart';
import 'package:firstproject/services/authservices.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Homepagecontroller extends GetxController {
  final service = Get.find<AuthServices>();
  final RxList database = [].obs;

  final RxBool addclicked = false.obs;

  final isDownloading = false.obs;

  final errorMessage = ''.obs;
  final RxInt quantity = 0.obs;
  final userid = ''.obs;
  final RxBool isimageclicked = false.obs;
  void opendialog() => isimageclicked.value = true;
  void closedialog() => isimageclicked.value = false;
  /*-----------------------controllers---------------------------------*/
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController pricecontroller = TextEditingController();
  //----------------------------------------------------------------------

  Future<void> submit(String promptText, String price) async {
    try {} catch (e) {
      Exception(e.toString());
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