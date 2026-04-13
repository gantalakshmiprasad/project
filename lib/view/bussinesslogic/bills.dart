import 'package:firstproject/viewmodel/bussinesslogicctl/billscontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Billshistory extends StatelessWidget {
  const Billshistory({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Billscontroller());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bill History"),
        actions: [
          IconButton(onPressed: () => Get.back(), icon: Icon(Icons.fork_left)),
        ],
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

            return Card(
              color: Colors.orange,
              margin: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Bill No: ${bill['billnumber']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Divider(color: Colors.black),
                    // List first few items or total
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: items.length,
                        itemBuilder: (ctx, i) => Center(
                          child: Text(
                            "${items[i]['quantity']}x ${items[i]['itemname']}",
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    const Divider(color: Colors.black),
                    Text(
                      "Total: ₹${bill['totalamount'] ?? 0}",
                      style: TextStyle(fontSize: 25),
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
