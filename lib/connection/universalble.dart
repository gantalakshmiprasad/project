import 'package:firstproject/connection/universalblectl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:typed_data';

import 'package:universal_ble/universal_ble.dart';

class BluetoothPrinterView extends StatelessWidget {
  const BluetoothPrinterView({super.key});

  @override
  Widget build(BuildContext context) {
    final UniversalBleController controller = Get.put(UniversalBleController());

    return Scaffold(
      appBar: AppBar(title: const Text("Connect to printer")),
      body: Column(
        children: [
          // 1. Connection Status Header
          Obx(
            () => Container(
              padding: const EdgeInsets.all(16),
              color:
                  controller.connectionState.value ==
                      BleConnectionState.connected
                  ? Colors.green.shade100
                  : Colors.red.shade100,
              child: Row(
                children: [
                  Icon(
                    controller.connectionState.value ==
                            BleConnectionState.connected
                        ? Icons.bluetooth_connected
                        : Icons.bluetooth_disabled,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Status: ${controller.connectionState.value.toString().split('.').last}",
                  ),
                ],
              ),
            ),
          ),

          // 2. Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Obx(
                () => ElevatedButton(
                  onPressed: controller.isScanning.value
                      ? null
                      : () => controller.startScan(),
                  child: const Text("Scan Printers"),
                ),
              ),
              ElevatedButton(
                onPressed: () => controller.disconnect(),
                child: const Text("Disconnect"),
              ),
            ],
          ),

          // 3. Print Test Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                // Example: Sending a simple print command (ESC/POS)
                // \n is for line feed
                final bytes = Uint8List.fromList(
                  "Hello Thermal Printer\n\n\n".codeUnits,
                );
                controller.writeData("SERVICE_UUID", "CHAR_UUID", bytes);
              },
              child: const Text(
                "Print Test Text",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
