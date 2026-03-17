// ignore_for_file: avoid_print

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

import 'package:firstproject/customs/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';

class AuthServices extends GetxService {
  late final Client client;
  late final Account account;

  late final Functions function;

  @override
  void onInit() {
    super.onInit();
    try {
      client = Client()
          .setEndpoint(ApiConfig().apiendpoint) // e.g. 'http://localhost/v1'
          .setProject(ApiConfig().projectid);

      account = Account(client);
      print("client:${client.endPoint}");
      function = Functions(client);
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
      throw Exception(e.toString());
    }
  }

  Future<User> getaccount() async {
    try {
      final user = await account.get();
      return user;
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
}
