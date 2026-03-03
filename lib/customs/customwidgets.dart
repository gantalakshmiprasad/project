import 'package:firstproject/customs/uicustoms.dart';
import 'package:flutter/material.dart';

class Dialogbox extends StatelessWidget {
  final TextEditingController email;
  final TextEditingController password;
  const Dialogbox({super.key, required this.email, required this.password});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      width: 350,

      child: Column(
        children: [
          SizedBox(height: 20),
          buildTextField(controller: email, hint: 'email'),
          SizedBox(height: 20),
          buildTextField(controller: password, hint: 'password'),
          SizedBox(height: 50),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(20),
              backgroundColor: Appcolors().buttoncolor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            onPressed: () {},
            child: Text(
              'Enter',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        ],
      ),
    );
  }
}

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
