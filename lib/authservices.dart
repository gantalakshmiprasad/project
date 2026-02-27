import 'package:appwrite/appwrite.dart';
import 'package:firstproject/important.dart';
import 'package:get/state_manager.dart';

class AuthServices extends GetxService {
  late final Client client;
  late final Account account;
  late final Databases databases;

  @override
  void onInit() {
    super.onInit();
    client = Client()
        .setEndpoint(apiendpoint) // e.g. 'http://localhost/v1'
        .setProject(projectid); // your project ID

    account = Account(client);
    databases = Databases(client);
  }

  Future<void> login(String email, String password) async {
    try {
      final session = await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      print('Login successful: $session');
    } catch (e) {
      print('Login failed: $e');
    }
  }
}
