// ignore_for_file: avoid_print, file_names

import 'dart:convert';
import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';
import 'package:firstproject/customs/config.dart';
import 'package:firstproject/model/itemModel.dart';
import 'package:firstproject/services/authservices.dart';
import 'package:firstproject/services/databaseservice.dart';
import 'package:firstproject/services/storageservice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Homepagecontroller extends GetxController {
  final service = Get.find<AuthServices>();
  final RxList database = [].obs;
  final RxList storedimages = [].obs;
  final RxBool addclicked = false.obs;
  final isloading = false.obs;

  final RxInt quantity = 0.obs;
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
    final userid = await authservice.getaccount();

    final RowList rowlist = await dbservice.fetchdata(userid.$id);
    for (var row in rowlist.rows) {
      final item = (Product(
        id: row.data['\$id'],
        itemname: row.data['itemname'],
        itemprice: row.data['itemprice'],
        userid: row.data['userid'],
        fileid: row.data['fileid'],
        isavailable: row.data['isavailable'],
      ));
      final image = await storageservice.getfile(item.fileid);
      storedimages.add({'fileid': item.fileid, 'image': image});

      database.add({'id': row.$id, 'data': item.toMap(), 'quantity': 0});
    }

    isloading.value = false;
    // If you want to bind to your observable list:
  }

  Future<void> submit(String promptText, String price) async {
    try {
      closedialog();
      isloading.value = true;

      final user = await authservice.getaccount(); //getting userid
      final fileid = await clicked(promptText); //getting fileid from function

      final product = Product(
        //this the product
        id: '', // leave empty, Appwrite will generate $id
        itemname: promptText,
        itemprice: price, // keep as string
        userid: user.$id,
        fileid: fileid,
        isavailable: true,
      );

      final created = await dbservice.createEntry(
        product.toMap(),
        ApiConfig().productmodel,
      ); //now the product is stored in db

      final newItem = Product.fromMap(created);
      final image = await storageservice.getfile(newItem.fileid);

      storedimages.add({'fileid': newItem.fileid, 'image': image});
      database.add({
        'id': created['\$id'],
        'data': newItem.toMap(),
        'quantity': 0,
      });
      database.refresh();
    } catch (e) {
      print('Error in homepagectl: $e');
      Exception(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<String> clicked(String promptText) async {
    //this is the function to generate an image,

    try {
      //1.It calls the function from the appwrite and returns json object,anything
      //output comes from the remote source is json
      final execution = await authservice.function.createExecution(
        functionId: ApiConfig().functionid,
        method: ExecutionMethod.pOST,

        body: '{"prompt":"$promptText"}',
      );

      final Map<String, dynamic> image = jsonDecode(execution.responseBody);

      //2.I passed the json data of image to upload in the appwrite storage
      final urltobytes = await storageservice.urlToBytes(image['result']);
      final fileid = await storageservice.uploadFileWeb(urltobytes, promptText);

      return fileid;
    } catch (e) {
      print(e.toString());
    }
    throw Exception();
  }

  Future<void> onedit(String rowid, bool isavailable, String itemname) async {
    if (rowid == 'No information') {
      print('No information about userid:$userid');
      return;
    }
    try {
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
      Get.snackbar(
        isavailable ? 'Sold out' : 'Available',
        isavailable ? '$itemname is Sold out' : '$itemname is available now',
        colorText: Colors.black,
        backgroundColor: isavailable ? Colors.red : Colors.green,
      );
    } catch (e) {
      throw Exception(e.toString());
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
        item['quantity'] = item['quantity'] + 1;
        database.refresh();
      }
    }
  }

  void decreasequantity(String id) async {
    for (var item in database) {
      if (item['id'] == id && item['quantity'] > 0) {
        item['quantity'] = item['quantity'] - 1;
        database.refresh();
      }
    }
  }

  @override
  void onClose() {
    namecontroller.dispose();
    pricecontroller.dispose();
    super.onClose();
  }
}
