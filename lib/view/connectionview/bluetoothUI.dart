import 'package:firstproject/viewmodel/connectionctl/bluetoothctl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Bluetoothui extends StatelessWidget {
  const Bluetoothui({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BluetoothController());

    return Obx(() {
      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min, // ✅ prevents infinite expansion
          children: [
            Text(controller.info.value),
            const SizedBox(height: 25),
            // Example: list paired devices safely
            ListView.builder(
              shrinkWrap: true, // ✅ important
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.items.length,
              itemBuilder: (context, index) {
                final device = controller.items[index];
                return ListTile(
                  title: Text(device.name),
                  subtitle: Text(device.macAdress),
                  onTap: () => controller.connect(device.macAdress),
                );
              },
            ),
          ],
        ),
      );
    });
  }
}
