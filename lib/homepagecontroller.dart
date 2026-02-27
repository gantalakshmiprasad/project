import 'package:firstproject/authservices.dart';
import 'package:get/get.dart';

class Homepagecontroller extends GetxController {
  final message = ''.obs;
  final email = 'chuchu.aadhavan@gmail.com';
  final password = '12345678';
  Future<void> clicked() async {
    try {
      Get.find<AuthServices>().login(email, password);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
