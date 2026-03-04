import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:appwrite/models.dart' as models;
import 'package:firstproject/customs/config.dart';
import 'package:firstproject/customs/important.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';

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
      Exception('AuthServices initialization error: $e');
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      Get.snackbar('Success', 'Login successfully');
    } catch (e) {
      Get.snackbar('Failure', e.toString());
      throw Exception(e.toString());
    }
  }

  Future<void> signup(String email, String password) async {
    try {
      await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );
      await account.createEmailVerification(url: '');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> createemailverification(String url) async {
    try {
      await account.createEmailVerification(url: url);
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> updateemailverification(String userId, String secret) async {
    try {
      await account.updateEmailVerification(userId: userId, secret: secret);
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> getaccount() async {
    try {
      await account.get();
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> forgotpassword(
    String userId,
    String secret,
    String password,
  ) async {
    try {
      await account.createEmailVerification(url: '');
      final verified = await updateemailverification(userId, secret);
      if (verified) {
        await account.updatePassword(password: password);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //form here Database methods starts
  /// 1. CREATE - Add a new document
  Future<Map<String, dynamic>?> createEntry(Map<String, dynamic> data) async {
    try {
      final document = await table.createRow(
        databaseId: ApiConfig().databaseId,
        tableId: ApiConfig().collectionId,
        rowId: ID.unique(),
        data: data,
      );
      return document.data;
    } on AppwriteException catch (e) {
      Exception('Create Error: ${e.message}');
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
      Exception('Read Error: ${e.message}');
      return null;
    }
  }

  /// 3. UPDATE - Modify an existing document
  Future<Row?> updateEntry(
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
      Exception('Update Error: ${e.message}');
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
      Exception('Delete Error: ${e.message}');
      return false;
    }
  }
}

class StorageService {
  final Storage _storage;
  static const String bucketId = 'YOUR_BUCKET_ID';

  StorageService(Client client) : _storage = Storage(client);

  /// 1. CREATE - Upload a File
  /// For Mobile/Desktop: use InputFile.fromPath
  /// For Web: use InputFile.fromBytes
  Future<models.File?> uploadFile(String filePath, String fileName) async {
    try {
      final result = await _storage.createFile(
        bucketId: bucketId,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: filePath, filename: fileName),
      );
      return result;
    } on AppwriteException catch (e) {
      Exception('Upload Error: ${e.message}');
      return null;
    }
  }

  /// 2. READ - Get File Metadata or List Files
  Future<models.FileList?> listAllFiles() async {
    try {
      return await _storage.listFiles(bucketId: bucketId);
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
      return await _storage.updateFile(
        bucketId: bucketId,
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
      await _storage.deleteFile(bucketId: bucketId, fileId: fileId);
      return true;
    } catch (e) {
      Exception('Delete Error: $e');
      return false;
    }
  }

  /// 5. EXTRA: Get Preview/Download URL
  /// This returns a URL you can use in Image.network()
  String getFilePreview(String fileId) {
    return _storage
        .getFilePreview(
          bucketId: bucketId,
          fileId: fileId,
          width: 300, // Optional transformation
          quality: 80,
        )
        .toString();
  }
}
