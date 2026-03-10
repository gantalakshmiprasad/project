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
        return Row(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  width: Get.width * 0.75,
                  height: Get.height,
                  child: controller.database.isNotEmpty
                      ? ListView.builder(
                          itemCount: controller.database.length,
                          itemBuilder: (context, index) {
                            final product = controller.database[0];

                            return Text('Data received $product');
                          },
                        )
                      : Center(
                          child: Defaultext(
                            text: 'No data',
                            size: 55,
                            color: Colors.red,
                          ),
                        ),
                ),
                controller.isimageclicked.value
                    ? Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 350,
                          width: 500,
                          padding: const EdgeInsets.all(8.0),
                          child: itemform(controller),
                        ),
                      )
                    : Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: addbutton(controller),
                        ),
                      ),
              ],
            ),
            SizedBox(child: Text('print area  ')),
          ],
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
        FloatingActionButton(
          onPressed: () {
            controller.opendialog();
          },
          child: Icon(Icons.add),
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
          controller.closedialog();
        },
        icon: Icon(Icons.cancel),
      ),
    ],
  );
}

////////////////////////////////////////////////////
