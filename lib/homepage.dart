import 'package:firstproject/homepagecontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Homepagecontroller());
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 150),
            Obx(() {
              return controller.hasimage.value
                  ? Image.network(controller.imageurl.value)
                  : Text('No image yet');
            }),
            SizedBox(
              width: 400,
              child: TextFormField(
                decoration: InputDecoration(hintText: 'enter the prompt'),
              ),
            ),
            SizedBox(height: 48),
            SizedBox(
              width: 400,
              child: ElevatedButton(
                onPressed: () {
                  controller.clicked(controller.prompt.text);
                },
                child: Text('press'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
