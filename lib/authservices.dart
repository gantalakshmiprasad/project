import 'package:appwrite/appwrite.dart';
import 'package:firstproject/important.dart';
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

  Future<void> login() async {
    try {
      final session = await account.createEmailPasswordSession(
        email: 'chuchu.aadhavan@gmail.com',
        password: '12345678',
      );
      print('Login successful: $session');
    } catch (e) {
      print('Login failed: $e');
    }
  }
}
