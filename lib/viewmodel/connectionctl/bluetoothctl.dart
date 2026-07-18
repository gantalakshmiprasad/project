import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class BluetoothController extends GetxController {
  var info = "Loading system info...".obs;
  final RxBool isBluetoothOn = false.obs;
  var msj = "".obs;
  var isConnected = false.obs;
  var items = <BluetoothInfo>[].obs;
  var progress = false.obs;
  var msjProgress = "".obs;
  var optionPrintType = "58 mm".obs;
  var selectSize = "2".obs;
  var hasPermission = false.obs;

  final txtText = TextEditingController(text: "Hello Developer!");
  final List<String> options = ["58 mm", "80 mm"];

  @override
  void onInit() {
    super.onInit();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    try {
      final bool result = await PrintBluetoothThermal.bluetoothEnabled;
      isBluetoothOn.value = result;
      info.value = result ? "Bluetooth enabled" : "Bluetooth disabled";
    } catch (e) {
      info.value = "Error: ${e.toString()}";
    }
  }

  Future<void> checkAndRequestPermissions() async {
    // Use a Map to check multiple permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    if (statuses[Permission.bluetoothScan]!.isGranted &&
        statuses[Permission.bluetoothConnect]!.isGranted) {
      hasPermission.value = true;
    } else {
      hasPermission.value = false;
      // If permanently denied, open app settings
      if (statuses[Permission.bluetoothScan]!.isPermanentlyDenied) {
        await openAppSettings();
      }
    }
  }

  Future<void> getBluetooths() async {
    try {
      final permission =
          await PrintBluetoothThermal.isPermissionBluetoothGranted;
      hasPermission.value = permission;
      if (!hasPermission.value) {
        msj.value = "Bluetooth permission denied.";
        return;
      }

      progress.value = true;
      msjProgress.value = "Searching...";
      items.value = await PrintBluetoothThermal.pairedBluetooths;
      progress.value = false;

      msj.value = items.isEmpty
          ? "No paired devices found."
          : "Select a printer.";

      final bool result = await PrintBluetoothThermal.bluetoothEnabled;

      isBluetoothOn.value = result;
    } catch (e) {
      msj.value = "Error: ${e.toString()}";
      progress.value = false;
    }
  }

  Future<void> connect(String mac) async {
    print(mac);
    progress.value = true;
    final result = await PrintBluetoothThermal.connect(macPrinterAddress: mac);
    isConnected.value = result;
    progress.value = false;
  }

  Future<void> disconnect() async {
    await PrintBluetoothThermal.disconnect; // ✅ fixed
    isConnected.value = false;
  }

  Future<void> printTest(List<int> bytes) async {
    bool status = await PrintBluetoothThermal.connectionStatus;
    isConnected.value = status;
    if (!status) {
      Get.snackbar(
        "Printer not connected",
        "Please connect a Bluetooth printer before printing.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      // base64.decode() returns a Uint8List, which is sent over the method
      // channel as a Java byte[]. The plugin expects a java.util.List, so
      // convert it to a plain List<int> to avoid:
      // "byte[] cannot be cast to java.util.List".
      final List<int> payload = bytes is Uint8List
          ? List<int>.from(bytes)
          : bytes;
      await PrintBluetoothThermal.writeBytes(payload);
    } catch (e) {
      Get.snackbar(
        "Print error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
