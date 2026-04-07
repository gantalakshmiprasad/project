// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:firstproject/customs/config.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Storageservice extends GetxService {
  late final Client client;
  late final Storage storage;
  late final TablesDB table;
  Storageservice(this.client);
  @override
  void onInit() {
    super.onInit();

    storage = Storage(client);
    table = TablesDB(client);
  }

  Future<String> uploadFileWeb(Uint8List fileBytes, String fileName) async {
    try {
      final result = await storage.createFile(
        bucketId: ApiConfig().bucketId,

        fileId: ID.unique(),
        file: InputFile.fromBytes(bytes: fileBytes, filename: fileName),
      );
      return result.$id;
      // File ID for reference
    } catch (e) {
      throw Exception('Upload Error: ${e.toString()}');
    }
  }

  Future<Uint8List> urlToBytes(dynamic imageurl) async {
    try {
      final response = await http.get(Uri.parse(imageurl));
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

  Future<Uint8List> getfile(String fileId) async {
    try {
      final fileBytes = await storage.getFileDownload(
        bucketId: ApiConfig().bucketId,
        fileId: fileId,
      );
      return fileBytes;
    } catch (e) {
      print('Error in submit: $e');
      throw Exception('File retrieval error: ${e.toString()}');
    }
  }
}
