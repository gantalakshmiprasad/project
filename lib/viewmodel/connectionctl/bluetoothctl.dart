import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
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

  Future<void> printTest() async {
    bool status = await PrintBluetoothThermal.connectionStatus;
    if (!status) return;

    // 1. Load profile and generator
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    // 2. Build bytes
    List<int> bytes = [];
    bytes += generator.text("My name is lakshmiprasad");
    bytes += generator.feed(2);
    bytes += generator.cut();

    // 3. Send to printer
    await PrintBluetoothThermal.writeBytes(bytes);
  }
}
