// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:get/get.dart';
import 'package:firstproject/customs/config.dart';
import 'package:firstproject/services/authservices.dart';

class CashfreeService {
  // Helper to get the Appwrite Functions service instance
  Functions get _functions => Get.find<AuthServices>().function;

  // Helper to fetch the configured function ID
  String get _functionId => ApiConfig().printfuntionid;

  /// 1. CREATE SUBSCRIPTION
  /// Returns a Map containing [subscription_id] and [subscription_session_id]
  Future<Map<String, dynamic>?> createSubscription({
    required String planId,
    required double amount,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
  }) async {
    try {
      final execution = await _functions.createExecution(
        functionId: _functionId,
        method: ExecutionMethod.pOST,
        body: jsonEncode({
          'action': 'CREATE_SUBSCRIPTION',
          'planId': planId,
          'amount': amount,
          'customerName': customerName,
          'customerEmail': customerEmail,
          'customerPhone': customerPhone,
        }),
      );

      if (execution.responseBody.isEmpty) {
        throw Exception("Appwrite returned a completely empty response body.");
      }

      final Map<String, dynamic> response = jsonDecode(execution.responseBody);

      // 🚀 THE FIX: Match the exact key ("success": "true") coming from your backend
      if (response['success'] == 'true' ||
          response['success'] == true ||
          response['status'] == 'success') {
        return response['result'] as Map<String, dynamic>;
      } else {
        final String serverMessage =
            response['message'] ??
            response['error']?['message'] ??
            'Failed to create subscription.';
        throw Exception(serverMessage);
      }
    } catch (e) {
      print("Error in createSubscription: $e");
      rethrow;
    }
  }

  /// 2. CANCEL SUBSCRIPTION
  /// Terminates the auto-debit process for a specific subscription ID
  Future<bool> cancelSubscription(String subscriptionId) async {
    try {
      final execution = await _functions.createExecution(
        functionId: _functionId,
        method: ExecutionMethod.pOST,
        body: jsonEncode({
          'action': 'CANCEL_SUBSCRIPTION',
          'subscriptionId': subscriptionId,
        }),
      );

      final Map<String, dynamic> response = jsonDecode(execution.responseBody);

      if (response['success'] == 'true') {
        return true;
      } else {
        throw Exception(
          response['error']?['message'] ?? 'Failed to cancel subscription.',
        );
      }
    } catch (e) {
      throw e.toString();
    }
  }

  /// 3. FETCH FULL DETAILS
  /// Returns the complete Cashfree subscription object map
  Future<Map<String, dynamic>?> fetchSubscriptionDetails(
    String subscriptionId,
  ) async {
    try {
      final execution = await _functions.createExecution(
        functionId: _functionId,
        method: ExecutionMethod.gET,
        body: jsonEncode({
          'action': 'FETCH_DETAILS',
          'subscriptionId': subscriptionId,
        }),
      );

      final Map<String, dynamic> response = jsonDecode(execution.responseBody);

      if (response['success'] == 'true') {
        return response['result'] as Map<String, dynamic>;
      } else {
        throw Exception(
          response['error']?['message'] ?? 'Failed to fetch details.',
        );
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  /// 4. GET STATUS ONLY
  /// Fast query that returns just the raw status string (e.g., 'ACTIVE', 'CANCELLED')
  Future<String> getSubscriptionStatus(String subscriptionId) async {
    try {
      final execution = await _functions.createExecution(
        functionId: _functionId,
        method: ExecutionMethod.gET,
        body: jsonEncode({
          'action': 'GET_STATUS',
          'subscriptionId': subscriptionId,
        }),
      );

      final Map<String, dynamic> response = jsonDecode(execution.responseBody);

      if (response['status'] == 'success') {
        return response['subscription_status'] ?? 'UNKNOWN';
      } else {
        throw Exception(
          response['error']?['message'] ?? 'Failed to get status.',
        );
      }
    } catch (e) {
      print("Error in getSubscriptionStatus: $e");
      return 'UNKNOWN';
    }
  }
}
