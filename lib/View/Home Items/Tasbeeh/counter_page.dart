import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh_app/Controller/counter_controller.dart';

class CounterPage extends StatefulWidget {
  final Map<String, dynamic> tasbeeh;

  const CounterPage({super.key, required this.tasbeeh});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  @override
  void initState() {
    super.initState();
    Get.find<CounterController>().reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.tasbeeh['title'],
          style: GoogleFonts.notoNastaliqUrdu(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      // drawer: const CustomDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: GetBuilder<CounterController>(
            builder: (controller) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xff01301C),
                        width: 2,
                      ),
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          "assets/images/bg image.jpg",
                        ),
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          widget.tasbeeh['zikr'],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.amiriQuran(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            height: 2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.tasbeeh['translation'],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoNastaliqUrdu(
                            fontSize: 18,
                            color: Colors.grey,
                            height: 2,
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (widget.tasbeeh['count'] != null ||
                            widget.tasbeeh['count'] != 0)
                          Text(
                            'Count ${widget.tasbeeh['count'].toString()}',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.grey,
                              height: 2,
                            ),
                          ),
                        if (widget.tasbeeh['count'] != null ||
                            widget.tasbeeh['count'] != 0)
                          const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Count: ${controller.counterModel.value.count}',
                    style: GoogleFonts.poppins(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20.0),
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
                                      side: BorderSide(
                                          color: Colors.white, width: 3),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
