// ignore_for_file: file_names

import 'dart:typed_data';

import 'package:firstproject/customs/customwidgets.dart';
import 'package:firstproject/viewmodel/bussinesslogicctl/Homepagecontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Homepagecontroller());
    return Scaffold(
      appBar: appbar(controller),
      body: Obx(() {
        if (controller.isloading.value) {
          return Center(child: CircularProgressIndicator(color: Colors.green));
        }

        return Row(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  height: double.infinity,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blue,
                        const Color.fromARGB(231, 46, 115, 252),
                      ],

                      // Optional: stops defines where each color starts (0.0 to 1.0)
                    ),
                  ),
                  width: Get.width * 0.75,

                  child: controller.database.isNotEmpty
                      ? GridView.builder(
                          itemCount: controller.database.length,
                          shrinkWrap: true,

                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 7,
                                childAspectRatio: 0.7,
                              ),
                          itemBuilder: (context, index) {
                            final data = controller.database[index]['data'];
                            final rowid = controller.database[index]['id'];
                            final quantity =
                                controller.database[index]['quantity'];
                            final Uint8List image =
                                controller.database[index]['image'];

                            return ItemCard(
                              key: ValueKey(rowid),
                              itemName: data['itemname'],
                              price: data['itemprice'],

                              available: data['isavailable'],
                              decrease: () {
                                controller.decreasequantity(rowid);
                              },
                              increase: () {
                                controller.increasequantity(rowid);
                              },
                              quantity: quantity,
                              imageurl: image,
                              onedit: () => controller.onedit(
                                rowid ?? 'No information',
                                data['isavailable'] as bool,
                                data['itemname'],
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Defaultext(
                            text: 'No data',
                            size: 55,
                            color: Colors.green,
                          ),
                        ),
                ),
                controller.addclicked.value
                    ? Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 370,
                          width: 500,
                          padding: const EdgeInsets.all(8.0),
                          child: itemform(controller),
                        ),
                      )
                    : Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: addbutton(controller),
                        ),
                      ),
              ],
            ),
            SizedBox(child: Text('print area  ')),
          ],
        );
      }),
    );
  }
}
