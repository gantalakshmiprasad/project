import 'package:firstproject/viewmodel/bussinesslogicctl/themecontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:firstproject/customs/customwidgets.dart';
import 'package:firstproject/view/bussinesslogic/print.dart';

class Desktop extends StatelessWidget {
  final dynamic controller;
  const Desktop({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = Get.find<ThemeController>();
    return Obx(() {
      final isDark = themeCtrl.isDark;

      return Scaffold(
        backgroundColor: isDark
            ? const Color.fromARGB(255, 2, 33, 40)
            : const Color(0xFFF8FAFC),
        appBar: appbar(controller),
        body: Row(
          children: [
            // 1. MAIN GRID CATALOGUE REGION
            Expanded(
              flex: 3,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  controller.isitemsloading.value
                      ? Center(
                          child: Lottie.asset(
                            'assets/animations/loading.json',
                            height: 150,
                            width: 150,
                          ),
                        )
                      : controller.database.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                size: 80,
                                color: isDark ? Colors.white24 : Colors.black26,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No Items Found',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white38
                                      : Colors.black45,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          color: isDark
                              ? const Color.fromARGB(45, 1, 41, 52)
                              : const Color(0xFFF1F5F9),
                          child: GridView.builder(
                            padding: const EdgeInsets.all(24),
                            itemCount: controller.database.length,

                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 220,
                                  childAspectRatio: 0.68,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                ),
                            itemBuilder: (context, index) {
                              final item = controller.database[index];

                              return ItemCard(
                                isdark: isDark,
                                key: ValueKey(item['id']),
                                itemName: item['data']['itemname'],
                                price: item['data']['itemprice'],
                                available: item['data']['isavailable'],
                                quantity: item['quantity'],
                                imageurl: item['image'],
                                decrease: () =>
                                    controller.decreasequantity(item['id']),
                                increase: () =>
                                    controller.increasequantity(item['id']),
                                onedit: () => controller.onedit(
                                  item['id'],
                                  item['data']['isavailable'],
                                  item['data']['itemname'],
                                ),
                                ondelete: () {
                                  _showDeleteItemConfirmation(
                                    context,
                                    controller,
                                    item,
                                  );
                                },
                              );
                            },
                          ),
                        ),

                  // 2. MODAL OVERLAY FOR ADDING/EDITING ITEMS
                  if (controller.addclicked.value)
                    Container(
                      color: Colors.black45,
                      child: Center(
                        child: SizedBox(
                          height: 420,
                          width: 500,
                          child: itemform(controller),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // 3. RIGHT SIDEBAR - BILL SUMMARY CHECKOUT PANEL
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F262A) : Colors.white,
                border: Border(
                  left: BorderSide(
                    color: isDark
                        ? const Color.fromARGB(255, 10, 22, 24)
                        : Colors.grey.shade200,
                    width: 1.5,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black38 : Colors.grey.shade300,
                    blurRadius: 20,
                    offset: const Offset(-5, 0),
                  ),
                ],
              ),
              width: Get.width * 0.24,
              child: const ClipRRect(child: Printitems()),
            ),
          ],
        ),
      );
    });
  }

  void _showDeleteItemConfirmation(
    BuildContext context,
    dynamic controller,
    dynamic item,
  ) {
    final isDark = Get.isDarkMode;
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F262A) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 24),
            const Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFFB7185),
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Remove Catalog Product?',
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF1E293B),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Do you want to permanently delete "${item['data']['itemname']}" from your workspace inventory ledger?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? Colors.white54 : const Color(0xFF64748B),
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isDark ? Colors.white24 : Colors.grey.shade300,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () => Get.back(),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFB7185),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      controller.isitemsloading.value = true;
                      controller.ondelete(item['id'], item['data']['itemname']);
                      Get.back();
                    },
                    child: const Text(
                      "Delete Product",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
