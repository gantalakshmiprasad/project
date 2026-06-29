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
      backgroundColor: const Color.fromARGB(252, 10, 45, 37),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              // Main title header layout with print button
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
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          controller.address.value,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFF1F5F9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      controller.printReceipt();
                    },
                    icon: const Icon(
                      Icons.print_rounded,
                      color: Color(0xFF1E293B),
                      size: 22,
                    ),
                    tooltip: 'Print Out',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: Colors.grey.shade200, thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMetaLabelValue('Time', TimeOfDay.now().format(context)),
                  _buildMetaLabelValue(
                    'Date',
                    "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildBadgeMetric(
                      'TOKEN NO',
                      controller.token.value.toString(),
                      const Color.fromARGB(255, 10, 10, 10),
                    ),
                    Container(
                      width: 1,
                      height: 24,
                      color: Colors.grey.shade200,
                    ),
                    _buildBadgeMetric(
                      'BILL NO',
                      controller.billno.value.toString(),
                      const Color.fromARGB(255, 2, 2, 2),
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
                      child: _buildTableHeader('Item Name', Colors.white),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildTableHeader(
                        'Price',
                        Colors.white,
                        align: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildTableHeader(
                        'Qty',
                        Colors.white,
                        align: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildTableHeader(
                        'Amount',
                        Colors.white,
                        align: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Divider(color: Colors.grey.shade200, thickness: 1),
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
                                bottom: BorderSide(color: Colors.grey.shade100),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: AutoSizeText(
                                    item['itemname'] ??
                                        'System Inventory Asset',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 215, 215, 215),
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
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "${item['quantity'] ?? '0'}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
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
                                    style: const TextStyle(
                                      color: Colors.white,
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
              Divider(color: Colors.grey.shade300, thickness: 1.5),
              Container(
                margin: const EdgeInsets.only(bottom: 16, top: 4),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.white, Color(0xFFF1F5F9)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'TOTAL',
                      style: TextStyle(
                        color: Color.fromARGB(255, 12, 10, 10),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'Items: ${controller.totalQuantity}',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 6, 6, 6),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '₹${controller.totalAmount}',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 12, 12, 12),
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

  Widget _buildMetaLabelValue(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color.fromARGB(255, 231, 233, 235),
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBadgeMetric(String title, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 10,
            color: Color.fromARGB(255, 2, 3, 3),
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
    Color headerColor, {
    TextAlign align = TextAlign.left,
  }) {
    return Text(
      text.toUpperCase(),
      textAlign: align,
      style: TextStyle(
        fontSize: 11,
        color: headerColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
