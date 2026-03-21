// ignore_for_file: avoid_print

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firstproject/customs/customwidgets.dart';
import 'package:firstproject/viewmodel/bussinesslogicctl/printcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Printitems extends StatelessWidget {
  const Printitems({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Printcontroller());
    return Scaffold(
      body: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
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
                      Defaultext(
                        text: 'Itemname',
                        size: 15,
                        color: Colors.black,
                      ),
                      Defaultext(text: 'Price', size: 15, color: Colors.black),
                      Defaultext(
                        text: 'Quantity',
                        size: 12,
                        color: Colors.black,
                      ),
                      Defaultext(text: 'Amount', size: 12, color: Colors.black),
                    ],
                  ),
                  Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.bills.length,
                      itemBuilder: (context, index) {
                        final item = controller.bills[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: AutoSizeText(
                                  item['itemname'],

                                  style: GoogleFonts.inter(
                                    color: Color(0xFF1F1F1F),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  minFontSize: 10, // smallest font size allowed
                                  maxFontSize: 15, // largest font size allowed
                                ),
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
                                flex: 1,
                                child: Text(
                                  "${item['amount'] ?? ''}",
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Defaultext(text: 'Total', size: 15, color: Colors.black),
                      Defaultext(
                        text: 'Items(${controller.totalquantity.value})',
                        size: 15,
                        color: Colors.black,
                      ),
                      Defaultext(
                        text: 'Rs.${controller.totalamount.value} ',
                        size: 15,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),

          IconButton(
            onPressed: () {
              controller.print();
            },
            icon: Icon(Icons.print),
          ),
        ],
      ),
    );
  }
}
