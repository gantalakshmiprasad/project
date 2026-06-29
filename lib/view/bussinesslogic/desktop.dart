import 'package:firstproject/view/connectionview/bluetoothUI.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:firstproject/customs/customwidgets.dart';
import 'package:firstproject/view/bussinesslogic/print.dart';

class Desktop extends StatelessWidget {
  final dynamic controller;
  const Desktop({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: appbar(controller),
      body: Row(
        children: [
          // --- MAIN GRID CATALOGUE REGION ---
          Expanded(
            flex: 3,
            child: Obx(() {
              // 1. Process overall asynchronous initialization states first
              if (controller.isitemsloading.value) {
                return Center(
                  child: Lottie.asset(
                    'assets/animations/loading.json',
                    height: 150,
                    width: 150,
                  ),
                );
              }

              // 2. Assign conditional widgets into a local token parameter
              // instead of triggering structural early returns.
              Widget mainContent;

              if (controller.filteredDatabase.isEmpty) {
                mainContent = const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 80,
                        color: Color(0xFF64748B),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No Items Found',
                        style: TextStyle(
                          color: Color(0xFF1E293B),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                mainContent = GridView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: controller.filteredDatabase.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio:
                        0.65, // Adjusts height-to-width ratio of slots
                  ),
                  itemBuilder: (context, index) {
                    final item = controller.filteredDatabase[index];

                    return ItemCard(
                      key: ValueKey(item['id']),
                      itemName: item['data']['itemname'],
                      price: item['data']['itemprice'],
                      available: item['data']['isavailable'],
                      quantity: item['quantity'],
                      imageurl: item['image'],
                      decrease: () => controller.decreasequantity(item['id']),
                      increase: () => controller.increasequantity(item['id']),
                      onedit: () => controller.onedit(
                        item['id'],
                        item['data']['isavailable'],
                        item['data']['itemname'],
                      ),
                      ondelete: () {
                        _showDeleteItemConfirmation(context, controller, item);
                      },
                    );
                  },
                );
              }

              // 3. Always return the root Stack layout so that the modal context tree
              // renders smoothly over both operational workspace frames.
              return Stack(
                alignment: Alignment.center,
                children: [
                  mainContent, // Holds either the empty state module or active catalog grid

                  if (controller.addclicked.value)
                    Container(
                      height: 450,
                      width: 700,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: const Color.fromARGB(255, 252, 255, 253),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(child: itemform(controller)),
                    ),
                  if (controller.isbluetoothclicked.value)
                    Container(
                      height: 450,
                      width: 700,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: const Color.fromARGB(255, 252, 255, 253),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(child: Bluetoothui()),
                    ),
                ],
              );
            }),
          ),

          // --- RIGHT SIDEBAR - BILL SUMMARY CHECKOUT PANEL ---
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                left: BorderSide(color: Colors.grey.shade200, width: 1.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
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
  }

  // --- DELETE SYSTEM CONFIRMATION MODAL INTERFACES ---
  void _showDeleteItemConfirmation(
    BuildContext context,
    dynamic controller,
    dynamic item,
  ) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
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
            const Text(
              'Remove Catalog Product?',
              style: TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Do you want to permanently delete "${item['data']['itemname']}" from your workspace inventory ledger?',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF64748B),
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
                      side: BorderSide(color: Colors.grey.shade300),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () => Get.back(),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Color(0xFF1E293B),
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
