// ignore_for_file: avoid_print

import 'package:firstproject/customs/customwidgets.dart';
import 'package:firstproject/viewmodel/bussinesslogicctl/printcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Printitems extends StatelessWidget {
  const Printitems({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Printcontroller());
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.5),
        ),
        child: Obx(() {
          final presenttime = TimeOfDay.now().format(context);
          final now = DateTime.now();
          return Column(
            children: [
              Defaultext(text: 'GLP Hotel', size: 25, color: Colors.black),
              Defaultext(
                text: 'Near CSI church,ELuru',
                size: 15,
                color: Colors.black54,
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [Text('Time : '), Text(presenttime)]),
                  Row(
                    children: [
                      Text('Date : '),
                      Text("${now.day}/${now.month}/${now.year}"),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Defaultext(text: 'Itemname', size: 15, color: Colors.black),
                  Defaultext(text: 'Price', size: 15, color: Colors.black),
                  Defaultext(text: 'Quantity', size: 15, color: Colors.black),
                  Defaultext(text: 'Amount', size: 15, color: Colors.black),
                ],
              ),
              ...controller.bills.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text("${item['itemname'] ?? ''}"),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text("${item['itemprice'] ?? ''}"),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text("${item['quantity'] ?? ''}"),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "${item['amount'] ?? ''}",
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        }),
      ),
    );
  }
}
