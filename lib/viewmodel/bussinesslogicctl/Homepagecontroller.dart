// ignore_for_file: avoid_print, file_names

import 'dart:convert';
import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';
import 'package:firstproject/customs/config.dart';
import 'package:firstproject/model/billmodel.dart';
import 'package:firstproject/model/itemModel.dart';
import 'package:firstproject/services/authservices.dart';
import 'package:firstproject/services/databaseservice.dart';
import 'package:firstproject/services/storageservice.dart';
import 'package:firstproject/viewmodel/bussinesslogicctl/printcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Homepagecontroller extends GetxController {
  final service = Get.find<AuthServices>();
  final RxList database = [].obs;
  final RxList storedimages = [].obs;
  final RxBool addclicked = false.obs;
  final isloading = false.obs;
  final printcontroller = Get.put(Printcontroller());
  final userid = ''.obs;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final RxBool isimageclicked = false.obs;
  void opendialog() => addclicked.value = true;
  void closedialog() => addclicked.value = false;

  final Databaseservice dbservice = Get.find<Databaseservice>();
  final AuthServices authservice = Get.find<AuthServices>();
  final Storageservice storageservice = Get.find<Storageservice>();

  /*-----------------------controllers---------------------------------*/
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController pricecontroller = TextEditingController();
  //----------------------------------------------------------------------
  @override
  void onInit() async {
    super.onInit();
    isloading.value = true;
    await refreshDatabase();
    // 2. Subscribe to Realtime Changes

    isloading.value = false;
    // If you want to bind to your observable list:
  }

  Future<void> listener() async {
    try {
      final realtime = authservice
          .realtime; // Ensure Realtime is initialized in your service

      realtime
          .subscribe([
            'databases.${ApiConfig().databaseId}.collections.${ApiConfig().productmodel}.documents',
          ])
          .stream
          .listen((event) {
            refreshDatabase();
            /* final String eventType = event.events.first;
            final Map<String, dynamic> payload = event.payload;
            final String docId = payload['\$id'];

            // 1. ADD NEW ITEM
            if (eventType.contains('.create')) {
              final newItem = Product.fromMap(payload);
              // Fetch image only for the new item
              final image = await storageservice.getfile(newItem.fileid);

              database.add({
                'id': docId,
                'data': newItem.toMap(),
                'quantity': 0,
                'image': image,
              });
            }
            // 2. UPDATE EXISTING ITEM (e.g., price change or availability)
            else if (eventType.contains('.update')) {
              final index = database.indexWhere(
                (element) => element['id'] == docId,
              );
              if (index != -1) {
                final updatedProduct = Product.fromMap(payload);

                // Update only the data part, keep the existing image and quantity
                database[index]['data'] = updatedProduct.toMap();
                database.refresh(); // Tells GetX to redraw this specific item
              }
            }
            // 3. REMOVE ITEM
            else if (eventType.contains('.delete')) {
              database.removeWhere((element) => element['id'] == docId);
            } */
          });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> submit(String promptText, String price) async {
    try {
      closedialog();
      isloading.value = true;
      Get.defaultDialog(
        content: CircularProgressIndicator(color: Colors.green),
        title: 'Adding $promptText',
        titleStyle: TextStyle(color: Colors.white),
        backgroundColor: Color(0xFF263238),
      );
      final user = await authservice.getaccount(); //getting userid
      final fileid = await clicked(promptText); //getting fileid from function
      final product = Product(
        id: '', // leave empty, Appwrite will generate $id
        itemname: promptText,
        itemprice: price, // keep as string
        userid: user.$id,
        fileid: fileid,
        isavailable: true,
      );

      await dbservice.createEntry(product.toMap(), ApiConfig().productmodel);
    } catch (e) {
      print('Error in homepagectl: $e');
      Exception(e.toString());
    } finally {
      await refreshDatabase();
      isloading.value = false;
      Get.back();
    }
  }

  Future<String> clicked(String promptText) async {
    try {
      final execution = await authservice.function.createExecution(
        functionId: ApiConfig().functionid,
        method: ExecutionMethod.pOST,
        body: '{"prompt":"$promptText"}',
      );
      final Map<String, dynamic> image = jsonDecode(execution.responseBody);
      final urltobytes = await storageservice.urlToBytes(image['result']);
      final fileid = await storageservice.uploadFileWeb(urltobytes, promptText);
      return fileid;
    } catch (e) {
      print(e.toString());
    }
    throw Exception();
  }

  Future<void> onedit(String rowid, bool isavailable, String itemname) async {
    try {
      isloading.value = true;
      Get.defaultDialog(
        title: isavailable ? 'Sold out' : 'Available',
        content: isavailable
            ? Text('$itemname is Sold out')
            : Text('$itemname is available now'),
        titleStyle: TextStyle(color: Colors.black),
        backgroundColor: isavailable ? Colors.red : Colors.green,
      );
      final item = await dbservice.getEntries(rowid);
      await dbservice.updateEntry(rowid, {
        ...item,
        "isavailable": !isavailable,
      }, ApiConfig().productmodel);
      final index = database.indexWhere((item) => item['id'] == rowid);
      if (index != -1) {
        database[index]['data']['isavailable'] = !isavailable;
        database.refresh();
      }
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      await refreshDatabase();
      isloading.value = false;
      Get.back();
    }
  }

  Future<void> onclosed(RxList database) async {
    try {
      for (var item in database) {
        if (item['data']['isavailable'] == false) {
          await dbservice.updateEntry(item['id'], {
            'isavailable': true,
          }, ApiConfig().productmodel);
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void increasequantity(String id) async {
    for (var item in database) {
      if (item['id'] == id) {
        item['quantity']++;

        // 2. Sync with the printcontroller.bills list
        // Find if the item already exists in the bills list
        var existingBillIndex = printcontroller.bills.indexWhere(
          (bill) => bill.id == id,
        );

        if (existingBillIndex != -1) {
          // If it exists, increment the quantity of the existing bill object
          printcontroller.bills[existingBillIndex].quantity++;
        } else {
          // If it doesn't exist, create it from the updated item and add it
          final purchaseditem = Billmodel.fromMap(item);
          print(item);
          printcontroller.bills.add(purchaseditem.toMap());
        }

        // 3. Notify the UI
        database.refresh();
        printcontroller.bills
            .refresh(); // Assuming bills is also an RxList/Observable

        break; // Optimization: stop looking once the item is found
      }
    }
  }

  void decreasequantity(String id) async {
    for (var item in database) {
      if (item['id'] == id) {
        item['quantity']++;

        // 2. Sync with the printcontroller.bills list
        // Find if the item already exists in the bills list
        var existingBillIndex = printcontroller.bills.indexWhere(
          (bill) => bill.id == id,
        );

        if (existingBillIndex != -1) {
          // If it exists, increment the quantity of the existing bill object
          printcontroller.bills[existingBillIndex].quantity--;
        } else {
          // If it doesn't exist, create it from the updated item and add it
          final purchaseditem = Billmodel.fromMap(item);
          printcontroller.bills.add(purchaseditem.toMap());
        }

        // 3. Notify the UI
        database.refresh();
        printcontroller.bills
            .refresh(); // Assuming bills is also an RxList/Observable

        break; // Optimization: stop looking once the item is found
      }
    }
  }

  Future<void> refreshDatabase() async {
    try {
      final user = await authservice.getaccount();
      final RowList rowlist = await dbservice.fetchdata(user.$id);

      final freshdata = [];
      for (var row in rowlist.rows) {
        final item = Product.fromMap(row.data);
        final image = await storageservice.getfile(item.fileid);
        freshdata.add({
          'id': row.$id,
          'data': item.toMap(),
          'quantity': 0,
          'image': image,
        });
      }
      database.clear();
      database.assignAll(freshdata);
    } catch (e) {
      print("Error refreshing database: $e");
    } finally {
      database.refresh();
    }
  }

  @override
  void onClose() {
    namecontroller.dispose();
    pricecontroller.dispose();
    super.onClose();
  }
}
