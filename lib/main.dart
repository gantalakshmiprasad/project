// ignore_for_file: avoid_print

import 'package:appwrite/appwrite.dart';
import 'package:firstproject/services/authservices.dart';
import 'package:firstproject/services/databaseservice.dart';
import 'package:firstproject/services/storageservice.dart';
import 'package:firstproject/view/Authentication/forgotpassword.dart';
import 'package:firstproject/view/analytics/analytics.dart';
import 'package:firstproject/view/bussinesslogic/Homepage.dart';
import 'package:firstproject/view/Authentication/resetpassword.dart';
import 'package:firstproject/view/Authentication/signin.dart';
import 'package:firstproject/view/Authentication/signup.dart';
import 'package:firstproject/view/Authentication/verificationpage.dart';
import 'package:firstproject/view/bussinesslogic/billprintview.dart';
import 'package:firstproject/view/bussinesslogic/introductionpage.dart';
import 'package:firstproject/view/bussinesslogic/paymentpage.dart';
import 'package:firstproject/view/bussinesslogic/paymentstatus.dart';
import 'package:firstproject/view/bussinesslogic/print.dart';
import 'package:firstproject/view/bussinesslogic/profilepage.dart';
import 'package:firstproject/viewmodel/bussinesslogicctl/Homepagecontroller.dart';
import 'package:firstproject/viewmodel/bussinesslogicctl/themecontroller.dart';
import 'package:firstproject/viewmodel/bussinesslogicctl/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'customs/config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize theme configuration immediately
  Get.put(ThemeController(), permanent: true);

  // 2. Set up Appwrite base configuration client
  final client = Client()
      .setEndpoint(ApiConfig().apiendpoint)
      .setProject(ApiConfig().projectid)
      .setDevKey(ApiConfig().devkey)
      .setSelfSigned(status: true);

  // 3. STEP 1: Core infrastructure services MUST register first
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
    print('Failed to initialize Services: $e');
  }

  // 4. STEP 2: Register lazy controllers safely
  Get.lazyPut(() => Paymentstatuscontroller());
  Get.lazyPut(() => Homepagecontroller());

  // 5. STEP 3: Initialize user details controller
  // Now this can safely run Get.find<AuthServices>() inside its onInit() hook!
  Get.put(Getuserdetailsctl());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = Get.find<ThemeController>();

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: const Color(0xFFF8FAFC),
          cardColor: Colors.white,
          primaryColor: const Color(0xFF0F766E),
        ),
        darkTheme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF0B1517),
          cardColor: const Color(0xFF0F262A),
          primaryColor: const Color(0xFF2DD4BF),
        ),
        title: 'UBS Billing System',
        themeMode: themeCtrl.themeMode.value,
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => Introductionpage()),
          GetPage(name: '/login', page: () => LoginScreen()),
          GetPage(name: '/signup', page: () => Signup()),
          GetPage(name: '/homepage', page: () => Homepage()),
          GetPage(name: '/verificationpage', page: () => Verificationpage()),
          GetPage(name: '/forgotpassword', page: () => Forgotpassword()),
          GetPage(name: '/Resetpassword', page: () => Resetpassword()),
          GetPage(
            name: '/billshistory',
            page: () => PhysicalGetxCalendarPage(),
          ),
          GetPage(name: '/profilepage', page: () => Profilepage()),
          GetPage(name: '/paymentpage', page: () => Paymentpage()),
          GetPage(name: '/printpage', page: () => Printitems()),
          GetPage(name: '/paymentstatus', page: () => Paymentstatus()),
          GetPage(name: '/analytics', page: () => Analytics()),
        ],
      ),
    );
  }
}
