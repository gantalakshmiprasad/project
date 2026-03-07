import 'package:firstproject/customs/customwidgets.dart';
import 'package:firstproject/customs/uicustoms.dart';
import 'package:firstproject/viewmodel/Authenticationctl/forgotpasswordctl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Forgotpassword extends StatelessWidget {
  const Forgotpassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Forgotpasswordctl());
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: Appcolors().gradient1),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(55),
            width: 600,
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.orange),
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: Column(
              children: [
                Text(
                  'Enter Email',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                SizedBox(height: 20),
                buildTextField(controller: controller.email, hint: 'email'),
                SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(20),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    controller.enter(controller.email.text);
                  },
                  child: Text(
                    'Enter',
                    style: TextStyle(color: Colors.white, fontSize: 25),
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
