import 'package:firstproject/viewmodel/bussinesslogicctl/billshistoryctl.dart';
import 'package:firstproject/viewmodel/bussinesslogicctl/themecontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:table_calendar/table_calendar.dart';

class PhysicalGetxCalendarPage extends StatelessWidget {
  const PhysicalGetxCalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PhysicalCalendarController());
    final themeCtrl = Get.find<ThemeController>();

    return Obx(() {
      final isDark = themeCtrl.isDark;
      return Scaffold(
        backgroundColor: isDark
            ? const Color(0xFF0B1517)
            : const Color(0xFFF8FAFC),
        appBar: Get.width > 900
            ? AppBar(
                backgroundColor: Get.isDarkMode
                    ? const Color(0xFF0F262A)
                    : Colors.white,
                elevation: 0,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1),
                  child: Container(
                    color: Get.isDarkMode
                        ? const Color(0xFF1E4D55)
                        : Colors.grey.shade200,
                    height: 1,
                  ),
                ),
                title: Text(
                  "Bill History Ledger",
                  style: TextStyle(
                    color: Get.isDarkMode
                        ? Colors.white
                        : const Color(0xFF1E293B),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                foregroundColor: Get.isDarkMode
                    ? Colors.white
                    : const Color(0xFF1E293B),
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: Get.isDarkMode
                        ? Colors.white70
                        : const Color(0xFF64748B),
                  ),
                  onPressed: () => Get.toNamed('/homepage'),
                ),
                actionsPadding: const EdgeInsets.only(right: 24),
                actions: [
                  IconButton(
                    tooltip: 'All bills',
                    onPressed: () {
                      Get.showOverlay(
                        asyncFunction: () => controller.fetchBills(),
                        loadingWidget: Center(
                          child: SizedBox(
                            height: 120,
                            width: 120,
                            child: Lottie.asset(
                              'assets/animations/loading.json',
                            ),
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.list_alt_rounded,
                      color: Get.isDarkMode
                          ? const Color(0xFF2DD4BF)
                          : const Color(0xFF0D9488),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Purge Ledger Window',
                    onPressed: () {
                      Get.defaultDialog(
                        backgroundColor: Get.isDarkMode
                            ? const Color(0xFF0F262A)
                            : Colors.white,
                        title: "Clear Ledger Window?",
                        titleStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFB7185),
                          fontSize: 18,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        content: Text(
                          'Do you want to permanently delete all bills for this targeted date window? This statement cannot be reversed.',
                          style: TextStyle(
                            color: Get.isDarkMode
                                ? Colors.white70
                                : const Color(0xFF64748B),
                            fontSize: 14,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        textConfirm: "Purge All",
                        textCancel: "Abort",
                        confirmTextColor: Colors.white,
                        cancelTextColor: Get.isDarkMode
                            ? Colors.white70
                            : const Color(0xFF1E293B),
                        buttonColor: const Color(0xFFFB7185),
                        onConfirm: () {
                          Get.showOverlay(
                            asyncFunction: () => controller.deleteallbills(),
                            loadingWidget: Center(
                              child: SizedBox(
                                height: 120,
                                width: 120,
                                child: Lottie.asset(
                                  'assets/animations/loading.json',
                                ),
                              ),
                            ),
                          );
                          Get.back();
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.delete_sweep_outlined,
                      color: Color(0xFFFB7185),
                    ),
                  ),
                ],
              )
            : null,
        body: Center(
          child: Get.width > 900
              ? Row(
                  children: [
                    listitems(controller),
                    Container(
                      width: 1,
                      color: Get.isDarkMode
                          ? const Color(0xFF1E4D55)
                          : Colors.grey.shade200,
                    ),
                    calender(controller),
                  ],
                )
              : Stack(
                  children: [
                    Obx(() {
                      if (controller.calenderclicked.value) {
                        return SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: calender(controller),
                        );
                      } else {
                        return listitems(controller);
                      }
                    }),
                  ],
                ),
        ),
      );
    });
  }
}

Widget calender(PhysicalCalendarController controller) {
  final isDark = Get.isDarkMode;
  Color activeAccent = isDark
      ? const Color(0xFF2DD4BF)
      : const Color(0xFF0D9488);
  Color priceColor = isDark ? const Color(0xFFF59E0B) : const Color(0xFFD97706);

  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: Container(
      width: 460,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F262A) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF1E4D55) : Colors.grey.shade200,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black38 : Colors.grey.shade200,
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(height: 6, color: activeAccent),
            Obx(
              () => TableCalendar(
                firstDay: DateTime.utc(2025, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: controller.focusedDay.value,
                calendarFormat: controller.calendarFormat.value,
                selectedDayPredicate: (day) =>
                    isSameDay(controller.selectedDay.value, day),

                onDaySelected: controller.onDaySelected,
                onFormatChanged: controller.onFormatChanged,
                onPageChanged: controller.onPageChanged,

                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                  leftChevronIcon: Icon(
                    Icons.chevron_left_rounded,
                    color: isDark ? Colors.white70 : const Color(0xFF64748B),
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right_rounded,
                    color: isDark ? Colors.white70 : const Color(0xFF64748B),
                  ),
                  titleTextStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF070E10)
                        : const Color(0xFFF8FAFC),
                    border: Border(
                      bottom: BorderSide(
                        color: isDark
                            ? const Color(0xFF1E4D55)
                            : Colors.grey.shade200,
                      ),
                    ),
                  ),
                ),

                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    color: isDark ? Colors.white60 : const Color(0xFF64748B),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  weekendStyle: const TextStyle(
                    color: Color(0xFFFB7185),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),

                calendarStyle: CalendarStyle(
                  tableBorder: TableBorder(
                    horizontalInside: BorderSide(
                      color: isDark
                          ? const Color(0xFF1E4D55)
                          : Colors.grey.shade100,
                      width: 1,
                    ),
                  ),
                  defaultTextStyle: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                    fontWeight: FontWeight.bold,
                  ),
                  weekendTextStyle: const TextStyle(
                    color: Color(0xFFFB7185),
                    fontWeight: FontWeight.bold,
                  ),
                  outsideDaysVisible: true,
                  outsideTextStyle: TextStyle(
                    color: isDark ? Colors.white24 : Colors.grey.shade300,
                  ),

                  defaultDecoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                  ),
                  weekendDecoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                  ),
                  outsideDecoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                  ),

                  todayDecoration: BoxDecoration(
                    border: Border.all(color: priceColor, width: 1.5),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  selectedDecoration: BoxDecoration(
                    color: activeAccent,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  selectedTextStyle: TextStyle(
                    color: isDark ? const Color(0xFF0B1517) : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Divider(
              height: 1,
              color: isDark ? const Color(0xFF1E4D55) : Colors.grey.shade200,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Selected Range Target:",
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white38 : const Color(0xFF64748B),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Obx(
                    () => Text(
                      controller.formattedSelectedDate,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: activeAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget listitems(PhysicalCalendarController controller) {
  final isDark = Get.isDarkMode;
  Color activeAccent = isDark
      ? const Color(0xFF2DD4BF)
      : const Color(0xFF0D9488);
  Color priceColor = isDark ? const Color(0xFFF59E0B) : const Color(0xFFD97706);

  return Expanded(
    child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long_rounded, color: activeAccent, size: 26),
              const SizedBox(width: 12),
              Text(
                "Invoices Filed",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
              const Spacer(),
              if (Get.width <= 900)
                IconButton(
                  onPressed: () {
                    controller.calenderclicked.value = true;
                  },
                  icon: Icon(Icons.calendar_month_rounded, color: activeAccent),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Obx(() {
              if (controller.isBillsLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(activeAccent),
                  ),
                );
              }

              if (controller.billsList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.folder_open_rounded,
                        size: 64,
                        color: isDark ? Colors.white24 : Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No bills registry located for ${controller.formattedSelectedDate}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isDark
                              ? Colors.white38
                              : const Color(0xFF64748B),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: controller.billsList.length,
                itemBuilder: (context, index) {
                  final Map<String, dynamic> billItem = controller
                      .billsList[controller.billsList.length - index - 1];

                  String billNumber =
                      billItem['billnumber']?.toString() ?? 'N/A';
                  String totalAmount =
                      billItem['totalamount']?.toString() ?? '0.00';
                  List billItemsList = billItem['items'] ?? [];
                  String createdat = billItem['createdAt'] ?? '';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F262A) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF1E4D55)
                            : Colors.grey.shade200,
                        width: 1.2,
                      ),
                      boxShadow: isDark
                          ? null
                          : [
                              BoxShadow(
                                color: Colors.black38,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        collapsedIconColor: isDark
                            ? Colors.white60
                            : const Color(0xFF64748B),
                        iconColor: activeAccent,
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF0B1517)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.receipt_rounded,
                            color: activeAccent,
                            size: 22,
                          ),
                        ),
                        title: Text(
                          "Bill #$billNumber",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1E293B),
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            "Timestamp: $createdat",
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white38
                                  : const Color(0xFF64748B),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        trailing: Text(
                          "₹$totalAmount",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: priceColor,
                          ),
                        ),
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF14353B)
                                  : const Color(0xFFF8FAFC),
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(14),
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                ...billItemsList.map((item) {
                                  String itemName =
                                      item['itemname'] ?? 'Unknown Item';
                                  String itemPrice =
                                      item['itemprice']?.toString() ?? '0';
                                  String qty =
                                      item['quantity']?.toString() ?? '0';

                                  double lineTotal =
                                      (double.tryParse(itemPrice) ?? 0.0) *
                                      (int.tryParse(qty) ?? 0);

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "$itemName  x$qty",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: isDark
                                                ? const Color(0xFFE2E8F0)
                                                : const Color(0xFF1E293B),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "₹${lineTotal.toStringAsFixed(2)}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: priceColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    ),
  );
}
