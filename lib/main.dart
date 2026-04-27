import 'package:appwrite/appwrite.dart';
import 'package:firstproject/services/authservices.dart';
import 'package:firstproject/services/databaseservice.dart';
import 'package:firstproject/services/storageservice.dart';
import 'package:firstproject/view/Authentication/forgotpassword.dart';
import 'package:firstproject/view/bussinesslogic/Homepage.dart';
import 'package:firstproject/view/Authentication/resetpassword.dart';
import 'package:firstproject/view/Authentication/signin.dart';
import 'package:firstproject/view/Authentication/signup.dart';
import 'package:firstproject/view/Authentication/verificationpage.dart';
import 'package:firstproject/view/bussinesslogic/billprintview.dart';
import 'package:firstproject/view/bussinesslogic/bills.dart';
import 'package:firstproject/view/bussinesslogic/introductionpage.dart';
import 'package:firstproject/view/bussinesslogic/paymentpage.dart';
import 'package:firstproject/view/bussinesslogic/profilepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'customs/config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final client = Client()
      .setEndpoint(ApiConfig().apiendpoint) // e.g. 'http://localhost/v1'
      .setProject(ApiConfig().projectid)
      .setDevKey(ApiConfig().devkey)
      .setSelfSigned(status: true);
  try {
    await Get.putAsync<AuthServices>(
      () async => AuthServices(client),
      permanent: true,
    );
    await Get.putAsync<Databaseservice>(
      () async => Databaseservice(client),
      permanent: true,
    );
    await Get.putAsync<Storageservice>(
      () async => Storageservice(client),
      permanent: true,
    );
  } catch (e) {
    throw Exception('Failed to initialize AuthServices: $e');
    // Continue anyway - AuthServices might fail on web but app should still work
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',

      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => Introductionpage()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/signup', page: () => Signup()),
        GetPage(name: '/homepage', page: () => Homepage()),
        GetPage(name: '/verificationpage', page: () => Verificationpage()),
        GetPage(name: '/forgotpassword', page: () => Forgotpassword()),
        GetPage(name: '/Resetpassword', page: () => Resetpassword()),
        GetPage(name: '/billshistory', page: () => Billshistory()),
        GetPage(name: '/profilepage', page: () => Profilepage()),
        GetPage(name: '/paymentpage', page: () => Paymentpage()),
      ],
    );
  }
}
