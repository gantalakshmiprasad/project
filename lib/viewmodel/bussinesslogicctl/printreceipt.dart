import 'dart:typed_data';
import 'package:usb_device/usb_device.dart';

class UsbPrinterService {
  final UsbDevice usbDevice = UsbDevice();

  Future<void> printReceipt(Uint8List receiptBytes) async {
    try {
      // Request device (must be triggered by a user gesture, e.g. button click)
      final pairedDevice = await usbDevice.requestDevices([
        DeviceFilter(vendorId: 0x0483, productId: 0x5840),
      ]);

      if (pairedDevice == null) {
        print("❌ No printer selected.");
        return;
      }

      await usbDevice.open(pairedDevice);

      // Claim interface 0 (most printers use interface 0)
      await usbDevice.claimInterface(pairedDevice, 0);

      // Inspect endpoints
      print("Device configurations: ${pairedDevice.configurations}");

      // Find the OUT endpoint dynamically
      final endpoint = pairedDevice
          .configurations
          .first
          .interfaces
          .first
          .alternates
          .first
          .endpoints
          .firstWhere((e) => e.direction == 'out')
          .endpointNumber;

      // Send receipt bytes
      await usbDevice.transferOut(pairedDevice, endpoint, receiptBytes.buffer);

      print("✅ Receipt sent to printer.");

      await usbDevice.close(pairedDevice);
    } catch (e) {
      print("❌ Printing failed: $e");
    }
  }
}
