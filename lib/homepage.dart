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
            Text(
              controller.message.string,
              style: TextStyle(fontSize: 30, color: Colors.blue),
            ),
            ElevatedButton(
              onPressed: () {
                controller.clicked();
              },
              child: Text('press'),
            ),
          ],
        ),
      ),
    );
  }
}
