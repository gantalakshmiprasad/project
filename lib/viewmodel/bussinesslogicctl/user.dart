import 'package:firstproject/services/authservices.dart';
import 'package:get/get.dart';

class Getuserdetailsctl extends GetxController {
  final RxString userid = ''.obs;
  final RxString username = ''.obs;
  final RxString email = ''.obs;
  @override
  void onInit() async {
    super.onInit();
    final user = await Get.find<AuthServices>().getaccount();
    print(user);
  }
}
