// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names

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
      return Scaffold(
        appBar: appbar(controller),
        body: Row(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                alignment: Alignment.center, // Center the form overlay
                children: [
                  controller.isitemsloading.value
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 15),
                            Defaultext(
                              text: 'loading..',
                              size: 35,
                              color: Colors.black,
                            ),
                          ],
                        )
                      : controller.database.isEmpty
                      ? Text(
                          'No data',
                          style: TextStyle(color: Colors.red, fontSize: 45),
                        )
                      : Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Color(0xFFECEFF1),
                          ),

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
}
