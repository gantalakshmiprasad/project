// ignore_for_file: unused_element

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart';
import 'package:get/get.dart';

class BluetoothPrinter {
  int? id;
  String? deviceName;
  String? address;
  String? port;
  String? vendorId;
  String? productId;
  bool? isBle;
  PrinterType typePrinter;
  bool? state;

  BluetoothPrinter({
    this.id,
    this.deviceName,
    this.address,
    this.port,
    this.state,
    this.vendorId,
    this.productId,
    this.typePrinter = PrinterType.bluetooth,
    this.isBle = false,
  });
}

class XPrinterController extends GetxController {
  final printerManager = PrinterManager.instance;

  StreamSubscription<PrinterDevice>? _subscription;
  StreamSubscription<BTStatus>? _subscriptionBtStatus;
  StreamSubscription<USBStatus>? _subscriptionUsbStatus;

  final ipController = TextEditingController();
  final portController = TextEditingController();

  final defaultPrinterType = PrinterType.bluetooth.obs;
  final isBle = false.obs;
  final reconnect = false.obs;
  final isConnected = false.obs;
  final devices = <BluetoothPrinter>[].obs;
  final selectedPrinter = Rxn<BluetoothPrinter>();

  final _currentStatus = BTStatus.none.obs;
  final _currentUsbStatus = USBStatus.none.obs;

  List<int>? pendingTask;
  String _ipAddress = '';
  String _port = '9100';

  @override
  void onInit() {
    super.onInit();
    portController.text = _port;

    if (Platform.isWindows || Platform.isLinux) {
      defaultPrinterType.value = PrinterType.usb;
    }

    _initStatusStreams();
    startScan();
  }

  void _initStatusStreams() {
    _subscriptionBtStatus = printerManager.stateBluetooth.listen((status) {
      log(' ----------------- status bt $status ------------------ ');
      _currentStatus.value = status;
      isConnected.value = (status == BTStatus.connected);

      if (status == BTStatus.connected && pendingTask != null) {
        if (Platform.isAndroid || Platform.isIOS) {
          printerManager.send(type: PrinterType.bluetooth, bytes: pendingTask!);
          pendingTask = null;
        }
      }
    });

    _subscriptionUsbStatus = printerManager.stateUSB.listen((status) {
      log(' ----------------- status usb $status ------------------ ');
      _currentUsbStatus.value = status;

      if (Platform.isAndroid &&
          status == USBStatus.connected &&
          pendingTask != null) {
        printerManager.send(type: PrinterType.usb, bytes: pendingTask!);
        pendingTask = null;
      }
    });
  }

  void startScan() {
    devices.clear();
    _subscription?.cancel();

    _subscription = printerManager
        .discovery(type: defaultPrinterType.value, isBle: isBle.value)
        .listen((device) {
          devices.add(
            BluetoothPrinter(
              deviceName: device.name,
              address: device.address,
              isBle: isBle.value,
              vendorId: device.vendorId,
              productId: device.productId,
              typePrinter: defaultPrinterType.value,
            ),
          );
        });
  }

  /// Prints raw precompiled byte buffers returned from Appwrite functions
  Future<void> printRawBytes(List<int> rawBytes) async {
    // Linux Native Execution Mode Direct Path Fallbacks
    if (Platform.isLinux) {
      if (selectedPrinter.value?.typePrinter == PrinterType.network &&
          selectedPrinter.value?.address != null) {
        await _printToNetworkLinux(selectedPrinter.value!.address!, rawBytes);
        return;
      } else {
        // Defaults to USB file system channel manipulation node
        await _printToUsbLinux(rawBytes);
        return;
      }
    }

    // Cross-Platform Mobile Fallbacks
    if (selectedPrinter.value == null) {
      Get.snackbar(
        'Printer Error',
        'Please choose and pair an active receipt hardware target device first.',
      );
      return;
    }

    final printer = selectedPrinter.value!;
    await connectDevice();

    if (printer.typePrinter == PrinterType.bluetooth && Platform.isAndroid) {
      if (_currentStatus.value == BTStatus.connected) {
        await printerManager.send(type: printer.typePrinter, bytes: rawBytes);
      } else {
        pendingTask = rawBytes;
      }
    } else {
      await printerManager.send(type: printer.typePrinter, bytes: rawBytes);
    }
  }

  /// Raw socket injection handler for Linux Desktop environments
  Future<void> _printToNetworkLinux(
    String ipAddress,
    List<int> rawBytes, {
    int port = 9100,
  }) async {
    try {
      final socket = await Socket.connect(
        ipAddress,
        port,
        timeout: const Duration(seconds: 5),
      );
      socket.add(rawBytes);
      await socket.flush();
      await socket.close();
      Get.log("Appwrite bytes sent over local Linux network socket.");
    } catch (e) {
      Get.snackbar(
        'Linux Network Error',
        'Failed writing data stream to raw network printer socket: $e',
      );
    }
  }

  /// Direct raw kernel device-node driver write handler for Linux Desktop USB connections
  Future<void> _printToUsbLinux(
    List<int> rawBytes, {
    String devicePath = '/dev/usb/lp0',
  }) async {
    try {
      final printerDevice = File(devicePath);
      if (await printerDevice.exists()) {
        await printerDevice.writeAsBytes(rawBytes);
        Get.log(
          "Appwrite receipt bytes committed directly to Linux subsystem device node at $devicePath",
        );
      } else {
        Get.snackbar(
          'Linux Hardware Error',
          'Could not locate device file descriptor node paths at $devicePath.',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Permissions Error',
        'Access to $devicePath denied. Run: sudo usermod -aG lp \$USER',
      );
    }
  }

  void changePrinterType(PrinterType type) {
    defaultPrinterType.value = type;
    selectedPrinter.value = null;
    isBle.value = false;
    isConnected.value = false;
    startScan();
  }

  void toggleBle(bool value) {
    isBle.value = value;
    isConnected.value = false;
    selectedPrinter.value = null;
    startScan();
  }

  void setIpAddress(String value) {
    _ipAddress = value;
    var device = BluetoothPrinter(
      deviceName: value,
      address: _ipAddress,
      port: _port,
      typePrinter: PrinterType.network,
      state: false,
    );
    selectDevice(device);
  }

  void setPort(String value) {
    if (value.isEmpty) value = '9100';
    _port = value;
    var device = BluetoothPrinter(
      deviceName: _port,
      address: _ipAddress,
      port: _port,
      typePrinter: PrinterType.network,
      state: false,
    );
    selectDevice(device);
  }

  void selectDevice(BluetoothPrinter device) async {
    if (selectedPrinter.value != null) {
      if ((device.address != selectedPrinter.value!.address) ||
          (device.typePrinter == PrinterType.usb &&
              selectedPrinter.value!.vendorId != device.vendorId)) {
        await printerManager.disconnect(
          type: selectedPrinter.value!.typePrinter,
        );
      }
    }
    selectedPrinter.value = device;
  }

  Future<void> connectDevice() async {
    if (selectedPrinter.value == null) return;
    final printer = selectedPrinter.value!;

    switch (printer.typePrinter) {
      case PrinterType.usb:
        await printerManager.connect(
          type: printer.typePrinter,
          model: UsbPrinterInput(
            name: printer.deviceName,
            productId: printer.productId,
            vendorId: printer.vendorId,
          ),
        );
        isConnected.value = true;
        break;
      case PrinterType.bluetooth:
        await printerManager.connect(
          type: printer.typePrinter,
          model: BluetoothPrinterInput(
            name: printer.deviceName,
            address: printer.address!,
            isBle: printer.isBle ?? false,
            autoConnect: reconnect.value,
          ),
        );
        break;
      case PrinterType.network:
        await printerManager.connect(
          type: printer.typePrinter,
          model: TcpPrinterInput(ipAddress: printer.address!),
        );
        isConnected.value = true;
        break;
    }
  }

  Future<void> disconnectDevice() async {
    if (selectedPrinter.value != null) {
      await printerManager.disconnect(type: selectedPrinter.value!.typePrinter);
    }
    isConnected.value = false;
  }

  void _executePrintBytes(List<int> bytes, Generator generator) async {
    if (selectedPrinter.value == null) return;
    final printer = selectedPrinter.value!;

    bytes += generator.feed(2);
    bytes += generator.cut();

    await connectDevice();

    if (printer.typePrinter == PrinterType.bluetooth && Platform.isAndroid) {
      if (_currentStatus.value == BTStatus.connected) {
        await printerManager.send(type: printer.typePrinter, bytes: bytes);
      } else {
        pendingTask = bytes;
      }
    } else {
      await printerManager.send(type: printer.typePrinter, bytes: bytes);
    }
  }

  @override
  void onClose() {
    _subscription?.cancel();
    _subscriptionBtStatus?.cancel();
    _subscriptionUsbStatus?.cancel();
    ipController.dispose();
    portController.dispose();
    super.onClose();
  }
}
