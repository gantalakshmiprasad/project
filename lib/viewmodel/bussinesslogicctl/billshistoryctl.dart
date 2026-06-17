import 'package:appwrite/appwrite.dart';
import 'package:firstproject/customs/config.dart';
import 'package:firstproject/services/authservices.dart';
import 'package:firstproject/services/databaseservice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class PhysicalCalendarController extends GetxController {
  var calendarFormat = CalendarFormat.month.obs;
  var focusedDay = DateTime.now().obs;
  final Rx<DateTime> selectedDay = DateTime.now().obs;
  final Rx<DateTime> localStart = DateTime.now().obs;
  final Rx<DateTime> localEnd = DateTime.now().obs;
  var isBillsLoading = false.obs;
  final RxList billsList = [].obs;
  final RxBool ismobile = false.obs;
  final RxBool calenderclicked = false.obs;
  @override
  void onInit() {
    super.onInit();
    // Instantly fetch data corresponding to today's date when page instantiates
    _updateTimeBounds(DateTime.now());
    fetchBillsForSelectedDate();
  }

  // Getters that dynamically calculate the UTC ISO 8601 Strings for Appwrite filters
  String get utcStartIso => localStart.value.toUtc().toIso8601String();
  String get utcEndIso => localEnd.value.toUtc().toIso8601String();

  void _updateTimeBounds(DateTime targetDay) {
    localStart.value = DateTime(
      targetDay.year,
      targetDay.month,
      targetDay.day,
      0,
      0,
      0,
    );
    localEnd.value = DateTime(
      targetDay.year,
      targetDay.month,
      targetDay.day,
      23,
      59,
      59,
      999,
    );
  }

  Future<void> fetchBills() async {
    try {
      final user = await Get.find<AuthServices>().getaccount();

      final allItems = await Get.find<Databaseservice>().fetchdata(
        ApiConfig().billeditems,
        [Query.equal('restaurantid', user.$id)],
      );

      final allBills = await Get.find<Databaseservice>().fetchdata(
        ApiConfig().bill,
        [
          Query.equal('restaurantid', user.$id),
          Query.orderAsc('billnumber'),
          Query.limit(1000),
        ], // Show latest bills first
      );

      final temporaryList = [];

      for (var billRow in allBills.rows) {
        final List billItems = [];

        for (var itemRow in allItems.rows) {
          if (itemRow.data['billnumber'] == billRow.data['billnumber']) {
            billItems.add({
              'itemname': itemRow.data['itemname'],
              'itemprice': itemRow.data['itemprice'],
              'quantity': itemRow.data['quantity'],
              'restaurantid': itemRow.data['restaurantid'],
            });
          }
        }

        temporaryList.add({
          'rowid': billRow.$id,
          'billnumber': billRow.data['billnumber'],
          'totalamount': billRow.data['totalamount'],
          'items': billItems,
          'restaurantid': billRow.data['restaurantid'],
          'createdAt': billRow.$createdAt,
        });
      }

      billsList.assignAll(temporaryList);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> deleteallbills() async {
    final dbservice = Get.find<Databaseservice>();
    try {
      // 1. Create a "Batch" of deletions to avoid redundant fetching
      // We loop through the bills list once.
      for (var bill in billsList) {
        // 2. Fetch only the items linked to THIS specific bill
        final itemsToDelete = await dbservice.fetchdata(
          ApiConfig().billeditems,
          [Query.equal('restaurantid', bill['restaurantid'])],
        );

        // 3. Delete the children (items) first
        for (var row in itemsToDelete.rows) {
          await dbservice.deleteEntry(row.$id, ApiConfig().billeditems);
        }

        // 4. Delete the parent (the bill itself)
        await dbservice.deleteEntry(bill['rowid'], ApiConfig().bill);
      }

      // 5. Clear local state only after successful DB deletion
      billsList.clear();
      Get.snackbar(
        "Success",
        "All records cleared from database.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        maxWidth: 300,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Could not complete deletion.",
        snackPosition: SnackPosition.BOTTOM,
        maxWidth: 300,
      );
    } finally {
      Get.back();
    }
  }

  /// Master method executing range requests targeting Appwrite Backend Collections
  Future<void> fetchBillsForSelectedDate() async {
    try {
      calenderclicked.value = false;
      billsList.clear();
      isBillsLoading.value = true;

      // 1. Fetch authenticated user profile data
      final user = await Get.find<AuthServices>().getaccount();

      // 2. Fetch the flat child items matching the date constraints
      final allItems = await Get.find<Databaseservice>().fetchdata(
        ApiConfig().billeditems,
        [
          Query.equal('restaurantid', user.$id),
          Query.greaterThanEqual('\$createdAt', utcStartIso),
          Query.lessThanEqual('\$createdAt', utcEndIso),
          Query.orderDesc('\$createdAt'),
          Query.limit(
            5000,
          ), // Ensure large loops don't get truncated by default limits
        ],
      );

      // 3. Fetch the master parent bill rows matching the date constraints
      final allBills = await Get.find<Databaseservice>()
          .fetchdata(ApiConfig().bill, [
            Query.equal('restaurantid', user.$id),
            Query.greaterThanEqual('\$createdAt', utcStartIso),
            Query.lessThanEqual('\$createdAt', utcEndIso),
            Query.orderDesc('\$createdAt'),
            Query.limit(1000),
          ]);

      final Map<String, List<Map<String, dynamic>>> itemsGroupedByBill = {};

      for (var itemRow in allItems.rows) {
        final String? billNum = itemRow.data['billnumber']?.toString();
        if (billNum == null) continue;

        if (!itemsGroupedByBill.containsKey(billNum)) {
          itemsGroupedByBill[billNum] = [];
        }

        itemsGroupedByBill[billNum]!.add({
          'itemname': itemRow.data['itemname'],
          'itemprice': itemRow.data['itemprice'],
          'quantity': itemRow.data['quantity'],
          'restaurantid': itemRow.data['restaurantid'],
        });
      }

      final List<Map<String, dynamic>> temporaryList = [];

      // 4. Correlate datasets instantly using linear map lookups
      for (var billRow in allBills.rows) {
        final String billNum = billRow.data['billnumber']?.toString() ?? '';

        final List<Map<String, dynamic>> billItems =
            itemsGroupedByBill[billNum] ?? [];

        temporaryList.add({
          'rowid': billRow.$id,
          'billnumber': billRow.data['billnumber'],
          'totalamount': billRow.data['totalamount'],
          'items': billItems,
          'restaurantid': billRow.data['restaurantid'],
          'createdAt': billRow.$createdAt,
        });
      }

      billsList.assignAll(temporaryList);
    } catch (e) {
      Get.snackbar(
        "Fetch Failed",
        "Error accessing historical bills ledger data.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade800,
        colorText: Colors.white,
      );
      billsList.clear();
    } finally {
      isBillsLoading.value = false;
    }
  }

  Future<void> onDaySelected(DateTime selectDay, DateTime focusDay) async {
    selectedDay.value = selectDay;
    focusedDay.value = focusDay;

    _updateTimeBounds(selectDay);

    await fetchBillsForSelectedDate();
  }

  void onFormatChanged(CalendarFormat format) {
    if (calendarFormat.value != format) {
      calendarFormat.value = format;
    }
  }

  void onPageChanged(DateTime focusDay) {
    focusedDay.value = focusDay;
  }

  String get formattedSelectedDate {
    return "${selectedDay.value.day.toString().padLeft(2, '0')}-${selectedDay.value.month.toString().padLeft(2, '0')}-${selectedDay.value.year}";
  }
}
