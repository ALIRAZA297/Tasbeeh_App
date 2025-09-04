import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh_app/Controller/counter_controller.dart';
import 'package:tasbeeh_app/Utils/app_colors.dart';

class CounterPage extends StatefulWidget {
  final Map<String, dynamic> tasbeeh;

  const CounterPage({super.key, required this.tasbeeh});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  final CounterController controller = Get.find<CounterController>();

  @override
  void initState() {
    super.initState();
    controller.loadCounter(widget.tasbeeh['id'].toString());
  }

  @override
  Widget build(BuildContext context) {
    final tasbeehId = widget.tasbeeh['id'].toString();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          widget.tasbeeh['title'],
          style: GoogleFonts.notoNastaliqUrdu(
            color: Get.isDarkMode ? AppColors.white : AppColors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: GetBuilder<CounterController>(
            builder: (controller) {
              final count = controller.counts[tasbeehId] ?? 0;

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // --- tasbeeh info box (unchanged) ---
                    Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Get.isDarkMode
                              ? AppColors.white
                              : const Color(0xff01301C),
                          width: 2,
                        ),
                        image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/bg image.jpg"),
                        ),
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            widget.tasbeeh['zikr'],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.amiriQuran(
                              fontSize: 30,
                              color: AppColors.black,
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
                              color: AppColors.grey,
                              height: 2,
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (widget.tasbeeh['count'] != null)
                            Text(
                              'Target: ${widget.tasbeeh['count']}',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: AppColors.grey,
                                height: 2,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- COUNTER DISPLAY ---
                    Text(
                      'Count: $count',
                      style: GoogleFonts.poppins(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color:
                            Get.isDarkMode ? AppColors.white : AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 20.0),

                    // --- RESET BUTTON ---
                    ElevatedButton(
                      style: ButtonStyle(
                        side: WidgetStatePropertyAll(
                          BorderSide(
                              color: Get.isDarkMode
                                  ? AppColors.white
                                  : const Color(0xff01301C)),
                        ),
                      ),
                      onPressed: () => controller.reset(tasbeehId),
                      child: Text(
                        'Reset Count',
                        style: GoogleFonts.poppins(color: primary),
                      ),
                    ),
                    const SizedBox(height: 50),

                    // --- INCREMENT / DECREMENT BUTTONS ---
                    SizedBox(
                      height: 300,
                      child: Stack(
                        children: [
                          IconButton(
                            style: ButtonStyle(
                              overlayColor: WidgetStatePropertyAll(
                                  AppColors.white.withOpacity(0.5)),
                              shape: const WidgetStatePropertyAll(
                                CircleBorder(
                                  side: BorderSide(
                                      color: AppColors.white, width: 3),
                                ),
                              ),
                              backgroundColor:
                                  WidgetStatePropertyAll(primary700),
                            ),
                            onPressed: () => controller.increment(tasbeehId),
                            icon: Icon(
                              Icons.keyboard_arrow_up_outlined,
                              size: 180,
                              color: primary100,
                            ),
                          ),
                          Positioned(
                            bottom: 50,
                            left: 0,
                            right: 0,
                            child: IconButton(
                              style: ButtonStyle(
                                overlayColor: WidgetStatePropertyAll(
                                    AppColors.white.withOpacity(0.5)),
                                shape: const WidgetStatePropertyAll(
                                  CircleBorder(
                                    side: BorderSide(
                                        color: AppColors.white, width: 3),
                                  ),
                                ),
                                backgroundColor:
                                    WidgetStatePropertyAll(primary700),
                              ),
                              onPressed: () => controller.decrement(tasbeehId),
                              icon: Icon(
                                Icons.keyboard_arrow_down_outlined,
                                size: 80,
                                color: primary100,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
