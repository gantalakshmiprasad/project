import 'package:firstproject/viewmodel/homepagecontroller.dart';
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
              if (controller.isDownloading.value) {
                return const CircularProgressIndicator();
              }
              if (controller.errorMessage.value.isNotEmpty) {
                return Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                );
              }
              if (controller.imageurl.value.isNotEmpty) {
                return Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    child: Image.network(
                      controller.imageurl.string,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }
              return const Text('No image yet');
            }),

            SizedBox(
              width: 400,
              child: TextFormField(
                controller: controller.prompt,
                decoration: InputDecoration(hintText: 'enter the prompt'),
              ),
            ),
            SizedBox(height: 48),
            SizedBox(
              width: 400,
              child: ElevatedButton(
                onPressed: () {
                  controller.clicked(controller.prompt.text.trim().toString());
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
