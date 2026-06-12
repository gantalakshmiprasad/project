import 'package:firstproject/customs/customwidgets.dart';
import 'package:firstproject/view/bussinesslogic/bills.dart';
import 'package:firstproject/view/bussinesslogic/print.dart';
import 'package:firstproject/viewmodel/bussinesslogicctl/billscontroller.dart';
import 'package:firstproject/viewmodel/bussinesslogicctl/printcontroller.dart';
import 'package:firstproject/viewmodel/bussinesslogicctl/themecontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Mobile extends StatelessWidget {
  final dynamic controller;
  const Mobile({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    // BUG FIX: Consolidated multiple nested Obx loops into one clean global listener block
    return Obx(() {
      final itemslength = Get.find<Printcontroller>().totalQuantity;

      return Scaffold(
        backgroundColor: const Color(0xFF0B1517),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF0F262A),
          title: const Text(
            'UBS Terminal',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add, color: Color(0xFF2DD4BF)),
              onPressed: () => controller.opendialog(),
            ),
            Center(
              child: Text(
                'Items: $itemslength',
                style: const TextStyle(
                  color: Color(0xFFF59E0B),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.print, color: Colors.white),
              onPressed: () {
                Get.showOverlay(
                  asyncFunction: () =>
                      Get.find<Printcontroller>().printReceipt(),
                  loadingWidget: Center(
                    child: SizedBox(
                      height: 60,
                      width: 60,
                      child: Lottie.asset('assets/animations/Printer.json'),
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: Color(0xFFFB7185)),
              onPressed: () => Get.offAllNamed('/'),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFF0F262A),
          selectedItemColor: const Color(0xFF2DD4BF),
          unselectedItemColor: const Color(0xFF64748B),
          currentIndex: controller.currentindex.value,
          onTap: (value) {
            controller.currentindex.value = value;
            if (value == 1) {
              Get.find<Billscontroller>().fetchBills();
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Bills'),
            BottomNavigationBarItem(icon: Icon(Icons.print), label: 'Print'),
          ],
        ),
        body: () {
          if (controller.currentindex.value == 1) {
            return Billshistory();
          } else if (controller.currentindex.value == 2) {
            return const Printitems();
          }

          return Stack(
            alignment: Alignment.center,
            children: [
              controller.isitemsloading.value
                  ? Center(
                      child: Lottie.asset(
                        'assets/animations/loading.json',
                        height: 85,
                        width: 80,
                      ),
                    )
                  : controller.database.isEmpty
                  ? const Center(
                      child: Text(
                        'No Assets Found',
                        style: TextStyle(
                          color: Color(0xFFEF4444),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.all(8),
                      color: const Color(0xFF0B1517),
                      child: GridView.builder(
                        itemCount: controller.database.length,
                        physics: const AlwaysScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  2, // Upgraded constraints layout parameters to display balanced square matrix configurations
                              childAspectRatio: 0.8,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                        itemBuilder: (context, index) {
                          final item = controller.database[index];
                          return ItemCard(
                            isdark: Get.find<ThemeController>().isDark,
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
                            ondelete: () => _showDeleteConfirmation(item),
                          );
                        },
                      ),
                    ),
              if (controller.addclicked.value)
                SizedBox(
                  width: Get.width * 0.85,
                  height: Get.height * 0.7,
                  child: itemform(controller),
                ),
            ],
          );
        }(),
      );
    });
  }

  void _showDeleteConfirmation(dynamic item) {
    Get.defaultDialog(
      title: 'Warning',
      titleStyle: const TextStyle(
        color: Color(0xFFEF4444),
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: const Color(0xFF0F262A),
      content: Text(
        'Delete ${item['data']['itemname']}?',
        style: const TextStyle(color: Colors.white70),
      ),
      textConfirm: 'Yes',
      textCancel: 'No',
      confirmTextColor: const Color(0xFF0B1517),
      cancelTextColor: const Color(0xFF2DD4BF),
      buttonColor: const Color(0xFFEF4444),
      onConfirm: () {
        controller.ondelete(item['id'], item['data']['itemname']);
        Get.back();
      },
    );
  }
}
