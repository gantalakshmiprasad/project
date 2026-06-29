import 'package:appwrite/appwrite.dart';
import 'package:firstproject/customs/config.dart';
import 'package:firstproject/services/authservices.dart';
import 'package:firstproject/services/cashfree.dart';
import 'package:firstproject/services/databaseservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfsubscriptioncheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsubssession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:get/get.dart';

class CashfreeController extends GetxController {
  final RxBool isloading = false.obs;
  final RxBool subscriptionstatus = false.obs;
  final RxString subscriptionid = ''.obs;
  final RxString userid = ''.obs;
  final RxMap plandetails = RxMap();

  @override
  void onInit() async {
    super.onInit();
    await _initializeUserSubscription();
  }

  Future<void> _initializeUserSubscription() async {
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
            } catch (e) {
              subscriptionstatus.value =
                  row.data['subscriptionstatus'] ?? false;
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Init Error: $e");
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
        Get.offAllNamed('/homepage');
      } else {
        throw "Failed to generate session parameters.";
      }
    } catch (e) {
      isloading.value = false;
      Get.snackbar(
        'Error',
        'Payment failed: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void launchCheckout(String subscriptionSessionId, String subscriptionId) {
    try {
      var session = CFSubscriptionSessionBuilder()
          .setEnvironment(
            CFEnvironment.SANDBOX,
          ) // Change to PRODUCTION for live
          .setSubscriptionId(subscriptionId)
          .setSubscriptionSessionId(subscriptionSessionId)
          .build();

      var payment = CFSubscriptionPaymentBuilder().setSession(session).build();

      isloading.value = false;
      CFPaymentGatewayService().doPayment(payment);
    } catch (e) {
      isloading.value = false;
      Get.snackbar(
        "SDK Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> fetchsubscription(dynamic id) async {
    if (id == null || id.toString().isEmpty) return;
    try {
      final details = await CashfreeService().fetchSubscriptionDetails(id);
      if (details != null && details.isNotEmpty) {
        plandetails.value = details;
        if (details['subscription_status'] == 'ACTIVE') {
          subscriptionstatus.value = true;
          await Get.find<Databaseservice>().updateEntry(userid.value, {
            "subscriptionstatus": true,
          }, ApiConfig().collectionId);
        }
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
        'Subscription cancelled.',
        backgroundColor: Colors.green,
      );
      Get.offAllNamed('/homepage');
    } catch (e) {
      isloading.value = false;
    }
  }
}
