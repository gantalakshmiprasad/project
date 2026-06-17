import 'package:appwrite/appwrite.dart';
import 'package:firstproject/customs/config.dart';
import 'package:firstproject/services/authservices.dart';
import 'package:firstproject/services/cashfree.dart';
import 'package:firstproject/services/databaseservice.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfsubscriptioncheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsubssession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:get/get.dart';
import 'dart:js_interop';

// 🚀 Maps directly to the global window function inside your web/index.html
@JS('launchCashfreeSubscription')
external void launchCashfreeSubscription(
  JSString sessionId,
  JSFunction onError,
);

class CashfreeController extends GetxController {
  final RxBool isloading = false.obs;
  final RxBool subscriptionstatus = false.obs;
  final RxString subscriptionid = ''.obs;
  final RxString userid = ''.obs;
  final RxMap plandetails = RxMap();

  @override
  void onInit() async {
    super.onInit();
    try {
      isloading.value = true;
      final user = await Get.find<AuthServices>().getaccount();
      userid.value = user.$id;

      final response = await Get.find<Databaseservice>().fetchdata(
        ApiConfig().collectionId,
        [Query.contains('\$id', user.$id)],
      );

      for (var row in response.rows) {
        if (row.$id == user.$id) {
          final String? dynamicSubId = row.data['subscriptionid'];

          if (dynamicSubId != null && dynamicSubId.isNotEmpty) {
            try {
              await fetchsubscription(dynamicSubId);
            } catch (networkError) {
              subscriptionstatus.value =
                  row.data['subscriptionstatus'] ?? false;
              Get.snackbar(
                'Sync Warning',
                'Could not reach payment gateway. Showing offline status.',
                snackPosition: SnackPosition.BOTTOM,
                maxWidth: 400,
              );
            }
          } else {
            subscriptionstatus.value = row.data['subscriptionstatus'] ?? false;
          }
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Initialization failed: $e',
        snackPosition: SnackPosition.BOTTOM,
        maxWidth: 300,
      );
    } finally {
      isloading.value = false;
    }
  }

  Future<void> initiatePayment(String amount) async {
    try {
      isloading.value = true;
      final result = await CashfreeService().createSubscription(
        planId: 'monthlyplan',
        amount: double.parse(amount),
        customerName: 'lucky',
        customerEmail: 'test123@gmail.com',
        customerPhone: '9154686754',
      );

      if (result != null && result['subscription_status'] == 'INITIALIZED') {
        String sessionId = result['subscription_session_id'];
        String subId = result['subscription_id'];
        subscriptionid.value = subId;

        await Get.find<Databaseservice>().updateEntry(userid.value, {
          "subscriptionid": subId,
        }, ApiConfig().collectionId);

        launchCheckout(sessionId, subId);

        // ✨ FEATURE: Redirects the base screen context back to homepage instantly
        // while payment UI finishes on top layer.
        Get.offAllNamed('/homepage');
      } else {
        isloading.value = false;
        Get.snackbar(
          'Error',
          'Failed to generate session parameters from Cashfree.',
          snackPosition: SnackPosition.BOTTOM,
          maxWidth: 300,
        );
      }
    } catch (e) {
      isloading.value = false;
      Get.snackbar(
        'Error',
        'Payment initialization failed: $e',
        snackPosition: SnackPosition.BOTTOM,
        maxWidth: 300,
      );
    }
  }

  void launchCheckout(String subscriptionSessionId, String subscriptionId) {
    if (kIsWeb) {
      try {
        final JSFunction errorCallback = ((JSString jsErrorMessage) {
          _handleJavaScriptFailure(jsErrorMessage.toDart);
        }).toJS;

        launchCashfreeSubscription(subscriptionSessionId.toJS, errorCallback);
        isloading.value = false;
      } catch (dartException) {
        isloading.value = false;
        Get.snackbar(
          "Context Error",
          "Failed to build window frame: $dartException",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      try {
        var session = CFSubscriptionSessionBuilder()
            .setEnvironment(CFEnvironment.SANDBOX)
            .setSubscriptionId(subscriptionId)
            .setSubscriptionSessionId(subscriptionSessionId)
            .build();

        var payment = CFSubscriptionPaymentBuilder()
            .setSession(session)
            .build();

        isloading.value = false;
        CFPaymentGatewayService().doPayment(payment);
      } catch (e) {
        isloading.value = false;
        Get.snackbar(
          "SDK Error",
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          maxWidth: 300,
        );
      }
    }
  }

  void _handleJavaScriptFailure(String message) {
    isloading.value = false;
    Get.snackbar(
      "Gateway Error",
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
    );
  }

  Future<void> fetchsubscription(dynamic id) async {
    if (id == null || id.toString().isEmpty) return;

    try {
      final details = await CashfreeService().fetchSubscriptionDetails(id);

      if (details == null || details.isEmpty) {
        throw 'Empty or invalid response object signature.';
      }

      plandetails.value = details;

      if (details['subscription_status'] == 'ACTIVE') {
        subscriptionstatus.value = true;
        await Get.find<Databaseservice>().updateEntry(userid.value, {
          "subscriptionstatus": true,
        }, ApiConfig().collectionId);
      } else if (details['subscription_status'] == 'CANCELLED') {
        subscriptionstatus.value = false;
        await Get.find<Databaseservice>().updateEntry(userid.value, {
          "subscriptionid": null,
          "subscriptionstatus": false,
        }, ApiConfig().collectionId);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelsubscription(dynamic id) async {
    if (id == null || id.toString().isEmpty) return;

    try {
      isloading.value = true;
      await CashfreeService().cancelSubscription(id);
      await Get.find<Databaseservice>().updateEntry(userid.value, {
        "subscriptionid": null,
        "subscriptionstatus": false,
      }, ApiConfig().collectionId);

      subscriptionstatus.value = false;
      subscriptionid.value = '';
      plandetails.clear();
      isloading.value = false;
      Get.snackbar(
        'Success',
        'Subscription cancelled successfully.',

        backgroundColor: Colors.green,
        colorText: Colors.black,
      );
      Get.offAllNamed('/homepage');
    } catch (e) {
      isloading.value = false;
    }
  }
}
