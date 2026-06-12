import 'package:auto_size_text/auto_size_text.dart';
import 'package:firstproject/viewmodel/bussinesslogicctl/printcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Printitems extends StatelessWidget {
  const Printitems({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Printcontroller());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(() {
        final isDark = Get.isDarkMode;
        Color activeAccent = isDark
            ? const Color(0xFF2DD4BF)
            : const Color(0xFF0D9488);
        Color priceColor = isDark
            ? const Color(0xFFF59E0B)
            : const Color(0xFFD97706);
        Color mainText = isDark
            ? Colors.white
            : const Color.fromARGB(255, 239, 237, 237);

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              // CRITICAL FIX: Repositioned print execution module directly to the right side of the main title header layout
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          controller.bussinesstitle.value.toUpperCase(),
                          maxLines: 1,
                          maxFontSize: 22,
                          minFontSize: 16,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: mainText,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          controller.address.value,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? Colors.white54
                                : const Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => controller.printReceipt(),
                    icon: const Icon(
                      Icons.print_rounded,
                      color: Color.fromARGB(255, 8, 9, 9),
                      size: 22,
                    ),
                    tooltip: 'Print Out',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(
                color: isDark ? const Color(0xFF1E4D55) : Colors.grey.shade200,
                thickness: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMetaLabelValue(
                    'Time',
                    TimeOfDay.now().format(context),
                    isDark,
                  ),
                  _buildMetaLabelValue(
                    'Date',
                    "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                    isDark,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF0B1517)
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF1E4D55)
                        : Colors.grey.shade200,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildBadgeMetric(
                      'TOKEN NO',
                      controller.token.value.toString(),
                      activeAccent,
                      isDark,
                    ),
                    Container(
                      width: 1,
                      height: 24,
                      color: isDark
                          ? const Color(0xFF1E4D55)
                          : Colors.grey.shade200,
                    ),
                    _buildBadgeMetric(
                      'BILL NO',
                      controller.billno.value.toString(),
                      priceColor,
                      isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildTableHeader('Item Name', activeAccent),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildTableHeader(
                        'Price',
                        activeAccent,
                        align: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildTableHeader(
                        'Qty',
                        activeAccent,
                        align: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildTableHeader(
                        'Amount',
                        activeAccent,
                        align: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Divider(
                color: isDark ? const Color(0xFF1E4D55) : Colors.grey.shade200,
                thickness: 1,
              ),
              Expanded(
                child: controller.isloading.value
                    ? Center(
                        child: Lottie.asset(
                          'assets/animations/Printer.json',
                          height: 130,
                          width: 130,
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller.bills.length,
                        itemBuilder: (context, index) {
                          final item = controller.bills[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: isDark
                                      ? const Color(0xFF1E4D55)
                                      : Colors.grey.shade100,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: AutoSizeText(
                                    item['itemname'] ??
                                        'System Inventory Asset',
                                    style: TextStyle(
                                      color: mainText,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "${item['itemprice'] ?? '0'}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white70
                                          : const Color(0xFF64748B),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "${item['quantity'] ?? '0'}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: activeAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "₹${item['amount'] ?? '0'}",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: priceColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              Divider(
                color: isDark ? const Color(0xFF1E4D55) : Colors.grey.shade300,
                thickness: 1.5,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 16, top: 4),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF14353B), const Color(0xFF0B1517)]
                        : [Colors.white, const Color(0xFFF1F5F9)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? activeAccent : Colors.grey.shade200,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TOTAL OUTFLOW',
                      style: TextStyle(
                        color: mainText,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'Items: ${controller.totalQuantity}',
                      style: TextStyle(
                        color: activeAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '₹${controller.totalAmount}',
                      style: TextStyle(
                        color: priceColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMetaLabelValue(String label, String value, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            color: isDark ? Colors.white38 : const Color(0xFF64748B),
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isDark ? Colors.white70 : const Color(0xFF1E293B),
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBadgeMetric(
    String title,
    String value,
    Color color,
    bool isDark,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            color: isDark ? Colors.white38 : const Color(0xFF64748B),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader(
    String text,
    Color activeAccent, {
    TextAlign align = TextAlign.left,
  }) {
    return Text(
      text.toUpperCase(),
      textAlign: align,
      style: TextStyle(
        fontSize: 11,
        color: activeAccent,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
