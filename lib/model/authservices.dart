import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:appwrite/models.dart' as models;
import 'package:firstproject/customs/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;

class AuthServices extends GetxService {
  late final Client client;
  late final Account account;
  late final Databases databases;
  late final Functions function;
  late final Storage storage;
  late final TablesDB table;

  @override
  void onInit() {
    super.onInit();
    try {
      client = Client()
          .setEndpoint(ApiConfig().apiendpoint) // e.g. 'http://localhost/v1'
          .setProject(ApiConfig().projectid); // your project ID

      account = Account(client);
      databases = Databases(client);
      function = Functions(client);
      storage = Storage(client);
      table = TablesDB(client);
    } catch (e) {
      throw Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      await account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      return true;
    } catch (e) {
      throw Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        showProgressIndicator: true,
        progressIndicatorBackgroundColor: Colors.red,
      );
    }
  }

  Future<void> signup(String name, String email, String password) async {
    try {
      await account.create(
        userId: ID.unique(),
        name: name,
        email: email,
        password: password,
      );
    } catch (e) {
      throw Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<bool> createemailverification(String url) async {
    try {
      await account.createEmailVerification(url: url);
      return true;
    } catch (e) {
      throw Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<bool> updateemailverification(String userId, String secret) async {
    try {
      await account.updateEmailVerification(userId: userId, secret: secret);
      return true;
    } catch (e) {
      throw Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<String> getaccount() async {
    try {
      final user = await account.get();
      return user.$id;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> sendForgotPasswordEmail(String email) async {
    try {
      // The URL should match your localhost:3030 setup from launch.json
      await account.createRecovery(
        email: email,
        url: 'http://localhost:3030/#/Resetpassword',
      );
      Get.snackbar("Success", "Check your email for the reset link!");
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<dynamic> changepassword(String email, String password) async {
    try {} catch (e) {
      throw Exception(e.toString());
    }
  }

  //form here Database methods starts
  /// 1. CREATE - Add a new document
  Future<Map<String, dynamic>?> createEntry(Map<String, String> data) async {
    try {
      final document = await table.createRow(
        databaseId: ApiConfig().databaseId,
        tableId: ApiConfig().collectionId,
        rowId: ID.unique(),
        data: data,
      );
      return document.data;
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

  /// 2. READ - List documents (with optional filters)
  Future<dynamic> getEntries(String rowId) async {
    try {
      final result = await table.getRow(
        databaseId: ApiConfig().databaseId,
        tableId: ApiConfig().collectionId,
        rowId: rowId,
        queries: [
          Query.orderDesc('\$createdAt'), // Get newest first
          Query.limit(25), // Standard pagination limit
        ],
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

  Future<String?> uploadFileWeb(
    Uint8List fileBytes,
    String fileName,
    String userid,
  ) async {
    try {
      final result = await storage.createFile(
        bucketId: ApiConfig().bucketId,

        fileId: ID.unique(),
        file: InputFile.fromBytes(bytes: fileBytes, filename: fileName),
      );
      return result.$id; // File ID for reference
    } on AppwriteException catch (e) {
      Exception('Upload Error: ${e.message}');
      return null;
    }
  }

  Future<Uint8List> urlToBytes(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes; // raw bytes of the image
      } else {
        throw Exception('failed');
      }
    } catch (e) {
      throw Exception('failed');
    }
  }

  /// 2. READ - Get File Metadata or List Files
  Future<models.FileList?> listAllFiles() async {
    try {
      return await storage.listFiles(bucketId: ApiConfig().bucketId);
    } catch (e) {
      Exception('List Error: $e');
      return null;
    }
  }

  /// 3. UPDATE - Update File Permissions/Name
  /// Note: You cannot update the actual binary content of a file;
  /// you must delete and re-upload to "change" the image.
  Future<File?> updateFileMetadata(String fileId, String newName) async {
    try {
      return await storage.updateFile(
        bucketId: ApiConfig().bucketId,
        fileId: fileId,
        name: newName,
      );
    } catch (e) {
      Exception('Update Error: $e');
      return null;
    }
  }

  /// 4. DELETE - Remove a File
  Future<bool> deleteFile(String fileId) async {
    try {
      await storage.deleteFile(bucketId: ApiConfig().bucketId, fileId: fileId);
      return true;
    } catch (e) {
      Exception('Delete Error: $e');
      return false;
    }
  }

  /// 5. EXTRA: Get Preview/Download URL
  /// This returns a URL you can use in Image.network()
  String getFilePreview(String fileId) {
    return storage
        .getFilePreview(
          bucketId: ApiConfig().bucketId,
          fileId: fileId,
          width: 300, // Optional transformation
          quality: 80,
        )
        .toString();
  }
}
