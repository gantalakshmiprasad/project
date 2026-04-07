// ignore_for_file: avoid_print

import 'package:firstproject/customs/config.dart';
import 'package:firstproject/services/authservices.dart';
import 'package:firstproject/services/databaseservice.dart';
import 'package:firstproject/viewmodel/bussinesslogicctl/Homepagecontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Printcontroller extends GetxController {
  final RxList bills = [].obs;
  final RxList checkoutHistory = [].obs;
  final RxInt billno = 0.obs;
  final Databaseservice database = Get.find<Databaseservice>();

  double get totalAmount => bills.fold(
    0.0,
    (sum, item) =>
        sum +
        (double.tryParse(item['itemprice'].toString()) ?? 0.0) *
            item['quantity'],
  );

  int get totalQuantity =>
      bills.fold(0, (sum, item) => sum + (item['quantity'] as int));

  Future<void> printReceipt() async {
    final homepagectl = Get.find<Homepagecontroller>();

    if (bills.isEmpty) return;

    try {
      CircularProgressIndicator();
      final user = await Get.find<AuthServices>().account.get();
      print("User is logged in as: ${user.email}");
      // 1. Capture the current state before clearing
      final currentBillNo = billno.value;
      final currentTotal = int.tryParse(totalAmount.toString());
      final itemsToSave = List.from(bills);

      final receipt = {
        "billId": currentBillNo,
        "items": itemsToSave,
        "total": currentTotal,
      };

      // 2. Database: Create the main bill entry
      // Use .value for RxInt, otherwise you pass the controller object, not the number
      await database.createEntry({
        'billnumber': currentBillNo,
        'totalamount': currentTotal,
      }, ApiConfig().bill);

      // 3. Database: Save individual items
      // FIX: Loop through 'itemsToSave', because 'bills' gets cleared below!
      for (var item in itemsToSave) {
        await database.createEntry({
          'billnumber': currentBillNo,
          'itemname': item['itemname'],
          'itemprice': int.tryParse(item['itemprice']),
          'quantity': int.tryParse(item['quantity']),
        }, ApiConfig().billeditems);
      }

      // 4. UI/Local State Cleanup
      checkoutHistory.add(receipt);
      bills.clear();
      billno.value++; // Increment for the next customer

      // Reset quantities in the home controller
      homepagectl.isloading.value = true;
      for (var item in homepagectl.database) {
        item['quantity'] = 0;
      }
      homepagectl.isloading.value = false;
      homepagectl.database.refresh();

      Get.back();
    } catch (e) {
      print("Error saving receipt: $e");
      // Consider using Get.snackbar here to inform the user
    }
  }
}
