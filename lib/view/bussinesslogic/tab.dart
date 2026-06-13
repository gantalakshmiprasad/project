import 'package:firstproject/customs/customwidgets.dart';
import 'package:firstproject/view/bussinesslogic/billprintview.dart';
import 'package:firstproject/view/bussinesslogic/print.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Tablet extends StatelessWidget {
  final dynamic controller;
  const Tablet({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: const Color(0xFF0B1517),
        appBar: appbar(controller),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFF0F262A),
          selectedItemColor: const Color(0xFF2DD4BF),
          unselectedItemColor: const Color(0xFF64748B),
          currentIndex: controller.currentindex.value,
          onTap: (value) {
            controller.currentindex.value = value;
            // Trigger historical ledger updates automatically when selected
            if (value == 1) {
              Get.find<dynamic>().fetchBills();
            }
          },
          selectedFontSize: 18,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Color.fromARGB(255, 245, 243, 242)),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.history,
                color: Color.fromARGB(255, 241, 240, 237),
              ),
              label: 'Bills',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.print,
                color: Color.fromARGB(255, 252, 251, 250),
              ),
              label: 'Print',
            ),
          ],
        ),
        body: () {
          if (controller.currentindex.value == 1) {
            return PhysicalGetxCalendarPage();
          } else if (controller.currentindex.value == 2) {
            return const Printitems();
          }

          return Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                controller.isitemsloading.value
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Color(0xFF2DD4BF)),
                          SizedBox(height: 15),
                          Defaultext(
                            text: 'Loading Workspace Engine...',
                            size: 20,
                            color: Colors.white70,
                          ),
                        ],
                      )
                    : controller.database.isEmpty
                    ? const Text(
                        'No Active Dataset Records Found',
                        style: TextStyle(
                          color: Color(0xFFEF4444),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(16),
                        color: const Color(0xFF0B1517),
                        child: GridView.builder(
                          itemCount: controller.database.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    4, // Scaled better for tablet aspect layouts
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          itemBuilder: (context, index) {
                            final item = controller.database[index];
                            return ItemCard(
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
                    height: Get.height * 0.75,
                    width: Get.width * 0.75,
                    child: itemform(controller),
                  ),
              ],
            ),
          );
        }(),
      ),
    );
  }

  void _showDeleteConfirmation(dynamic item) {
    Get.defaultDialog(
      title: 'Destructive Action Warning',
      titleStyle: const TextStyle(
        color: Color(0xFFEF4444),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: const Color(0xFF0F262A),
      contentPadding: const EdgeInsets.all(20),
      content: Text(
        'Are you sure you want to permanently delete ${item['data']['itemname']} from system inventories?',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Color(0xFF94A3B8)),
      ),
      textConfirm: 'Delete',
      textCancel: 'Cancel',
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
