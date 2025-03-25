import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh_app/Controller/counter_controller.dart';

class CounterHomePage extends StatelessWidget {
  const CounterHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8.0,left: 10),
          child: Text(
            "بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ",
            style: GoogleFonts.amiriQuran(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      // drawer: const CustomDrawer(),
      body: SafeArea(
        child: GetBuilder<CounterController>(
          builder: (controller) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Text(
                  'Count: ${controller.counterModel.value.count}',
                  style: const TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 120.0),
                ElevatedButton(
                  style: const ButtonStyle(
                    side: MaterialStatePropertyAll(
                      BorderSide(color: Color(0xff01301C)),
                    ),
                  ),
                  onPressed: controller.reset,
                  child: const Text('Reset Count'),
                ),
                const SizedBox(height: 50),
                Column(
                  children: [
                    SizedBox(
                      height: 300,
                      child: Stack(
                        children: [
                          IconButton(
                            style: ButtonStyle(
                              overlayColor: MaterialStatePropertyAll(
                                  Colors.white.withOpacity(0.5)),
                              shape: const MaterialStatePropertyAll(
                                CircleBorder(),
                              ),
                              backgroundColor: const MaterialStatePropertyAll(
                                Color(0xff01301C),
                              ),
                            ),
                            onPressed: controller.increment,
                            icon: const Icon(
                              Icons.keyboard_arrow_up_outlined,
                              size: 180,
                              color: Color(0xff00EA86),
                            ),
                          ),
                          Positioned(
                            bottom: 50,
                            left: 0,
                            right: 0,
                            child: IconButton(
                              style: ButtonStyle(
                                overlayColor: MaterialStatePropertyAll(
                                    Colors.white.withOpacity(0.5)),
                                shape: const MaterialStatePropertyAll(
                                  CircleBorder(
                                    side:
                                        BorderSide(color: Colors.white, width: 3),
                                  ),
                                ),
                                backgroundColor: const MaterialStatePropertyAll(
                                  Color(0xff01301C),
                                ),
                              ),
                              onPressed: controller.decrement,
                              icon: const Icon(
                                Icons.keyboard_arrow_down_outlined,
                                size: 80,
                                color: Color(0xff00EA86),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20.0),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
