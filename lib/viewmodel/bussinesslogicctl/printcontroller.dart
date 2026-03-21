import 'package:firstproject/viewmodel/bussinesslogicctl/Homepagecontroller.dart';
import 'package:get/get.dart';

class Printcontroller extends GetxController {
  final RxList bills = [].obs;
  final RxDouble totalamount = 0.0.obs;
  final RxInt totalquantity = 0.obs;
  final RxList checkout = [].obs;
  final RxInt billno = 0.obs;

  @override
  void onInit() async {
    super.onInit();
  }

  void total() {
    totalamount.value = 0.0;
    totalquantity.value = 0;

    for (var item in bills) {
      totalamount.value += (item['amount'] as num).toDouble();
      totalquantity.value += (item['data']['quantity'] as num).toInt();
    }
  }

  void print() {
    final homeController = Get.find<Homepagecontroller>();
    bills.clear();
    billno.value++;
    homeController.onclosed(homeController.database);
    bills.refresh();
    homeController.database.refresh();
    totalamount.value = 0.0;
    totalquantity.value = 0;
  }
}
