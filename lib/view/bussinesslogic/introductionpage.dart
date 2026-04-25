import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Introductionpage extends StatelessWidget {
  const Introductionpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 0, 53, 97),
                  const Color.fromARGB(255, 60, 184, 241),
                ],
                begin: AlignmentGeometry.topCenter,
                end: AlignmentGeometry.bottomCenter,
                tileMode: TileMode.repeated,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  SizedBox(height: 55),
                  Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Text(
                                    'UBS',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Universal Billing Service',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: TextButton(
                            onPressed: () => Get.offAllNamed('/login'),
                            child: Text(
                              'SignIn',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 45,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Align(
                        alignment: AlignmentGeometry.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(25),
                          child: Hero(
                            tag: Introductionpage(),
                            child: Text(
                              'One Platform. Any Business. Infinite Scalability.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 45,
                              ),
                            ),
                          ),
                        ),
                      ),    
                      Align(
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          width: 800,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 35),
                            child: Text(
                              'UBS is the next-generation application for small and medium businesses. We’ve stripped away the complexity of traditional POS systems to give you a cloud-powered, lightning-fast terminal that handles everything from Restaurant,food court billing to Pharmacy batch tracking.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
