import 'package:firstproject/viewmodel/bussinesslogicctl/billshistoryctl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:table_calendar/table_calendar.dart';

class PhysicalGetxCalendarPage extends StatelessWidget {
  const PhysicalGetxCalendarPage({super.key});

  // Theme configuration constants shared across the layout
  static const Color mainText = Color(0xFF1E293B);
  static const Color accentColor = Color(0xFF0D9488);
  static const Color warningColor = Color(0xFFFB7185);
  static const Color subText = Color(0xFF64748B);
  static const Color priceColor = Color(0xFFD97706);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PhysicalCalendarController());
    bool isWideScreen = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: isWideScreen
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(color: Colors.grey.shade200, height: 1),
              ),
              title: const Text(
                "Bill History Ledger",
                style: TextStyle(
                  color: mainText,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              foregroundColor: mainText,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: subText),
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
                          child: Lottie.asset('assets/animations/loading.json'),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.list_alt_rounded, color: accentColor),
                ),
                IconButton(
                  tooltip: 'Purge Ledger Window',
                  onPressed: () {
                    Get.defaultDialog(
                      backgroundColor: Colors.white,
                      title: "Clear Ledger Window?",
                      titleStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: warningColor,
                        fontSize: 18,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      content: const Text(
                        'Do you want to permanently delete all bills for this targeted date window? This statement cannot be reversed.',
                        style: TextStyle(
                          color: subText,
                          fontSize: 14,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      textConfirm: "Purge All",
                      textCancel: "Abort",
                      confirmTextColor: Colors.white,
                      cancelTextColor: mainText,
                      buttonColor: warningColor,
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
                    color: warningColor,
                  ),
                ),
              ],
            )
          : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 900;

          // MASTER OBX: Captures all inline layout calls securely in one frame execution context
          return Obx(() {
            if (isDesktop) {
              return Row(
                children: [
                  Expanded(
                    child: _buildInvoiceListView(context, controller, true),
                  ),
                  Container(width: 1, color: Colors.grey.shade200),
                  _buildCalendarView(controller, true),
                ],
              );
            } else {
              return controller.calenderclicked.value
                  ? Center(child: _buildCalendarView(controller, false))
                  : _buildInvoiceListView(context, controller, false);
            }
          });
        },
      ),
    );
  }

  // Private Calendar View Element
  Widget _buildCalendarView(
    PhysicalCalendarController controller,
    bool isDesktop,
  ) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        width: 460,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade200, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
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
              Container(height: 6, color: accentColor),
              if (!isDesktop)
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Select Filter Date",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: mainText,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: subText),
                        onPressed: () =>
                            controller.calenderclicked.value = false,
                      ),
                    ],
                  ),
                ),
              TableCalendar(
                firstDay: DateTime.utc(2025, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: controller.focusedDay.value,
                calendarFormat: controller.calendarFormat.value,
                selectedDayPredicate: (day) =>
                    isSameDay(controller.selectedDay.value, day),
                onDaySelected: (selectedDay, focusedDay) {
                  controller.onDaySelected(selectedDay, focusedDay);
                  if (!isDesktop) {
                    controller.calenderclicked.value = false;
                  }
                },
                onFormatChanged: controller.onFormatChanged,
                onPageChanged: controller.onPageChanged,
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                  leftChevronIcon: const Icon(
                    Icons.chevron_left_rounded,
                    color: subText,
                  ),
                  rightChevronIcon: const Icon(
                    Icons.chevron_right_rounded,
                    color: subText,
                  ),
                  titleTextStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: mainText,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    color: subText,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  weekendStyle: TextStyle(
                    color: Color(0xFFFB7185),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                calendarStyle: CalendarStyle(
                  tableBorder: TableBorder(
                    horizontalInside: BorderSide(
                      color: Colors.grey.shade100,
                      width: 1,
                    ),
                  ),
                  defaultTextStyle: const TextStyle(
                    color: mainText,
                    fontWeight: FontWeight.bold,
                  ),
                  weekendTextStyle: const TextStyle(
                    color: Color(0xFFFB7185),
                    fontWeight: FontWeight.bold,
                  ),
                  outsideDaysVisible: true,
                  outsideTextStyle: TextStyle(color: Colors.grey.shade300),
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
                    color: accentColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  selectedTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Divider(height: 1, color: Colors.grey.shade200),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Selected Range Target:",
                      style: TextStyle(
                        fontSize: 13,
                        color: subText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      controller.formattedSelectedDate,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
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

  // Private Invoice List View Element
  Widget _buildInvoiceListView(
    BuildContext context,
    PhysicalCalendarController controller,
    bool isDesktop,
  ) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.receipt_long_rounded,
                color: accentColor,
                size: 26,
              ),
              const SizedBox(width: 12),
              const Text(
                "Invoices Filed",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: mainText,
                ),
              ),
              const Spacer(),
              if (!isDesktop)
                IconButton(
                  onPressed: () => controller.calenderclicked.value = true,
                  icon: const Icon(
                    Icons.calendar_month_rounded,
                    color: accentColor,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: () {
              if (controller.isBillsLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(accentColor),
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
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No bills registry located for\n${controller.formattedSelectedDate}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: subText,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
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

                  // 1. Parse the UTC string into a local machine DateTime object (automatically offsets +5:30 for India)
                  DateTime localDateTime = DateTime.parse(createdat).toLocal();

                  // 2. Extract Date Elements manually (Format: DD-MM-YYYY)
                  String day = localDateTime.day.toString().padLeft(2, '0');
                  String month = localDateTime.month.toString().padLeft(2, '0');
                  int year = localDateTime.year;
                  String formattedDate = "$day-$month-$year";

                  // 3. Extract Time Elements manually (Format: 12-Hour AM/PM)
                  int hour = localDateTime.hour;
                  String period = hour >= 12 ? "PM" : "AM";
                  hour = hour % 12;
                  hour = hour == 0
                      ? 12
                      : hour; // Convert 0 to 12 for 12-hour format

                  String minute = localDateTime.minute.toString().padLeft(
                    2,
                    '0',
                  );
                  String formattedTime =
                      "${hour.toString().padLeft(2, '0')}:$minute $period";

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 6,
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
                        collapsedIconColor: subText,
                        iconColor: accentColor,
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.receipt_rounded,
                            color: accentColor,
                            size: 22,
                          ),
                        ),
                        title: Text(
                          "Bill No : $billNumber",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: mainText,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Row(
                            children: [
                              Text(
                                "Date: $formattedDate",

                                style: const TextStyle(
                                  color: Color.fromARGB(255, 6, 7, 9),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 15),
                              Text(
                                "Time: $formattedTime",

                                style: const TextStyle(
                                  color: Color.fromARGB(255, 6, 8, 10),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: Text(
                          "₹$totalAmount",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: priceColor,
                          ),
                        ),
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.vertical(
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
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: mainText,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "₹${lineTotal.toStringAsFixed(2)}",
                                          style: const TextStyle(
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
            }(),
          ),
        ],
      ),
    );
  }
}
