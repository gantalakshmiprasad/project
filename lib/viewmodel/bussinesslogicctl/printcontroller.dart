// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:firstproject/customs/config.dart';
import 'package:firstproject/services/authservices.dart';
import 'package:firstproject/services/databaseservice.dart';
import 'package:firstproject/viewmodel/bussinesslogicctl/Homepagecontroller.dart';
import 'package:firstproject/viewmodel/bussinesslogicctl/printreceipt.dart';
import 'package:get/get.dart';
// Import your layout controller file path containing XPrinterController here

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

      final result = await database.fetchdata(ApiConfig().bill, [
        Query.equal('restaurantid', user.$id),
        Query.orderDesc('billnumber'),
        Query.limit(1),
      ]);

      final bussinessinfo = await database.getEntries(
        user.$id,
        ApiConfig().profile,
      );
      bussinesstitle.value = bussinessinfo['bussinessname'] ?? '';
      address.value = bussinessinfo['address'] ?? '';

      if (result.rows.isNotEmpty) {
        int lastBill = result.rows.first.data['billnumber'];
        billno.value = lastBill + 1;
      } else {
        billno.value = 1;
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> printReceipt() async {
    final homepagectl = Get.find<Homepagecontroller>();

    print("📍 [DEBUG] 1. entering printReceipt function");

    // Check if XPrinterController is even registered in GetX memory
    if (!Get.isRegistered<XPrinterController>()) {
      print(
        "❌ [DEBUG] ERROR: XPrinterController is NOT found in GetX memory! Did you call Get.put(XPrinterController())?",
      );
      Get.snackbar('System Error', 'Printer service not initialized.');
      return;
    }
    final XPrinterController printerController = Get.find<XPrinterController>();

    if (bills.isEmpty) {
      print("❌ [DEBUG] Early exit: 'bills' list is empty. Nothing to print.");
      return;
    }

    try {
      isloading.value = true;
      final currentBillNo = billno.value;
      final currentTotal = int.tryParse(totalAmount.toString()) ?? 0;
      final itemsToSave = List.from(bills);

      print(
        "📍 [DEBUG] 2. Bills count: ${itemsToSave.length}, Total: $currentTotal",
      );

      final user = await Get.find<AuthServices>().getaccount();

      final data1 = {
        'billnumber': currentBillNo,
        'totalamount': currentTotal,
        'restaurantid': user.$id,
      };

      print("📍 [DEBUG] 3. Saving main bill to Appwrite Database...");
      await database.createEntry(ID.unique(), data1, ApiConfig().bill);
      print("✅ [DEBUG] Main bill saved successfully.");

      print("📍 [DEBUG] 4. Saving itemized billed items...");
      for (var item in itemsToSave) {
        final data = {
          'billnumber': currentBillNo,
          'itemname': item['itemname'],
          'itemprice': int.tryParse(item['itemprice'].toString()) ?? 0,
          'quantity': int.tryParse(item['quantity'].toString()) ?? 0,
          'restaurantid': user.$id,
        };
        await database.createEntry(ID.unique(), data, ApiConfig().billeditems);
      }
      print("✅ [DEBUG] Itemized items saved successfully.");

      // Local State Cleanup
      checkoutHistory.add({
        "billId": currentBillNo,
        "items": itemsToSave,
        "total": currentTotal,
      });
      bills.clear();
      billno.value++;

      print(
        "📍 [DEBUG] 5. Calling Appwrite Cloud Function (${ApiConfig().functionid})...",
      );

      final execution = await Get.find<AuthServices>().function.createExecution(
        functionId: ApiConfig().functionid,
        method: ExecutionMethod.pOST,
        body: jsonEncode({
          "action": "printreceipt",
          "storeName": bussinesstitle.value.isEmpty
              ? "UNIVERSAL BILLING"
              : bussinesstitle.value,
          "invoiceId": "INV-${currentBillNo.toString().padLeft(4, '0')}",
          "date": "2026-06-17 10:50",
          "items": itemsToSave
              .map(
                (e) => {
                  "name": e['itemname'],
                  "qty": e['quantity'],
                  "price": double.tryParse(e['itemprice'].toString()) ?? 0.0,
                },
              )
              .toList(),
          "total": currentTotal.toDouble(),
        }),
      );

      print(
        "✅ [DEBUG] Appwrite Function executed. Status Code: ${execution.status}",
      );
      print("📍 [DEBUG] Appwrite Raw Response Body: ${execution.responseBody}");

      // Clear quantities UI
      for (var item in homepagectl.database) {
        item['quantity'] = 0;
      }
      homepagectl.database.refresh();
      token.value++;

      // Process Response
      final responseData = jsonDecode(execution.responseBody);

      if (responseData['success'] == true) {
        String? base64BytesStr = responseData['bytes'];
        if (base64BytesStr == null || base64BytesStr.isEmpty) {
          print(
            "❌ [DEBUG] ERROR: 'bytes' key in Appwrite response is null or empty!",
          );
          return;
        }

        print("📍 [DEBUG] 6. Decoding Base64 receipt bytes...");
        Uint8List rawPrinterBytes = base64Decode(base64BytesStr);
        print(
          "✅ [DEBUG] Successfully decoded ${rawPrinterBytes.length} bytes.",
        );

        print("📍 [DEBUG] 7. Sending bytes directly to printer controller...");
        await printerController.printRawBytes(rawPrinterBytes);
        print("✅ [DEBUG] Direct stream command completed.");
      } else {
        print(
          "❌ [DEBUG] Appwrite function returned success: false. Message: ${responseData['message']}",
        );
        Get.snackbar(
          'Execution Error',
          responseData['message'] ?? 'Failed compiling layout.',
        );
      }
    } catch (e, stacktrace) {
      print("❌ [DEBUG] CRITICAL CRASH inside printReceipt: $e");
      print("📍 [DEBUG] Stacktrace: $stacktrace");
      Get.snackbar('Transaction Error', 'Failed execution loop: $e');
    } finally {
      isloading.value = false;
      print("📍 [DEBUG] 8. Exiting printReceipt function execution loop.");
    }
  }
}
