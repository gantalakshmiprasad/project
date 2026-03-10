import 'dart:typed_data';

import 'package:flutter/material.dart';

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
  final double price;
  final int quantity;
  final VoidCallback onBuyPressed;
  final VoidCallback decrease;
  final VoidCallback increase;

  final bool available;
  //final Uint8List imageurl;
  const ItemCard({
    super.key,
    // required this.imageUrl,
    required this.itemName,
    required this.price,
    required this.onBuyPressed,

    required this.available,
    required this.decrease,
    required this.increase,
    required this.quantity,
    //  required this.imageurl,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize a unique controller for this specific item

    return Card(
      elevation: 15,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(25),
      ),
      child: SizedBox(
        height: 250,
        width: 200,
        child: Column(
          children: [
            //Flexible(child: ClipRect(child: Image.memory(imageurl))),
            SizedBox(height: 150, width: 150),
            Text(
              'Price : $price /-',
              style: TextStyle(
                color: Colors.green,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: decrease,
                  icon: Icon(Icons.remove, size: 35),
                ),
                Text(
                  '$quantity',
                  style: TextStyle(color: Colors.green, fontSize: 35),
                ),
                IconButton(
                  onPressed: increase,
                  icon: Icon(Icons.add, size: 35),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////////
class Itemdialog extends StatelessWidget {
  final TextEditingController namecontroller;
  final TextEditingController pricecontroller;
  final VoidCallback submit;
  const Itemdialog({
    super.key,
    required this.namecontroller,
    required this.pricecontroller,
    required this.submit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 350,
        width: 600,
        padding: EdgeInsets.all(55),
        decoration: BoxDecoration(
          color: const Color.fromARGB(163, 249, 66, 25),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(119, 63, 63, 63),
              spreadRadius: 600,
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
              child: Defaultext(text: 'Submit', size: 20, color: Colors.green),
            ),
          ],
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
      style: TextStyle(color: color, fontSize: size),
    );
  }
}
//////////////////////////////////////////////