// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:firstproject/customs/config.dart';
import 'package:firstproject/services/authservices.dart';
import 'package:firstproject/services/databaseservice.dart';
import 'package:firstproject/viewmodel/bussinesslogicctl/Homepagecontroller.dart';
import 'package:firstproject/viewmodel/connectionctl/bluetoothctl.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Printcontroller extends GetxController {
  late final Homepagecontroller homepagectl;
  final bluetoothctl = Get.put(BluetoothController());
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
    homepagectl = Get.find<Homepagecontroller>();
    try {
      final user = await Get.find<AuthServices>().getaccount();
      print('This is from printfile:${user.$id}');
      final result = await database.fetchdata(ApiConfig().bill, [
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
    if (bills.isEmpty) return;
    DateTime now = DateTime.now();

    // Pattern: Day/Month/Year Hour:Minute AM/PM
    String customFormat = DateFormat('dd/MM/yyyy hh:mm a').format(now);
    try {
      isloading.value = true;
      final currentBillNo = billno.value;
      final currentTotal = totalAmount;
      final itemsToSave = List.from(bills);

      final user = await Get.find<AuthServices>().getaccount();
      final data1 = {
        'billnumber': currentBillNo,
        'totalamount': currentTotal.toInt(),
        'restaurantid': user.$id,
      };

      final receipt = {
        "billId": currentBillNo,
        "items": itemsToSave,
        "total": currentTotal,
      };

      await database.createEntry(ID.unique(), data1, ApiConfig().bill);

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

      checkoutHistory.add(receipt);
      bills.clear();
      billno.value++;

      final execution = await Get.find<AuthServices>().function.createExecution(
        functionId: ApiConfig().functionid,
        method: ExecutionMethod.pOST,
        body: jsonEncode({
          "action": "printreceipt",
          "storeName": bussinesstitle.value,
          "invoiceId": "$currentBillNo",
          "date": customFormat,
          "printerWidth": 58,
          "items": itemsToSave,
          "total": currentTotal,
        }),
      );

      for (var item in homepagectl.database) {
        item['quantity'] = 0;
      }
      homepagectl.database.refresh();
      token.value++;

      if (execution.responseBody.isEmpty) {
        Get.snackbar(
          "Print error",
          "No response from the print function.",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final response = jsonDecode(execution.responseBody);
      final base64string = response['bytes'];
      if (base64string == null || (base64string as String).isEmpty) {
        Get.snackbar(
          "Print error",
          "The print function did not return any receipt data.",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final List<int> receiptBytes = base64.decode(base64string);
      await bluetoothctl.printTest(receiptBytes);
      reset();
    } catch (e) {
      print("Error saving receipt: $e");
    } finally {
      isloading.value = false;
    }
  }

  void reset() {
    try {
      bills.clear();
      for (var item in homepagectl.database) {
        item['quantity'] = 0;
      }
      homepagectl.database.refresh();
    } catch (e) {
      throw e.toString();
    }
  }
}
