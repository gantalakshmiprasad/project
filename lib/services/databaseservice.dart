// ignore_for_file: avoid_print

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
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

  Future<Map<String, dynamic>> createEntry(
    Map<String, dynamic> data,
    String tableid,
  ) async {
    try {
      final document = await table.createRow(
        databaseId: ApiConfig().databaseId,
        tableId: tableid,
        rowId: ID.unique(),
        data: data,
      );

      return document.data;
    } on AppwriteException catch (e) {
      throw Exception(e.message);
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
    String tableid,
  ) async {
    try {
      final document = await table.updateRow(
        databaseId: ApiConfig().databaseId,
        tableId: tableid,
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

  Future<RowList> fetchdata(String userId, String tableid) async {
    try {
      final data = await table.listRows(
        databaseId: ApiConfig().databaseId,
        tableId: tableid,
        queries: [
          Query.equal('userid', [userId]),
          Query.limit(100),
          Query.orderDesc('\$createdAt'),
        ],
      );
      return data;
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }
}
