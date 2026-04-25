// ignore_for_file: avoid_print

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:firstproject/customs/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Databaseservice extends GetxService {
  late final Client client;
  late final Databases databases;

  late final TablesDB table;
  Databaseservice(this.client);
  @override
  void onInit() {
    super.onInit();
    databases = Databases(client);
    table = TablesDB(client);
  }

  Future<Map<String, dynamic>> createEntry(
    String userid,
    Map<String, dynamic> data,
    String tableid,
  ) async {
    try {
      final document = await table.createRow(
        databaseId: ApiConfig().databaseId,
        tableId: tableid,
        rowId: userid,
        data: data,
      );

      return document.data;
    } on AppwriteException {
      // Re-throw as AppwriteException so the controller can catch the 409 code
      rethrow;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// 2. READ - List documents (with optional filters)
  Future<dynamic> getEntries(String rowId, String tableid) async {
    try {
      final result = await table.getRow(
        databaseId: ApiConfig().databaseId,
        tableId: tableid,
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
  Future<bool> deleteEntry(String rowId, String tableId) async {
    try {
      await table.deleteRow(
        databaseId: ApiConfig().databaseId,
        tableId: tableId,
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

  Future<RowList> fetchdata(
    String userId,
    String tableid,
    List<String> queries,
  ) async {
    try {
      final data = await table.listRows(
        databaseId: ApiConfig().databaseId,
        tableId: tableid,
        queries: queries,
      );
      return data;
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }
}
