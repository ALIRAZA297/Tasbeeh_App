import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh_app/Controller/tasbeeh_controller.dart';
import 'package:tasbeeh_app/Utils/app_colors.dart';
import 'package:tasbeeh_app/View/Home%20Items/Tasbeeh/tasbeeh_list_screen.dart';

class TasbeehScreen extends StatefulWidget {
  const TasbeehScreen({super.key});

  @override
  State<TasbeehScreen> createState() => _TasbeehScreenState();
}

class _TasbeehScreenState extends State<TasbeehScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TasbeehController controller = Get.find<TasbeehController>();
  final RxInt currentTabIndex = 0.obs; // Reactive tab index

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      currentTabIndex.value = _tabController.index; // Update reactive index
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Tasbeehat',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Get.isDarkMode ? AppColors.white : AppColors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            TabBar(
              labelStyle: GoogleFonts.poppins(),
              indicatorColor:
                  Get.isDarkMode ? AppColors.white : AppColors.black,
              controller: _tabController,
              labelColor: Get.isDarkMode ? AppColors.white : AppColors.black,
              tabs: const [
                Tab(text: 'Popular Tasbeeh'),
                Tab(text: 'My Tasbeeh'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  TasbeehListScreen(isMyTasbeeh: false),
                  TasbeehListScreen(isMyTasbeeh: true),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(() {
        return currentTabIndex.value == 1
            ? FloatingActionButton(
                backgroundColor: primary900,
                onPressed: () => controller.showTasbeehDialog(context),
                child: const Icon(Icons.add, color: AppColors.white),
              )
            : const SizedBox.shrink();
      }),
    );
  }
}
