import 'package:firstproject/customs/customwidgets.dart';
import 'package:firstproject/view/bussinesslogic/print.dart';
import 'package:firstproject/viewmodel/bussinesslogicctl/Homepagecontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Homepagecontroller());

    return Obx(() {
      // 1. Show full-screen loader if signing out
      if (controller.issignedout.value) {
        return const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Colors.red,
                ), // Distinct color for signing out
                SizedBox(height: 16),
                Text(
                  'Please wait while signing out...',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      }

      // 2. Show full-screen loader during initial database fetch
      if (controller.isloading.value || controller.database.isEmpty) {
        return Scaffold(
          appBar: appbar(controller),
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.green),
                SizedBox(height: 16),
                Text(
                  'Items are loading...',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
          ),
        );
      }

      // 3. Main UI when not loading or signing out
      return Scaffold(
        appBar: appbar(controller),
        body: Row(
          children: [
            Expanded(
              // Better than fixed width percentages for responsiveness
              flex: 3,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(color: Color(0xFFECEFF1)),
                    child: controller.database.isNotEmpty
                        ? GridView.builder(
                            itemCount: controller.database.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 7,
                                  childAspectRatio: 0.7,
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
                              );
                            },
                          )
                        : const Center(
                            child: Text(
                              'No data found',
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                  ),
                  // Overlay for Adding Items
                  if (controller.addclicked.value)
                    Center(
                      child: Container(
                        height: 370,
                        width: 500,
                        color: Colors.white,
                        child: itemform(controller),
                      ),
                    ),
                ],
              ),
            ),
            // Sidebar for Print
            Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(color: Colors.white54),
              width: Get.width * 0.25,
              child: Printitems(),
            ),
          ],
        ),
      );
    });
  }
}
