import 'package:appwrite/appwrite.dart';
import 'package:firstproject/customs/important.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';

class AuthServices extends GetxService {
  late final Client client;
  late final Account account;
  late final Databases databases;
  late final Functions function;

  @override
  void onInit() {
    super.onInit();
    try {
      client = Client()
          .setEndpoint(apiendpoint) // e.g. 'http://localhost/v1'
          .setProject(projectid); // your project ID

      account = Account(client);
      databases = Databases(client);
      function = Functions(client);
    } catch (e) {
      print('AuthServices initialization error: $e');
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
}
