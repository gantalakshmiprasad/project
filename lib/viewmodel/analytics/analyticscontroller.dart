import 'package:appwrite/appwrite.dart';
import 'package:firstproject/services/authservices.dart';
import 'package:firstproject/services/databaseservice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appwrite/models.dart';
import 'package:firstproject/customs/config.dart';

class Analyticscontroller extends GetxController {
  final Databaseservice _dbService = Get.find<Databaseservice>();

  final RxList billitems = [].obs;
  // Reactive variables
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> allTransactions =
      <Map<String, dynamic>>[].obs;

  // 1. Reactive calculation filtering records by matching selected local date
  List<Map<String, dynamic>> get filteredTransactions {
    return allTransactions.where((tx) {
      final rawDate = tx['\$createdAt'] ?? tx['createdAt'];
      if (rawDate == null) return false;

      try {
        // CRITICAL FIX: Convert UTC database timestamp string to matching phone local time
        DateTime txDate = DateTime.parse(rawDate.toString()).toLocal();

        return txDate.year == selectedDate.value.year &&
            txDate.month == selectedDate.value.month &&
            txDate.day == selectedDate.value.day;
      } catch (e) {
        return false;
      }
    }).toList();
  }

  // 2. Compute total financial revenue from filtered dates using lowercase 'totalamount'
  double get dailyTotalAmount {
    return filteredTransactions.fold(0.0, (sum, tx) {
      final amtValue = tx['totalamount'] ?? tx['totalAmount'] ?? 0;
      return sum + (double.tryParse(amtValue.toString()) ?? 0.0);
    });
  }

  @override
  void onInit() {
    super.onInit();
    fetchTransactionsFromBackend();
  }

  /// Pulls the collections from Appwrite backend
  Future<void> fetchTransactionsFromBackend() async {
    try {
      isLoading.value = true;
      final user = await Get.find<AuthServices>().getaccount();
      String targetTableId = ApiConfig().bill;
      RowList records = await _dbService.fetchdata(targetTableId, [
        Query.equal('restaurantid', user.$id),
      ]);

      List<Map<String, dynamic>> parsedRows = records.rows.map((row) {
        Map<String, dynamic> combinedMap = {};
        combinedMap.addAll(row.data);
        combinedMap['\$createdAt'] = row.$createdAt;
        combinedMap['\$id'] = row.$id;

        return combinedMap;
      }).toList();

      allTransactions.assignAll(parsedRows);

      // CRITICAL FIX: Auto-focus the dashboard onto the latest available record date
      // instead of initializing to an empty screen on a day with no sales.
      if (allTransactions.isNotEmpty) {
        DateTime latestAvailableDate = DateTime(2000);
        for (var tx in allTransactions) {
          final rawDate = tx['\$createdAt'] ?? tx['createdAt'];
          if (rawDate != null) {
            try {
              DateTime parsed = DateTime.parse(rawDate.toString()).toLocal();
              if (parsed.isAfter(latestAvailableDate)) {
                latestAvailableDate = parsed;
              }
            } catch (_) {}
          }
        }
        // If a valid historical date was recovered, focus dashboard there
        if (latestAvailableDate.year > 2000) {
          selectedDate.value = latestAvailableDate;
        }
      }
    } catch (e) {
      Get.snackbar(
        'Database Sync Error',
        'Could not stream transactional tables: ${e.toString()}',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Calendar manual target override selection
  Future<void> selectCalendarDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  void triggerDailyReportPrint() {
    if (filteredTransactions.isEmpty) {
      Get.snackbar(
        'Print Request Failed',
        'No operations logged for this calendar index.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }
    Get.snackbar(
      'Print Pipeline Active',
      'Sending Daily Ledger Manifest summary to receipt compilation engine...',
      backgroundColor: const Color(0xFF0D9488),
      colorText: Colors.white,
      icon: const Icon(Icons.print, color: Colors.white),
    );
  }
}
