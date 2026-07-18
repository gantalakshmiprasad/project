import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:universal_ble/universal_ble.dart';

class UniversalBleController extends GetxService {
  // Observable variables to track state

  var isScanning = false.obs;
  var connectedDevice = Rxn<BleDevice>();
  var connectionState = BleConnectionState.disconnected.obs;
  var discoveredDevices = [].obs;

  @override
  void onInit() {
    super.onInit();

    // Listen for scan results
    UniversalBle.onScanResult = (bleDevice) {
      // Check if the device is already in the list (by deviceId)
      if (!discoveredDevices.any((d) => d.deviceId == bleDevice.deviceId)) {
        discoveredDevices.add(bleDevice);
      }
    };
  }

  // 1. Scan for devices
  Future<void> startScan() async {
    isScanning.value = true;
    await UniversalBle.startScan();
  }

  Future<void> stopScan() async {
    await UniversalBle.stopScan();
    isScanning.value = false;
  }

  // 2. Connect to device
  Future<void> connectToDevice(BleDevice device) async {
    await stopScan();
    await device.connect();
    connectedDevice.value = device;

    // Listen to connection changes
    device.connectionStream.listen((isConnected) {
      connectionState.value = isConnected
          ? BleConnectionState.connected
          : BleConnectionState.disconnected;
    });
  }

  // 3. Write data (e.g., ESC/POS commands)
  Future<void> writeData(
    String serviceUuid,
    String charUuid,
    Uint8List data,
  ) async {
    if (connectedDevice.value == null) return;

    try {
      // Get the specific characteristic
      final characteristic = await connectedDevice.value!.getCharacteristic(
        charUuid,
        service: serviceUuid,
      );

      // Write to the printer
      await characteristic.write(data, withResponse: false);
    } catch (e) {
      Get.snackbar("Error", "Failed to send data: $e");
    }
  }

  // 4. Disconnect
  Future<void> disconnect() async {
    await connectedDevice.value?.disconnect();
    connectedDevice.value = null;
  }
}
