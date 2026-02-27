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
      final result = await Get.find<AuthServices>().function.createExecution(
        functionId: functionid,
        method: ExecutionMethod.pOST,
        headers: {'message': 'Hello this is lakshmiprasad'},
      );
      message.value = result.responseBody;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
