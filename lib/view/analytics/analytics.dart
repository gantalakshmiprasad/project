import 'dart:convert';
import 'package:firstproject/viewmodel/analytics/analyticscontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Analytics extends StatelessWidget {
  const Analytics({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Analyticscontroller());
    final isDark = Get.isDarkMode;

    Color mainText = isDark ? Colors.white : const Color(0xFF1E293B);
    Color activeAccent = isDark
        ? const Color(0xFF2DD4BF)
        : const Color(0xFF0D9488);
    Color priceColor = isDark
        ? const Color(0xFFF59E0B)
        : const Color(0xFFD97706);
    Color surfaceColor = isDark ? const Color(0xFF111827) : Colors.white;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0B1214)
          : const Color(0xFFF8FAFC),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: isDark ? const Color(0xFF111827) : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: mainText),
        title: Text(
          'Store Performance Analytics',
          style: TextStyle(
            color: mainText,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => controller.fetchTransactionsFromBackend(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        DateTime dateObj = controller.selectedDate.value;
        String formattedDate =
            "${dateObj.day}/${dateObj.month}/${dateObj.year}";

        bool isToday =
            DateTime.now().day == dateObj.day &&
            DateTime.now().month == dateObj.month &&
            DateTime.now().year == dateObj.year;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. DYNAMIC HEADER AND CALENDAR SYSTEM
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isToday
                              ? "TODAY'S ANALYSIS SUMMARY"
                              : "HISTORICAL TRANSACTION REGISTRY",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: activeAccent,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            AutoSizeText(
                              formattedDate,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: mainText,
                              ),
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              icon: Icon(
                                Icons.calendar_month_rounded,
                                color: activeAccent,
                                size: 24,
                              ),
                              onPressed: () =>
                                  controller.selectCalendarDate(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                    ),
                    onPressed: () => controller.triggerDailyReportPrint(),
                    icon: Icon(
                      Icons.print_rounded,
                      color: isDark ? Colors.black : Colors.white,
                      size: 22,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 2. REVENUE AND VOLUME METRIC SNAPSHOT SCORECARDS
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF374151)
                        : Colors.grey.shade200,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMetricsCell(
                      "TOTAL REVENUE",
                      "₹${controller.dailyTotalAmount.toStringAsFixed(2)}",
                      priceColor,
                    ),
                    Container(
                      width: 1,
                      height: 32,
                      color: isDark
                          ? const Color(0xFF374151)
                          : Colors.grey.shade200,
                    ),
                    _buildMetricsCell(
                      "TOTAL BILLS ISSUED",
                      "${controller.filteredTransactions.length}",
                      activeAccent,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 3. EXPANDABLE TRANSACTION ITEMIZATION LOGS
              Text(
                "TRANSACTION ITEMIZATION LOGS (TAP TO EXPAND)",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: activeAccent,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),

              Expanded(
                child: controller.filteredTransactions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "No transactions found for $formattedDate.",
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white54
                                    : Colors.grey.shade700,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Tap the calendar icon above to check previous dates.",
                              style: TextStyle(
                                color: isDark ? Colors.white38 : Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller.filteredTransactions.length,
                        itemBuilder: (context, index) {
                          final dynamic tx =
                              controller.filteredTransactions[index];

                          // 100% Safe cast fallback to ensure map compliance
                          final Map<String, dynamic> safeTx = tx is Map
                              ? Map<String, dynamic>.from(tx)
                              : {};

                          final int billNum = safeTx['billnumber'] ?? 0;
                          final double billAmt =
                              double.tryParse(
                                safeTx['totalamount']?.toString() ?? '0',
                              ) ??
                              0.0;

                          // --- CRITICAL FIX: Fully Guarded Data Map Extractor ---
                          final dynamic nestedData = safeTx['data'];
                          final Map<String, dynamic> targetDataSource =
                              (nestedData is Map)
                              ? Map<String, dynamic>.from(nestedData)
                              : safeTx;

                          // Safely resolve variant lists or stringified arrays
                          dynamic rawItems =
                              targetDataSource['bills'] ??
                              targetDataSource['items'] ??
                              targetDataSource['solditems'];
                          List<dynamic> itemsList = [];

                          if (rawItems is List) {
                            itemsList = rawItems;
                          } else if (rawItems is String) {
                            try {
                              itemsList = jsonDecode(rawItems);
                            } catch (_) {}
                          }

                          return Theme(
                            data: Theme.of(
                              context,
                            ).copyWith(dividerColor: Colors.transparent),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: surfaceColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDark
                                      ? const Color(0xFF1F2937)
                                      : Colors.grey.shade100,
                                ),
                              ),
                              child: ExpansionTile(
                                backgroundColor: Colors.transparent,
                                collapsedBackgroundColor: Colors.transparent,
                                iconColor: activeAccent,
                                collapsedIconColor: isDark
                                    ? Colors.white54
                                    : Colors.grey.shade600,
                                tilePadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 4,
                                ),
                                childrenPadding: const EdgeInsets.fromLTRB(
                                  14,
                                  0,
                                  14,
                                  14,
                                ),
                                title: Text(
                                  "Bill No:$billNum",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: mainText,
                                  ),
                                ),

                                trailing: Text(
                                  "₹${billAmt.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: priceColor,
                                  ),
                                ),
                                children: [
                                  const Divider(
                                    height: 16,
                                    thickness: 0.5,
                                    color: Colors.grey,
                                  ),
                                  if (itemsList.isEmpty)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                      ),
                                      child: ListView.builder(
                                        itemCount:
                                            controller.allTransactions.length,
                                        itemBuilder: (context, index) {
                                          final itemname = controller
                                              .allTransactions[index]['itemname'];
                                          return Row(
                                            children: [Text(itemname)],
                                          );
                                        },
                                      ),
                                    )
                                  else
                                    ...itemsList.map((item) {
                                      Map<String, dynamic> itemMap = {};
                                      if (item is String) {
                                        try {
                                          itemMap = jsonDecode(item);
                                        } catch (_) {}
                                      } else if (item is Map) {
                                        itemMap = Map<String, dynamic>.from(
                                          item,
                                        );
                                      }

                                      final String name =
                                          itemMap['itemname'] ??
                                          itemMap['name'] ??
                                          'Unknown Product';
                                      final int qty =
                                          int.tryParse(
                                            itemMap['quantity']?.toString() ??
                                                '1',
                                          ) ??
                                          1;
                                      final double price =
                                          double.tryParse(
                                            itemMap['itemprice']?.toString() ??
                                                itemMap['price']?.toString() ??
                                                '0',
                                          ) ??
                                          0.0;
                                      final double totalItemAmt =
                                          double.tryParse(
                                            itemMap['amount']?.toString() ??
                                                '0',
                                          ) ??
                                          (qty * price);

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "$name  x$qty",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: mainText,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "₹${totalItemAmt.toStringAsFixed(2)}",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: isDark
                                                    ? Colors.white70
                                                    : Colors.grey.shade800,
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
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMetricsCell(String title, String data, Color valueColor) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 6),
          AutoSizeText(
            data,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
