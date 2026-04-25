// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:firstproject/customs/config.dart';
import 'package:firstproject/services/authservices.dart';

import 'package:firstproject/services/databaseservice.dart';
import 'package:firstproject/viewmodel/bussinesslogicctl/Homepagecontroller.dart';

import 'package:get/get.dart';

class Printcontroller extends GetxController {
  final RxString bussinesstitle = ''.obs;
  final RxString address = ''.obs;
  final RxList bills = [].obs;
  final RxList checkoutHistory = [].obs;
  final RxInt billno = 0.obs;
  final Databaseservice database = Get.find<Databaseservice>();
  final RxBool isloading = false.obs;
  final RxInt token = 1.obs;

  double get totalAmount => bills.fold(
    0.0,
    (sum, item) =>
        sum +
        (double.tryParse(item['itemprice'].toString()) ?? 0.0) *
            item['quantity'],
  );

  int get totalQuantity =>
      bills.fold(0, (sum, item) => sum + (item['quantity'] as int));

  @override
  void onInit() async {
    super.onInit();
    try {
      final user = await Get.find<AuthServices>().getaccount();
      final result = await database.fetchdata(user.$id, ApiConfig().bill, [
        // Filter by user
        Query.equal('restaurantid', user.$id),
        Query.orderDesc('billnumber'),
        // Sort highest to lowest
        Query.limit(1), // Only take the top one
      ]);
      final bussinessinfo = await database.getEntries(
        user.$id,
        ApiConfig().profile,
      );
      bussinesstitle.value = bussinessinfo['bussinessname'];
      address.value = bussinessinfo['address'];
      if (result.rows.isNotEmpty) {
        // Get the highest number and add 1
        int lastBill = result.rows.first.data['billnumber'];
        billno.value = lastBill + 1;
      } else {
        billno.value = 1; // Start at 1 if no bills exist
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> printReceipt() async {
    final homepagectl = Get.find<Homepagecontroller>();

    if (bills.isEmpty) return;

    try {
      isloading.value = true;
      final currentBillNo = billno.value;
      final currentTotal = int.tryParse(totalAmount.toString());
      final itemsToSave = List.from(bills);

      final receipt = {
        "billId": currentBillNo,
        "items": itemsToSave,
        "total": currentTotal,
      };

      final user = await Get.find<AuthServices>().getaccount();
      final data1 = {
        'billnumber': currentBillNo,
        'totalamount': currentTotal,
        'restaurantid': user.$id,
      };

      // 2. Database: Create the main bill entry
      // Use .value for RxInt, otherwise you pass the controller object, not the number
      await database.createEntry(ID.unique(), data1, ApiConfig().bill);

      // 3. Database: Save individual items
      // FIX: Loop through 'itemsToSave', because 'bills' gets cleared below!
      for (var item in itemsToSave) {
        final data = {
          'billnumber': currentBillNo,
          'itemname': item['itemname'],
          'itemprice': int.tryParse(item['itemprice'].toString()),
          'quantity': int.tryParse(item['quantity'].toString()),
          'restaurantid': user.$id,
        };

        await database.createEntry(ID.unique(), data, ApiConfig().billeditems);
      }

      // 4. UI/Local State Cleanup
      checkoutHistory.add(receipt);
      bills.clear();
      billno.value++;

      final execution = await Get.find<AuthServices>().function.createExecution(
        functionId: ApiConfig().printfuntionid,
        method: ExecutionMethod.pOST,
        body: jsonEncode({
          "shopName": bussinesstitle.value,
          "address": address.value,
          "invoiceNo": billno.value,
          "items": itemsToSave,
          "total": currentTotal,
        }),
      );

      // Increment for the next customer
      final result = jsonDecode(execution.responseBody);

      // Reset quantities in the home controller

      print(result['result']);
      homepagectl.isitemsloading.value = true;

      for (var item in homepagectl.database) {
        item['quantity'] = 0;
      }
      homepagectl.isitemsloading.value = false;
      homepagectl.database.refresh();

      isloading.value = false;
      token.value++;
    } catch (e) {
      print("Error saving receipt: $e");

      // Consider using Get.snackbar here to inform the user
    }
  }
}
