import 'package:appwrite/appwrite.dart';
import 'package:firstproject/customs/config.dart';
import 'package:firstproject/services/authservices.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Databaseservice extends GetxService {
  late final Databases databases;

  late final TablesDB table;
  @override
  void onInit() {
    super.onInit();
    final client = Get.find<AuthServices>().client;
    databases = Databases(client);

    table = TablesDB(client);
  }

  Future<Map<String, dynamic>?> createEntry(Map<String, dynamic> data) async {
    try {
      print(data);
      final document = await table.createRow(
        databaseId: ApiConfig().databaseId,
        tableId: ApiConfig().collectionId,
        rowId: ID.unique(),
        data: data,
      );
      return document.data;
    } on AppwriteException catch (e) {
      Exception(e.message);
      return null;
    }
  }

  /// 2. READ - List documents (with optional filters)
  Future<dynamic> getEntries(String rowId) async {
    try {
      final result = await table.getRow(
        databaseId: ApiConfig().databaseId,
        tableId: ApiConfig().productmodel,
        rowId: rowId,
      );

      return result.data;
    } on AppwriteException catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }
  }

  /// 3. UPDATE - Modify an existing document
  Future<dynamic> updateEntry(
    String rowId,
    Map<String, dynamic> updatedData,
  ) async {
    try {
      final document = await table.updateRow(
        databaseId: ApiConfig().databaseId,
        tableId: ApiConfig().collectionId,
        rowId: rowId,
        data: updatedData,
      );
      return document;
    } on AppwriteException catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }
  }

  /// 4. DELETE - Remove a document
  Future<bool> deleteEntry(String rowId) async {
    try {
      await table.deleteRow(
        databaseId: ApiConfig().databaseId,
        tableId: ApiConfig().collectionId,
        rowId: rowId,
      );
      return true;
    } on AppwriteException catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  Future<dynamic> fetchdata(String userId) async {
    try {
      final data = await databases.listTransactions(
        queries: [Query.equal('userid', userId)],
      );
      return data;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
