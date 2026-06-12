import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:firstproject/customs/config.dart';
import 'package:firstproject/services/authservices.dart';
import 'package:firstproject/services/databaseservice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Billscontroller extends GetxController {
  final RxList bills = [].obs;
  final RxBool isLoading = true.obs;

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

      final RowList allBills = await Get.find<Databaseservice>().fetchdata(
        ApiConfig().bill,
        [
          Query.equal('restaurantid', user.$id),
          Query.orderAsc('billnumber'),
          Query.limit(1000),
        ], // Show latest bills first
      );

      final temporaryList = [];

      for (var billRow in allBills.rows) {
        final List billItems = [];

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
      throw e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteallbills() async {
    final dbservice = Get.find<Databaseservice>();
    try {
      isLoading.value = true;

      // 1. Create a "Batch" of deletions to avoid redundant fetching
      // We loop through the bills list once.
      for (var bill in bills) {
        // 2. Fetch only the items linked to THIS specific bill
        final itemsToDelete = await dbservice.fetchdata(
          ApiConfig().billeditems,
          [Query.equal('restaurantid', bill['restaurantid'])],
        );

        // 3. Delete the children (items) first
        for (var row in itemsToDelete.rows) {
          await dbservice.deleteEntry(row.$id, ApiConfig().billeditems);
        }

        // 4. Delete the parent (the bill itself)
        await dbservice.deleteEntry(bill['rowid'], ApiConfig().bill);
      }

      // 5. Clear local state only after successful DB deletion
      bills.clear();
      Get.snackbar(
        "Success",
        "All records cleared from database.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar("Error", "Could not complete deletion.");
    } finally {
      isLoading.value = false;
    }
  }
}
