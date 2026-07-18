import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:firstproject/customs/config.dart';
import 'package:firstproject/services/authservices.dart';
import 'package:firstproject/services/databaseservice.dart';
import 'package:get/get.dart';

class Billscontroller extends GetxController {
  final RxList<Map<String, dynamic>> bills = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBills();
  }

  Future<void> fetchBills() async {
    try {
      isLoading.value = true;
      final user = await Get.find<AuthServices>().getaccount();

      final RowList allItems = await Get.find<Databaseservice>().fetchdata(
        ApiConfig().billeditems,
        [Query.equal('restaurantid', user.$id)],
      );

      final RowList allBills = await Get.find<Databaseservice>()
          .fetchdata(ApiConfig().bill, [
            Query.equal('restaurantid', user.$id),
            Query.orderAsc('billnumber'),
            Query.limit(1000),
          ]);

      final List<Map<String, dynamic>> temporaryList = [];

      for (var billRow in allBills.rows) {
        final List<Map<String, dynamic>> billItems = [];

        for (var itemRow in allItems.rows) {
          if (itemRow.data['billnumber'] == billRow.data['billnumber']) {
            billItems.add({
              'itemname': itemRow.data['itemname'],
              'itemprice': itemRow.data['itemprice'],
              'quantity': itemRow.data['quantity'],
              'restaurantid': itemRow.data['restaurantid'],
            });
          }
        }

        temporaryList.add({
          'rowid': billRow.$id,
          'billnumber': billRow.data['billnumber'],
          'totalamount': billRow.data['totalamount'],
          'items': billItems,
          'restaurantid': billRow.data['restaurantid'],
          'createdAt': billRow.$createdAt,
        });
      }

      bills.assignAll(temporaryList);
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch bills: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteallbills() async {
    final dbservice = Get.find<Databaseservice>();
    try {
      isLoading.value = true;

      for (var bill in bills) {
        // Fetch only items linked to THIS bill
        final itemsToDelete = await dbservice
            .fetchdata(ApiConfig().billeditems, [
              Query.equal('restaurantid', bill['restaurantid']),
              Query.equal('billnumber', bill['billnumber']),
            ]);

        for (var row in itemsToDelete.rows) {
          await dbservice.deleteEntry(row.$id, ApiConfig().billeditems);
        }

        await dbservice.deleteEntry(bill['rowid'], ApiConfig().bill);
      }

      bills.clear();

      Get.snackbar(
        "Success",
        "All records cleared from database.",
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
      );
    } catch (e) {
      Get.snackbar("Error", "Could not complete deletion: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
