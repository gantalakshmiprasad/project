import 'dart:typed_data';

import 'package:firstproject/viewmodel/bussinesslogicctl/Homepagecontroller.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildTextField({
  required String hint,
  bool isPassword = false,
  required TextEditingController controller,
}) {
  return TextFormField(
    controller: controller,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return '! Please enter the $hint';
      }
      return null;
    },

    obscureText: isPassword,
    style: const TextStyle(color: Colors.black),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.black38),
      filled: true,
      fillColor: Colors.white54,

      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );
}

/////////////////////////////////////////////////////////////
class ItemCard extends StatelessWidget {
  //final Uint8List imageUrl;
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
    // required this.imageUrl,
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
    // Initialize a unique controller for this specific item

    return Stack(
      alignment: Alignment.topRight,
      children: [
        Card(
          borderOnForeground: false,

          elevation: 15,
          color: quantity > 0 ? Colors.orange : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(25),
            side: BorderSide(color: available ? Colors.green : Colors.red),
          ),

          child: SizedBox(
            height: 300,
            width: 220,
            child: Column(
              children: [
                Flexible(
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(25),
                    child: SizedBox(
                      height: 150,
                      width: double.infinity,
                      child: Image.memory(imageurl, fit: BoxFit.cover),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AutoSizeText(
                      itemName,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F1F1F),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 10, // smallest font size allowed
                      maxFontSize: 18, // largest font size allowed
                    ),
                    AutoSizeText(
                      "Rs:$price/-",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: available ? Color(0xFF009688) : Colors.red,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 10, // smallest font size allowed
                      maxFontSize: 18, // largest font size allowed
                    ),
                  ],
                ),

                Divider(color: Colors.blue),
                available
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: decrease,

                            icon: Icon(Icons.remove, size: 20),
                          ),
                          Text(
                            '$quantity',
                            style: TextStyle(color: Colors.blue, fontSize: 25),
                          ),
                          IconButton(
                            onPressed: increase,
                            icon: Icon(Icons.add, size: 20),
                          ),
                        ],
                      )
                    : Text(
                        'Sold out',
                        style: TextStyle(color: Colors.red, fontSize: 25),
                      ),
              ],
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: onedit,
              icon: available
                  ? Icon(Icons.toggle_on, color: Colors.green)
                  : Icon(Icons.toggle_off, color: Colors.red),
            ),
            IconButton(
              tooltip: 'delete',
              onPressed: ondelete,
              icon: Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
      ],
    );
  }
}

/////////////////////////////////////////////////////////////////////
class Itemdialog extends StatelessWidget {
  final TextEditingController namecontroller;
  final TextEditingController pricecontroller;
  final VoidCallback submit;
  final GlobalKey formkey;
  const Itemdialog({
    super.key,
    required this.namecontroller,
    required this.pricecontroller,
    required this.submit,
    required this.formkey,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: 600,
        child: Form(
          key: formkey,
          child: Container(
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: const Color.fromARGB(141, 108, 251, 72),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  spreadRadius: 0.5,
                  blurRadius: 1.5,
                ),
              ],
            ),
            child: Column(
              children: [
                Defaultext(text: 'Add item', size: 25, color: Colors.black),
                SizedBox(height: 15),
                buildTextField(hint: 'Item name', controller: namecontroller),
                SizedBox(height: 15),
                buildTextField(hint: 'Price', controller: pricecontroller),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: submit,
                  child: Defaultext(
                    text: 'Submit',
                    size: 20,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

///////////////////////////////////////////
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

////////////////////////////////////////////////////

Widget addbutton(Homepagecontroller controller) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: FloatingActionButton(
      backgroundColor: Colors.amber,
      onPressed: () {
        controller.opendialog();
      },
      child: Icon(Icons.add),
    ),
  );
}

Stack itemform(Homepagecontroller controller) {
  return Stack(
    alignment: AlignmentGeometry.topRight,
    children: [
      Itemdialog(
        formkey: controller.formkey,
        namecontroller: controller.namecontroller,
        pricecontroller: controller.pricecontroller,
        submit: () {
          if (controller.formkey.currentState!.validate()) {
            Get.showOverlay(
              asyncFunction: () => controller.submit(
                controller.namecontroller.text,
                controller.pricecontroller.text,
              ),
              loadingWidget: const Center(
                child: CircularProgressIndicator(color: Colors.green),
              ),
              opacity: 0.5,
              opacityColor: Colors.black,
            );
          }

          controller.namecontroller.text = '';
          controller.pricecontroller.text = '';
        },
      ),

      IconButton(
        padding: EdgeInsets.all(25),
        color: Colors.white,
        onPressed: () {
          controller.closedialog();
        },
        icon: Icon(Icons.cancel),
      ),
    ],
  );
}

AppBar appbar(Homepagecontroller controller) {
  return AppBar(
    backgroundColor: Color(0xFF263238),

    title: Text(
      'UBS',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 35,
      ),
    ),
    actionsPadding: EdgeInsets.only(right: 30),
    actions: [
      IconButton(
        tooltip: 'Bills',

        onPressed: () {
          Get.toNamed('/billshistory');
        },
        icon: Icon(Icons.history, color: Colors.white),
      ),
      IconButton(
        tooltip: 'Add Items',

        onPressed: () {
          controller.opendialog();
        },
        icon: Icon(Icons.add, color: Colors.white),
      ),
      IconButton(
        tooltip: 'Sign Out',
        onPressed: () {
          controller.onclosed(controller.database);
        },
        icon: Icon(Icons.logout, color: Colors.white),
      ),
    ],
  );
}
