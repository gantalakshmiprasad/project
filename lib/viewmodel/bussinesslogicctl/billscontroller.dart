import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:firstproject/customs/config.dart';
import 'package:firstproject/services/authservices.dart';
import 'package:firstproject/services/databaseservice.dart';
import 'package:get/get.dart';

class Billscontroller extends GetxController {
  final RxList bills = [].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBills();
    bills.map((element) => print(element));
  }

  Future<void> fetchBills() async {
    try {
      isLoading.value = true;
      final user = await Get.find<AuthServices>().getaccount();

      // 1. Get all individual items ever sold
      final RowList allItems = await Get.find<Databaseservice>().fetchdata(
        user.$id,
        ApiConfig().billeditems,
        [Query.limit(100)],
      );

      // 2. Get all unique bill headers
      final RowList allBills = await Get.find<Databaseservice>().fetchdata(
        user.$id,
        ApiConfig().bill,
        [Query.orderAsc('billnumber')], // Show latest bills first
      );

      final List temporaryList = [];

      for (var billRow in allBills.rows) {
        final List billItems = [];

        for (var itemRow in allItems.rows) {
          // Check if this item belongs to this bill number
          if (billRow.data['billnumber'] == itemRow.data['billnumber']) {
            billItems.add({
              'itemname': itemRow.data['itemname'], // USE itemRow here
              'itemprice': itemRow.data['itemprice'],
              'quantity': itemRow.data['quantity'],
              'restaurantid': itemRow.data['restaurantid'],
            });
          }
        }

        temporaryList.add({
          'billnumber': billRow.data['billnumber'],
          'totalamount': billRow.data['totalamount'],
          'items': billItems,
          'restaurantid': billRow.data['restaurantid'],
          'createdAt': billRow.$createdAt,
        });
      }

      bills.assignAll(temporaryList);
    } catch (e) {
      throw e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
