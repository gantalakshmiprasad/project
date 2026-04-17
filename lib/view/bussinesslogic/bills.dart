import 'package:firstproject/customs/customwidgets.dart';
import 'package:firstproject/viewmodel/bussinesslogicctl/billscontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

class Billshistory extends StatelessWidget {
  const Billshistory({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Billscontroller());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bill History"),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () =>
              Get.toNamed('/homepage'), // or Navigator.pop(context)
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.bills.isEmpty) {
          return const Center(child: Text("No history found"));
        }

        return GridView.builder(
          itemCount: controller.bills.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final bill = controller.bills[index];
            final List items = bill['items'];

            // Convert String to DateTime object
            DateTime dateValue = DateTime.parse(bill['createdAt']);

            // Format however you like
            String formattedDate = DateFormat(
              'dd MMM yyyy',
            ).format(dateValue); // 16 Apr 2026
            String formattedTime = DateFormat(
              'hh:mm a',
            ).format(dateValue); // 05:12 PM

            return Card(
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Column(
                  children: [
                    Text(
                      'BillNo : ${bill['billnumber']}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Date: $formattedDate',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Time: $formattedTime',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Divider(color: Colors.black),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Item',
                              style: TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            child: Text('Qty', style: TextStyle(fontSize: 14)),
                          ),
                          Text('Price', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                    Divider(color: Colors.black),
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, i) {
                          final item = items[i];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    item['itemname'],
                                    style: TextStyle(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '${item['quantity']}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                Text(
                                  '₹${item['itemprice']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(color: Colors.black),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Defaultext(
                            text: 'Total Amount',
                            size: 15,
                            color: Colors.black,
                          ),
                          Defaultext(
                            text: bill['totalamount'].toString(),
                            size: 15,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
