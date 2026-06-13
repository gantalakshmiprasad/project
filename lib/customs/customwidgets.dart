import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:lottie/lottie.dart';

import 'package:firstproject/customs/config.dart';
import 'package:firstproject/viewmodel/bussinesslogicctl/Homepagecontroller.dart';

/// 1. Clean Custom Input Text Fields
Widget buildTextField({
  required String hint,
  bool isPassword = false,
  required TextEditingController controller,
}) {
  return TextFormField(
    controller: controller,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter the $hint';
      }
      return null;
    },
    obscureText: isPassword,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 14),
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFFB7185)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFFB7185), width: 1.5),
      ),
    ),
  );
}

/// 2. Clear System-Font Item Card Panel
class ItemCard extends StatelessWidget {
  final String itemName;
  final String price;
  final int quantity;
  final Callback decrease;
  final Callback increase;
  final bool available;
  final Uint8List imageurl;
  final Callback onedit;
  final Callback ondelete;

  const ItemCard({
    super.key,
    required this.itemName,
    required this.price,
    required this.available,
    required this.decrease,
    required this.increase,
    required this.quantity,
    required this.imageurl,
    required this.onedit,
    required this.ondelete,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = quantity > 0;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: available ? Colors.black : Colors.red),
        borderRadius: BorderRadius.circular(24),
        color: available
            ? isSelected
                  ? Colors.orange
                  : const Color.fromARGB(230, 0, 55, 77)
            : Colors.red,
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Opacity(
              opacity: available ? 1.0 : 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 11,
                    child: Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: Image.memory(imageurl, fit: BoxFit.cover),
                        ),

                        if (isSelected && available)
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Text(
                                "$quantity Selected",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          itemName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        AutoSizeText(
                          "₹$price",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Divider(height: 1),
                  SizedBox(height: 52, child: _buildInteractionControls()),
                ],
              ),
            ),
          ),
          Positioned(
            top: 6,
            right: 6,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: available ? 'Mark sold out' : 'Mark available',
                  onPressed: onedit,
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(6),
                  icon: Icon(
                    available ? Icons.check_circle : Icons.do_not_disturb_on,
                    color: available ? Colors.green : const Color(0xFFFB7185),
                    size: 22,
                  ),
                ),
                IconButton(
                  tooltip: 'delete item',
                  onPressed: ondelete,
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(6),
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFFFB7185),
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionControls() {
    if (!available) {
      return const Center(
        child: Text(
          'OUT OF STOCK',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      );
    }

    bool hasItem = quantity > 0;

    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: InkWell(
              onTap: decrease,
              child: Center(
                child: Icon(
                  Icons.remove,
                  size: 25,
                  color: hasItem ? Colors.white : Colors.white60,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '$quantity',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: increase,
              child: Center(
                child: Icon(Icons.add, size: 25, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 3. Clear Dialog Structure
class Itemdialog extends StatelessWidget {
  final TextEditingController namecontroller;
  final TextEditingController pricecontroller;
  final VoidCallback submit;
  final GlobalKey<FormState> formkey;

  const Itemdialog({
    super.key,
    required this.namecontroller,
    required this.pricecontroller,
    required this.submit,
    required this.formkey,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              spreadRadius: 5,
              blurRadius: 25,
            ),
          ],
        ),
        child: Form(
          key: formkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New Inventory Item',
                style: TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              buildTextField(hint: 'Item name', controller: namecontroller),
              const SizedBox(height: 16),
              buildTextField(hint: 'Price (INR)', controller: pricecontroller),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D9488),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: submit,
                  child: const Text(
                    'Save to Catalog',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Robust Universal Typography Display System
class Defaultext extends StatelessWidget {
  final String text;
  final double size;
  final Color color;

  const Defaultext({
    super.key,
    required this.text,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

Widget addbutton(Homepagecontroller controller) {
  return Padding(
    padding: const EdgeInsets.all(12),
    child: FloatingActionButton(
      backgroundColor: const Color(0xFFD97706),
      onPressed: () => controller.opendialog(),
      child: const Icon(Icons.add, color: Colors.white),
    ),
  );
}

Stack itemform(Homepagecontroller controller) {
  return Stack(
    alignment: Alignment.topRight,
    children: [
      Itemdialog(
        formkey: controller.formkey,
        namecontroller: controller.namecontroller,
        pricecontroller: controller.pricecontroller,
        submit: () {
          if (controller.formkey.currentState!.validate()) {
            controller.submit(
              controller.namecontroller.text,
              controller.pricecontroller.text,
            );
            controller.namecontroller.text = '';
            controller.pricecontroller.text = '';
          }
        },
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: IconButton(
          color: Colors.black54,
          hoverColor: Colors.black12,
          onPressed: () => controller.closedialog(),
          icon: const Icon(Icons.close_rounded, size: 24),
        ),
      ),
    ],
  );
}

AppBar appbar(Homepagecontroller controller) {
  return AppBar(
    backgroundColor: const Color.fromARGB(255, 0, 117, 109),
    elevation: 0,
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(1),
      child: Container(color: Colors.grey.shade200, height: 1),
    ),
    automaticallyImplyLeading: Get.width <= 900,
    iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
    title: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF0D9488),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.bolt, size: 22, color: Colors.white),
        ),
        const SizedBox(width: 12),
        const Text(
          'UBS Workspace',
          style: TextStyle(
            color: Color.fromARGB(255, 230, 232, 235),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    ),
    actionsPadding: EdgeInsets.symmetric(horizontal: 35),

    actions: [
      TextButton(
        onPressed: () => Get.toNamed('/analytics'),
        child: const Text('Analytics', style: TextStyle(color: Colors.white)),
      ),
      TextButton.icon(
        onPressed: () => Get.toNamed('/paymentpage'),
        icon: const Icon(
          Icons.stars_rounded,
          color: Color(0xFFD97706),
          size: 18,
        ),
        label: const Text(
          'Plans',
          style: TextStyle(
            color: Color.fromARGB(255, 254, 254, 255),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const SizedBox(width: 8),
      IconButton(
        tooltip: 'Purge Catalog Logs',
        onPressed: () => _showDeleteAllItemsDialog(controller),
        icon: const Icon(Icons.delete_sweep_outlined, color: Color(0xFFFB7185)),
      ),
      if (Get.width > 900) ...[
        IconButton(
          tooltip: 'Ledger Registry History',
          onPressed: () => Get.offAllNamed('/billshistory'),
          icon: const Icon(
            Icons.history_toggle_off_rounded,
            color: Colors.white,
          ),
        ),
        IconButton(
          tooltip: 'Manual Entry Append',
          onPressed: () => controller.opendialog(),
          icon: const Icon(Icons.add_box_outlined, color: Colors.white),
        ),
        IconButton(
          tooltip: 'Log Out Session',
          onPressed: () => _handleLogoutSignOut(controller),
          icon: const Icon(
            Icons.logout_rounded,
            color: Color.fromARGB(255, 255, 128, 82),
          ),
        ),
      ],
    ],
  );
}

Widget buildMobileNavigationDrawer(Homepagecontroller controller) {
  return Drawer(
    child: Container(
      color: Colors.white,
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFFF1F5F9)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.analytics_outlined,
                    color: Color(0xFF0D9488),
                    size: 44,
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Universal Billing Engine",
                    style: TextStyle(
                      color: Color(0xFF1E293B),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.add_box_outlined,
              color: Color(0xFF64748B),
            ),
            title: const Text(
              'Append Catalog Item',
              style: TextStyle(color: Color(0xFF1E293B)),
            ),
            onTap: () {
              Get.back();
              controller.opendialog();
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.history_rounded,
              color: Color(0xFF64748B),
            ),
            title: const Text(
              'Ledger History Logs',
              style: TextStyle(color: Color(0xFF1E293B)),
            ),
            onTap: () {
              Get.back();
              Get.offAllNamed('/billshistory');
            },
          ),
          const Spacer(),
          Divider(color: Colors.grey.shade200),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: Color(0xFFFB7185)),
            title: const Text(
              'Exit Workspace',
              style: TextStyle(
                color: Color(0xFFFB7185),
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Get.back();
              _handleLogoutSignOut(controller);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    ),
  );
}

void _showDeleteAllItemsDialog(Homepagecontroller controller) {
  Get.defaultDialog(
    backgroundColor: Colors.white,
    title: 'Purge Directory Catalog?',
    titleStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      color: Color(0xFFFB7185),
      fontSize: 18,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    content: const Text(
      'This will clear out your local cache directory completely. This structural operation cannot be undone.',
      style: TextStyle(color: Color(0xFF64748B), fontSize: 14, height: 1.4),
      textAlign: TextAlign.center,
    ),
    confirm: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFB7185),
        elevation: 0,
      ),
      onPressed: () {
        Get.back();
        controller.deleteAllItems(ApiConfig().productmodel);
      },
      child: const Text(
        'Purge All',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
    cancel: OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.grey.shade300),
      ),
      onPressed: () => Get.back(),
      child: const Text('Abort', style: TextStyle(color: Color(0xFF64748B))),
    ),
  );
}

void _handleLogoutSignOut(Homepagecontroller controller) {
  Get.showOverlay(
    asyncFunction: () => controller.onclosed(controller.database),
    loadingWidget: Center(
      child: SizedBox(
        width: 150,
        height: 150,
        child: Lottie.asset('assets/animations/loading.json'),
      ),
    ),
  );
}
