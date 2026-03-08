// ignore_for_file: file_names

import 'package:firstproject/customs/customwidgets.dart';
import 'package:firstproject/customs/uicustoms.dart';
import 'package:firstproject/viewmodel/bussinesslogicctl/Homepagecontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Homepagecontroller());
    return Scaffold(
      appBar: appbar(),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: SizedBox(
            height: Get.height,
            width: Get.width * 0.80,

            child: Stack(
              alignment: AlignmentGeometry.bottomRight,
              children: [
                SingleChildScrollView(
                  child: Container(
                    height: Get.height,
                    width: Get.width,
                    color: Colors.white38,
                    child: Row(
                      children: [
                        ItemCard(
                          itemName: 'itemName',
                          price: 50,
                          onBuyPressed: () {},
                          uniqueId: 'uniqueId',
                          available: true,
                          decrease: () {},
                          increase: () {},
                          quantity: 0,
                        ),
                      ],
                    ),
                  ),
                ),
                controller.addclicked.value
                    ? Center(
                        child: SizedBox(
                          width: 500,
                          child: controller.isimageclicked.value
                              ? displayimage(controller)
                              : itemform(controller),
                        ),
                      )
                    : addbutton(controller),
              ],
            ),
          ),
        );
      }),
    );
  }
}

///////////////////////////////////////////////////////
AppBar appbar() {
  return AppBar(
    backgroundColor: Appcolors().buttoncolor,
    title: Text(
      'UBS',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 35,
      ),
    ),
    actions: [
      IconButton(
        onPressed: () {
          Get.offAllNamed('/');
        },
        icon: Icon(Icons.logout, color: Colors.white),
      ),
    ],
  );
}
//////////////////////////////////////////////////

Padding addbutton(Homepagecontroller controller) {
  return Padding(
    padding: const EdgeInsets.all(25),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('Press + to add items', style: TextStyle(color: Colors.black54)),
        SizedBox(width: 15),
        IconButton.filled(
          onPressed: () {
            controller.addclicked.value = true;
          },
          icon: Icon(Icons.add, weight: 5.0),
        ),
      ],
    ),
  );
}

///////////////////////////////////////////////////////////

Stack itemform(Homepagecontroller controller) {
  return Stack(
    alignment: AlignmentGeometry.topRight,
    children: [
      Itemdialog(
        namecontroller: controller.namecontroller,
        pricecontroller: controller.pricecontroller,
        submit: () {
          controller.submit(
            controller.namecontroller.text.trim(),
            controller.pricecontroller.text.trim(),
          );
        },
      ),
      IconButton(
        padding: EdgeInsets.all(25),
        focusColor: Colors.transparent,
        onPressed: () {
          controller.addclicked.value = false;
        },
        icon: Icon(Icons.cancel),
      ),
    ],
  );
}

////////////////////////////////////////////////////

Stack displayimage(Homepagecontroller controller) {
  return Stack(
    alignment: Alignment.topRight,
    children: [
      Container(
        padding: EdgeInsets.all(25),
        height: 400,
        width: 800,
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(controller.imageurl.value, height: 200, width: 220),
          ],
        ),
      ),
      IconButton(
        padding: EdgeInsets.all(25),
        focusColor: Colors.transparent,
        onPressed: () {
          controller.isimageclicked.value = false;
        },
        icon: Icon(Icons.cancel),
      ),
    ],
  );
}
