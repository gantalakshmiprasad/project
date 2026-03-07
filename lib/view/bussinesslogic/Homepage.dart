import 'package:firstproject/customs/uicustoms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: Stack(
        alignment: AlignmentGeometry.bottomRight,
        children: [
          SizedBox(height: Get.height, child: Text('Items')),
          IconButton.filled(onPressed: () {}, icon: Icon(Icons.add)),
        ],
      ),
    );
  }
}
