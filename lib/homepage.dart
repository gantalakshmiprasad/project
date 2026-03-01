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
              return Text(controller.message.value);
            }),
            TextFormField(
              decoration: InputDecoration(hintText: 'enter the prompt'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.clicked(controller.prompt.text);
              },
              child: Text('press'),
            ),
          ],
        ),
      ),
    );
  }
}
