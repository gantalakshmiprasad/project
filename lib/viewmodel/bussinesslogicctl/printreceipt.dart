import 'dart:typed_data';
import 'package:usb_device/usb_device.dart';

class UsbPrinterService {
  final UsbDevice usbDevice = UsbDevice();

  Future<void> printReceipt(Uint8List receiptBytes) async {
    try {
      // Use your actual printer IDs
      final pairedDevice = await usbDevice.requestDevices([
        DeviceFilter(vendorId: 0x0483, productId: 0x5840),
      ]);

      if (pairedDevice == null) {
        print("❌ No printer selected.");
        return;
      }

      await usbDevice.open(pairedDevice);

      // Send receipt bytes to endpoint (usually 1 for printers)
      await usbDevice.transferOut(pairedDevice, 1, receiptBytes.buffer);

      print("✅ Receipt sent to printer.");

      await usbDevice.close(pairedDevice);
    } catch (e) {
      print("❌ Printing failed: $e");
    }
  }
}
