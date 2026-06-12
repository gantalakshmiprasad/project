import 'dart:typed_data';
import 'package:firstproject/viewmodel/bussinesslogicctl/themecontroller.dart';
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
  final isDark = Get.isDarkMode;
  return TextFormField(
    controller: controller,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter the $hint';
      }
      return null;
    },
    obscureText: isPassword,
    style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1E293B)),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: isDark ? Colors.white38 : Colors.black38,
        fontSize: 14,
      ),
      filled: true,
      fillColor: isDark ? const Color(0xFF0B1517) : const Color(0xFFF1F5F9),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF1E4D55) : Colors.grey.shade300,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF2DD4BF) : const Color(0xFF0D9488),
          width: 1.5,
        ),
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
  final bool isdark;

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
    required this.isdark,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = quantity > 0;
    final isDark = isdark;

    Color activeAccent = isDark
        ? const Color(0xFF2DD4BF)
        : const Color(0xFF0D9488);
    Color priceColor = isDark
        ? const Color(0xFFF59E0B)
        : const Color(0xFFD97706);

    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F262A) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: !available
                  ? const Color(0xFFFB7185)
                  : isSelected
                  ? activeAccent
                  : (isDark ? const Color(0xFF1E4D55) : Colors.grey.shade200),
              width: isSelected ? 2.0 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected ? activeAccent : Colors.black12,
                blurRadius: isSelected ? 5 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
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
                        Positioned.fill(
                          child: Container(decoration: const BoxDecoration()),
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
                                color: activeAccent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "$quantity Selected",
                                style: TextStyle(
                                  color: isDark
                                      ? const Color(0xFF0B1517)
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
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
                        // FIX: Substantially bumped layout typography size for scannability
                        Text(
                          itemName,
                          style: TextStyle(
                            fontSize: 18, // Increased from 14
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1E293B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        AutoSizeText(
                          "₹$price",
                          style: TextStyle(
                            fontSize: 20, // Increased from 18
                            fontWeight: FontWeight.bold,
                            color: available
                                ? priceColor
                                : const Color(0xFFFB7185),
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Divider(
                    color: isDark
                        ? const Color.fromARGB(255, 17, 178, 206)
                        : Colors.grey.shade200,
                    height: 1,
                  ),
                  SizedBox(
                    height: 52,
                    child: _buildInteractionControls(isDark, activeAccent),
                  ),
                ],
              ),
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
                  color: available ? activeAccent : const Color(0xFFFB7185),
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
    );
  }

  Widget _buildInteractionControls(bool isDark, Color activeAccent) {
    if (!available) {
      return const Center(
        child: Text(
          'OUT OF STOCK',
          style: TextStyle(
            color: Color(0xFFFB7185),
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      );
    }

    bool hasItem = quantity > 0;

    return Container(
      color: hasItem
          ? (isDark
                ? const Color.fromARGB(255, 1, 49, 57)
                : const Color(0xFFCCFBF1))
          : Colors.transparent,
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
                  color: hasItem
                      ? activeAccent
                      : (isDark ? Colors.white : Colors.black38),
                ),
              ),
            ),
          ),

          Expanded(
            child: Center(
              child: Text(
                '$quantity',
                style: TextStyle(
                  color: hasItem
                      ? activeAccent
                      : (isDark ? Colors.white : const Color(0xFF1E293B)),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Expanded(
            child: InkWell(
              onTap: increase,
              child: Center(
                child: Icon(Icons.add, size: 25, color: activeAccent),
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
    final isDark = Get.isDarkMode;
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F262A) : Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isDark ? const Color(0xFF2DD4BF) : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black45 : Colors.grey.shade400,
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
              Text(
                'Add New Inventory Item',
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
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
                    backgroundColor: isDark
                        ? const Color(0xFF2DD4BF)
                        : const Color(0xFF0D9488),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: submit,
                  child: Text(
                    'Save to Catalog',
                    style: TextStyle(
                      color: isDark ? const Color(0xFF0B1517) : Colors.white,
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
    final isDark = Get.isDarkMode;
    // FIX: Fallback logic prevents elements from masking completely inside dark canvases
    Color functionalColor = color;
    if (isDark && (color == Colors.black || color == const Color(0xFF1E293B))) {
      functionalColor = Colors.white;
    } else if (!isDark && color == Colors.white) {
      functionalColor = const Color(0xFF1E293B);
    }

    return Text(
      text,
      style: TextStyle(
        color: functionalColor,
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

Widget addbutton(Homepagecontroller controller) {
  final isDark = Get.isDarkMode;
  return Padding(
    padding: const EdgeInsets.all(12),
    child: FloatingActionButton(
      backgroundColor: isDark
          ? const Color(0xFFF59E0B)
          : const Color(0xFFD97706),
      onPressed: () => controller.opendialog(),
      child: Icon(Icons.add, color: isDark ? Colors.black : Colors.white),
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
          color: Get.isDarkMode ? Colors.white60 : Colors.black54,
          hoverColor: Colors.black12,
          onPressed: () => controller.closedialog(),
          icon: const Icon(Icons.close_rounded, size: 24),
        ),
      ),
    ],
  );
}

AppBar appbar(Homepagecontroller controller) {
  final themeCtrl = Get.find<ThemeController>();

  return AppBar(
    backgroundColor: Get.isDarkMode ? const Color(0xFF0F262A) : Colors.white,
    elevation: 0,
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(1),
      child: Container(
        color: Get.isDarkMode ? const Color(0xFF1E4D55) : Colors.grey.shade200,
        height: 1,
      ),
    ),
    automaticallyImplyLeading: Get.width <= 900,
    iconTheme: IconThemeData(
      color: Get.isDarkMode ? Colors.white70 : const Color(0xFF1E293B),
    ),
    title: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Get.isDarkMode
                ? const Color(0xFF2DD4BF)
                : const Color(0xFF0D9488),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.bolt, size: 22, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Text(
          'UBS Workspace',
          style: TextStyle(
            color: Get.isDarkMode ? Colors.white : const Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    ),
    actions: [
      // FIX: Wrapped theme switch button with Obx to guarantee immediate visual state updates
      Obx(() {
        final darkState = themeCtrl.isDark;
        return IconButton(
          tooltip: 'Toggle Theme Layout',
          icon: Icon(
            darkState ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            color: darkState
                ? const Color(0xFFF59E0B)
                : const Color(0xFF64748B),
          ),
          onPressed: () {
            ThemeMode targetMode = Get.isDarkMode
                ? ThemeMode.light
                : ThemeMode.dark;
            Get.changeThemeMode(targetMode);

            // Sync up theme changes with controller status flag parameters if tracking reactively
          },
        );
      }),
      TextButton(
        onPressed: () => Get.toNamed('/analytics'),
        child: Text('Analytics', style: TextStyle(color: Colors.white)),
      ),
      TextButton.icon(
        onPressed: () => Get.toNamed('/paymentpage'),
        icon: Icon(
          Icons.stars_rounded,
          color: Get.isDarkMode
              ? const Color(0xFFF59E0B)
              : const Color(0xFFD97706),
          size: 18,
        ),
        label: Text(
          'Plans',
          style: TextStyle(
            color: Get.isDarkMode ? Colors.white : const Color(0xFF1E293B),
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
          icon: Icon(
            Icons.history_toggle_off_rounded,
            color: Get.isDarkMode ? Colors.white70 : const Color(0xFF64748B),
          ),
        ),
        IconButton(
          tooltip: 'Manual Entry Append',
          onPressed: () => controller.opendialog(),
          icon: Icon(
            Icons.add_box_outlined,
            color: Get.isDarkMode ? Colors.white70 : const Color(0xFF64748B),
          ),
        ),
        IconButton(
          tooltip: 'Log Out Session',
          onPressed: () => _handleLogoutSignOut(controller),
          icon: const Icon(Icons.logout_rounded, color: Color(0xFFFB7185)),
        ),
      ],
      const SizedBox(width: 16),
    ],
  );
}

Widget buildMobileNavigationDrawer(Homepagecontroller controller) {
  final isDark = Get.isDarkMode;
  return Drawer(
    child: Container(
      color: isDark ? const Color(0xFF0F262A) : Colors.white,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF07171A) : const Color(0xFFF1F5F9),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.analytics_outlined,
                    color: isDark
                        ? const Color(0xFF2DD4BF)
                        : const Color(0xFF0D9488),
                    size: 44,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Universal Billing Engine",
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.add_box_outlined,
              color: isDark ? Colors.white70 : const Color(0xFF64748B),
            ),
            title: Text(
              'Append Catalog Item',
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
            onTap: () {
              Get.back();
              controller.opendialog();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.history_rounded,
              color: isDark ? Colors.white70 : const Color(0xFF64748B),
            ),
            title: Text(
              'Ledger History Logs',
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
            onTap: () {
              Get.back();
              Get.offAllNamed('/billshistory');
            },
          ),
          const Spacer(),
          Divider(color: isDark ? Colors.white12 : Colors.grey.shade200),
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
  final isDark = Get.isDarkMode;
  Get.defaultDialog(
    backgroundColor: isDark ? const Color(0xFF0F262A) : Colors.white,
    title: 'Purge Directory Catalog?',
    titleStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      color: Color(0xFFFB7185),
      fontSize: 18,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    content: Text(
      'This will clear out your local cache directory completely. This structural operation cannot be undone.',
      style: TextStyle(
        color: isDark ? Colors.white70 : const Color(0xFF64748B),
        fontSize: 14,
        height: 1.4,
      ),
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
        side: BorderSide(color: isDark ? Colors.white24 : Colors.grey.shade300),
      ),
      onPressed: () => Get.back(),
      child: Text(
        'Abort',
        style: TextStyle(
          color: isDark ? Colors.white70 : const Color(0xFF64748B),
        ),
      ),
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
