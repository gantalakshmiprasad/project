// ignore_for_file: avoid_print, file_names
import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';
import 'package:firstproject/customs/config.dart';
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
  final RxBool issignedout = false.obs;
  final RxBool addclicked = false.obs;
  final RxBool isitemsloading = false.obs;
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
    isitemsloading.value = true;
    update();
    refreshDatabase();
    isitemsloading.value = false;
  }

  Future<void> submit(String promptText, String price) async {
    try {
      closedialog();
      isitemsloading.value = true;

      final user = await authservice.getaccount(); //getting userid
      final fileid = await clicked(promptText); //getting fileid from function
      final image = await storageservice.getfile(fileid);
      final product = Product(
        id: '', // leave empty, Appwrite will generate $id
        itemname: promptText,
        itemprice: price, // keep as string
        userid: user.$id,
        fileid: fileid,
        isavailable: true,
        quantity: 0,
      );

      await dbservice.createEntry(product.toMap(), ApiConfig().productmodel);
      database.add({
        'id': user.$id,
        'data': product.toMap(),
        'image': image,
        'quantity': product.quantity,
      });
    } on AppwriteException catch (e) {
      // 409 is the specific code for a Unique Index violation
      if (e.code == 409) {
        Get.snackbar(
          "Duplicate Item",
          "An item with the name '$promptText' already exists.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar("Error", e.message ?? "An unknown error occurred");
      }
    } catch (e) {
      throw e.toString();
    } finally {
      isitemsloading.value = false;
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

  Future<void> onedit(String id, bool isavailable, String itemname) async {
    try {
      Get.defaultDialog(
        contentPadding: EdgeInsets.all(15),
        title: isavailable ? 'Sold out' : 'Available',
        content: isavailable
            ? Stack(
                children: [
                  Text(
                    '${itemname.toUpperCase()} is Sold out',
                    style: TextStyle(fontSize: 30),
                  ),
                ],
              )
            : Text(
                '${itemname.toUpperCase()} is available now',
                style: TextStyle(fontSize: 30),
              ),
        titleStyle: TextStyle(color: Colors.black, fontSize: 30),
        backgroundColor: isavailable ? Colors.red : Colors.green,
        onCancel: Get.back,
        cancelTextColor: Colors.black,
      );
      for (var item in database) {
        if (item['id'] == id) {
          item['data']['isavailable'] = !isavailable;
          database.refresh();
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> onclosed(RxList database) async {
    try {
      issignedout.value = true;
      for (var item in database) {
        await dbservice.updateEntry(item['id'], {
          'isavailable': true,
          'quantity': 0,
        }, ApiConfig().productmodel);
      }
      issignedout.value = false;
      Get.offAllNamed('/');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void increasequantity(String id) {
    final index = database.indexWhere((item) => item['id'] == id);
    if (index == -1) return;

    // 1. Update Local Database List
    database[index]['quantity']++;
    database[index]['data']['quantity'] = database[index]['quantity'];
    database.refresh();

    // 2. Update Print Controller
    var existingBillIndex = printcontroller.bills.indexWhere(
      (bill) => bill['id'] == id,
    );

    if (existingBillIndex != -1) {
      printcontroller.bills[existingBillIndex]['quantity']++;
      double price = double.parse(
        printcontroller.bills[existingBillIndex]['itemprice'].toString(),
      );
      printcontroller.bills[existingBillIndex]['amount'] =
          price * printcontroller.bills[existingBillIndex]['quantity'];
    } else {
      // Create new bill entry from product
      final product = database[index];
      final billEntry = {
        'id': product['id'],
        'itemname': product['data']['itemname'],
        'itemprice': product['data']['itemprice'],
        'quantity': 1,
        'amount': double.parse(product['data']['itemprice'].toString()),
        'restaurantid': product['data']['restaurantid'],
      };
      printcontroller.bills.add(billEntry);
    }

    printcontroller.bills.refresh();
  }

  void decreasequantity(String id) {
    final index = database.indexWhere((item) => item['id'] == id);
    if (index == -1) return;

    if (database[index]['quantity'] > 0) {
      // 1. Update Local Database List
      database[index]['quantity']--;
      database[index]['data']['quantity'] = database[index]['quantity'];
      database.refresh();

      // 2. Update Print Controller
      var existingBillIndex = printcontroller.bills.indexWhere(
        (bill) => bill['id'] == id,
      );
      if (existingBillIndex != -1) {
        if (printcontroller.bills[existingBillIndex]['quantity'] > 1) {
          printcontroller.bills[existingBillIndex]['quantity']--;
          double price = double.parse(
            printcontroller.bills[existingBillIndex]['itemprice'].toString(),
          );
          printcontroller.bills[existingBillIndex]['amount'] =
              price * printcontroller.bills[existingBillIndex]['quantity'];
        } else {
          printcontroller.bills.removeAt(existingBillIndex);
        }
      }

      printcontroller.bills.refresh();
    }
  }

  Future<void> refreshDatabase() async {
    try {
      final user = await authservice.getaccount();
      final RowList rowlist = await dbservice
          .fetchdata(user.$id, ApiConfig().productmodel, [
            Query.equal('restaurantid', user.$id),
            Query.limit(100),
            Query.orderAsc('itemname'),
          ]);

      final freshdata = [];
      for (var row in rowlist.rows) {
        final item = Product.fromMap(row.data);

        final image = await storageservice.getfile(item.fileid);
        freshdata.add({
          'id': row.$id,
          'data': item.toMap(),
          'image': image,
          'quantity': item.quantity,
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

  Future<void> ondelete(String rowid, String itemname) async {
    try {
      await dbservice.deleteEntry(rowid, ApiConfig().productmodel);

      Get.snackbar(
        'Delete',
        "$itemname is deleted",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      refreshDatabase();
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void onClose() {
    namecontroller.dispose();
    pricecontroller.dispose();
    super.onClose();
  }
}
