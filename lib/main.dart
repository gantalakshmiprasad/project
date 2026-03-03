import 'package:firstproject/authservices.dart';
import 'package:firstproject/view/signin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Get.putAsync<AuthServices>(() async => AuthServices());
  } catch (e) {
    print('Failed to initialize AuthServices: $e');
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
      home: LoginScreen(),
    );
  }
}
