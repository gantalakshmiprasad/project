import 'package:firstproject/model/authservices.dart';
import 'package:firstproject/view/Authentication/forgotpassword.dart';
import 'package:firstproject/view/bussinesslogic/Homepage.dart';
import 'package:firstproject/view/Authentication/resetpassword.dart';
import 'package:firstproject/view/Authentication/signin.dart';
import 'package:firstproject/view/Authentication/signup.dart';
import 'package:firstproject/view/Authentication/verificationpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Get.putAsync<AuthServices>(() async => AuthServices());
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
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),

      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => LoginScreen()),
        GetPage(name: '/signup', page: () => Signup()),
        GetPage(name: '/homepage', page: () => Homepage()),
        GetPage(name: '/verificationpage', page: () => Verificationpage()),
        GetPage(name: '/forgotpassword', page: () => Forgotpassword()),
        GetPage(name: '/Resetpassword', page: () => Resetpassword()),
      ],
    );
  }
}
