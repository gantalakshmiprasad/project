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
      // 1. Full-screen loader for Sign Out
      if (controller.issignedout.value) {
        return _loadingScreen('Please wait while signing out...', Colors.red);
      }
      if (controller.isitemsloading.value) {
        return Scaffold(
          appBar: appbar(controller),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Colors.green),
                SizedBox(height: 10),
                Text("Fetching items..."),
              ],
            ),
          ),
        );
      }
      if (controller.database.isEmpty) {
        return Scaffold(
          appBar: appbar(controller),
          body: Center(
            child: Text(
              controller.message.value,
              style: const TextStyle(fontSize: 24, color: Colors.grey),
            ),
          ),
        );
      }
      // 2. Full-screen loader for Initial Fetch

      // 3. Main UI Structure (Always returns this unless loading)
      return Scaffold(
        appBar: appbar(controller),
        body: Row(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                alignment: Alignment.center, // Center the form overlay
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(color: Color(0xFFECEFF1)),

                    // Check if database is empty HERE instead of top-level
                    child: GridView.builder(
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
                          ondelete: () {
                            Get.defaultDialog(
                              title: 'Warning',
                              content: Text(
                                'Do you want to delete ${item['data']['itemname']}? ',
                              ),
                              confirm: ElevatedButton(
                                onPressed: () {
                                  controller.ondelete(
                                    item['id'],
                                    item['data']['itemname'],
                                  );
                                  Get.back();
                                },
                                child: Text('Yes'),
                              ),
                              cancel: ElevatedButton(
                                onPressed: () => Get.back(),
                                child: Text('No'),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  // 4. Overlay for Adding Items (Works even if list is empty)
                  if (controller.addclicked.value)
                    SizedBox(
                      height: 370,
                      width: 500,

                      child: itemform(controller),
                    ),
                ],
              ),
            ),
            // Sidebar
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

  // Helper widget for full-screen loading
  Widget _loadingScreen(String message, Color color) {
    return Scaffold(
      body: Container(
        color: Colors.transparent,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: color),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
