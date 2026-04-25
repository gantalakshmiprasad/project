import 'package:firstproject/customs/config.dart';
import 'package:firstproject/services/authservices.dart';
import 'package:firstproject/services/databaseservice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Profilepagecontroller extends GetxController {
  final TextEditingController bussiness = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController title = TextEditingController();
  final RxBool isselected = true.obs;
  final RxInt selectedIconIndex = 0.obs;
  final formkey = GlobalKey<FormState>();

  Future<void> formsubmit(
    String address,
    String title,
    String bussiness,
  ) async {
    try {
      final user = await Get.find<AuthServices>().getaccount();
      await Get.find<Databaseservice>().updateEntry(user.$id, {
        'address': address,
        'bussinessname': title,
        'bussinesstype': bussiness,
      }, ApiConfig().profile);
      Get.offAllNamed('/homepage');
    } catch (e) {
      throw e.toString();
    }
  }
}
