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
  final RxString devicetype = ''.obs;
  final service = Get.find<AuthServices>();
  final RxList database = [].obs;
  final RxInt currentindex = 0.obs;
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
  final RxString message = ''.obs;

  final Databaseservice dbservice = Get.find<Databaseservice>();
  final AuthServices authservice = Get.find<AuthServices>();
  final Storageservice storageservice = Get.find<Storageservice>();

  /*-----------------------controllers---------------------------------*/
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController pricecontroller = TextEditingController();
  //----------------------------------------------------------------------
  var selectedCategory = 'Tiffins'.obs;
  var selectedFilterCategory = 'All items'.obs;

  // 2. Computed getter that filters the database reactively
  List get filteredDatabase {
    if (selectedFilterCategory.value == 'All items') {
      return database;
    }

    return database.where((item) {
      if (item['data'] == null) return false;

      // 1. Fallback check: Look for 'category' or 'itemcategory' keys
      final dynamic databaseCategory =
          item['data']['category'] ?? item['data']['itemcategory'];

      if (databaseCategory == null) {
        // If this prints, your items in the database don't have a category field saved yet!
        print(
          "⚠️ Warning: Item ${item['data']['itemname']} has no category field in DB.",
        );
        return false;
      }

      // 2. Clean both strings (lowercase & remove spaces) to ensure a perfect match
      String dbCategoryStr = databaseCategory.toString().trim().toLowerCase();
      String filterCategoryStr = selectedFilterCategory.value
          .trim()
          .toLowerCase();

      return dbCategoryStr == filterCategoryStr;
    }).toList();
  }

  // Your exact item category list
  final List<String> categories = [
    'Tiffins',
    'Non-veg Starter',
    'Main Course',
    'Veg-starters',
    'Cool drinks',
  ];
  // Update your submit method to accept the category string

  @override
  void onInit() async {
    super.onInit();
    update();

    refreshDatabase();
  }

  Future<void> submit(String promptText, String price) async {
    try {
      isitemsloading.value = true;
      closedialog();
      print(selectedCategory.value);
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
        category: selectedCategory.value,
      );

      await dbservice.createEntry(
        ID.unique(),
        product.toMap(),
        ApiConfig().productmodel,
      );
      database.add({
        'id': user.$id,
        'data': product.toMap(),
        'image': image,
        'quantity': product.quantity,
      });
      refreshDatabase();
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
        onCancel: () {},
        cancelTextColor: Colors.black,
      );
      for (var item in database) {
        if (item['id'] == id) {
          item['data']['isavailable'] = !isavailable;
          database.refresh();
          break;
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

  void increasequantity(String id) async {
    final user = await Get.find<AuthServices>().getaccount();
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
        'restaurantid': user.$id,
      };
      print(billEntry);
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
      isitemsloading.value = true;
      final user = await authservice.getaccount();
      final RowList rowlist = await dbservice.fetchdata(
        ApiConfig().productmodel,
        [
          Query.limit(100),
          Query.orderAsc('itemname'),
          Query.equal('userid', user.$id),
        ],
      );

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
      message.value = 'No items';
    } finally {
      database.refresh();

      isitemsloading.value = false;
    }
  }

  Future<void> ondelete(String rowid, String itemname) async {
    try {
      final data = await dbservice.getEntries(rowid, ApiConfig().productmodel);
      await Get.find<Storageservice>().deletefile(
        ApiConfig().bucketId,
        data['fileid'],
      );

      await dbservice.deleteEntry(rowid, ApiConfig().productmodel);

      Get.snackbar(
        'Delete',
        "$itemname is deleted",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        showProgressIndicator: true,
      );
      refreshDatabase();
    } catch (e) {
      throw e.toString();
    }
  }

  // Inside Homepagecontroller class

  Future<void> deleteAllItems(String tableid) async {
    try {
      isitemsloading.value = true;

      // Create a list of safe delete futures
      final deleteFutures = database.map((item) async {
        // 1. Guard against missing or null item IDs
        final String? itemId = item['id']?.toString();
        if (itemId == null) {
          print('Skipping item execution node: Missing valid database ID');
          return null;
        }

        // Fetch entry tracking documents safely
        final data = await dbservice.getEntries(
          itemId,
          ApiConfig().productmodel,
        );

        // 2. Guard against completely null database response structures
        if (data == null) {
          print(
            'Skipping storage sync: No schema payload found for ID $itemId',
          );
          await dbservice.deleteEntry(itemId, tableid);
          return null;
        }

        // 3. Extract the file identifier key safely
        final String? fileKey = data['fileid']?.toString();
        print('Current processed file key pointer: $fileKey');

        if (fileKey != null && item[fileKey] != null) {
          final String actualFileId = item[fileKey].toString();

          if (actualFileId.isNotEmpty) {
            try {
              // Execute file wipe out step inside a localized try-catch block
              await Get.find<Storageservice>().deletefile(
                ApiConfig().bucketId,
                actualFileId,
              );
            } catch (storageErr) {
              // Prevents a missing storage file from interrupting database drops
              print(
                'Storage file $actualFileId already purged or missing: $storageErr',
              );
            }
          }
        }

        // Final clean wipe of the database record row entry
        return dbservice.deleteEntry(itemId, tableid);
      }).toList();

      // Execute batch futures simultaneously in Appwrite engine
      await Future.wait(deleteFutures);

      // Clear local reactive memory data frames safely
      database.clear();

      // 4. Double check printcontroller instance validity
      // If printcontroller is an injected dependency, consider: Get.find<PrintController>().bills.clear();
      printcontroller.bills.clear();

      Get.snackbar(
        'Success',
        'All items deleted successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to execute global purge command: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isitemsloading.value = false;
    }
  }

  @override
  void onClose() {
    namecontroller.dispose();
    pricecontroller.dispose();
    super.onClose();
  }
}
