// ignore_for_file: avoid_print

import 'package:firstproject/services/authservices.dart';
import 'package:firstproject/services/storageservice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Additemcontroller extends GetxController {
  final isDownloading = false.obs;

  final errorMessage = ''.obs;
  final TextEditingController prompt = TextEditingController();
  final storageservice = Get.find<Storageservice>();
  final authservice = Get.find<AuthServices>();
}
