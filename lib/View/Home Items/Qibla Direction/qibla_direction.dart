// import 'package:flutter/material.dart';
// import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
// import 'package:flutter_qiblah/flutter_qiblah.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../../../Controller/qibla_controller.dart';
// import '../../../Utils/app_colors.dart';
// import 'qibla_compass.dart';

// class QiblaScreen extends StatefulWidget {
//   const QiblaScreen({super.key});

//   @override
//   State<QiblaScreen> createState() => _QiblaScreenState();
// }

// class _QiblaScreenState extends State<QiblaScreen>
//     with TickerProviderStateMixin {
//   bool _isLocationServiceEnabled = false;
//   bool _hasLocationPermission = false;
//   bool _isLoading = true;
//   String? _errorMessage;
//   late QiblaController _controller;
//   late AnimationController _pulseController;
//   late AnimationController _compassController;
//   late Animation<double> _pulseAnimation;
//   late Animation<double> _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = Get.put(QiblaController());

//     // Initialize animations
//     _pulseController = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     )..repeat(reverse: true);

//     _compassController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );

//     _pulseAnimation = Tween<double>(
//       begin: 0.8,
//       end: 1.2,
//     ).animate(CurvedAnimation(
//       parent: _pulseController,
//       curve: Curves.easeInOut,
//     ));

//     _scaleAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _compassController,
//       curve: Curves.elasticOut,
//     ));

//     _initializeLocationServices();
//   }

//   @override
//   void dispose() {
//     _pulseController.dispose();
//     _compassController.dispose();
//     super.dispose();
//   }

//   Future<void> _initializeLocationServices() async {
//     await _controller.initializeLocationServices(
//       setState,
//       (value) => _isLocationServiceEnabled = value,
//       (value) => _hasLocationPermission = value,
//       (value) => _errorMessage = value,
//       (value) {
//         _isLoading = value;
//         if (!value && _isLocationServiceEnabled && _hasLocationPermission) {
//           _compassController.forward();
//         }
//       },
//     );
//   }

//   Future<void> _requestLocationPermission() async {
//     await _controller.requestLocationPermission(_initializeLocationServices);
//   }

//   Future<void> _openLocationSettings() async {
//     await _controller.openLocationSettings(_initializeLocationServices);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         centerTitle: true,
//         elevation: 0,
//         scrolledUnderElevation: 0,
//         title: Text(
//           "Qibla Direction",
//           style: GoogleFonts.poppins(
//             fontWeight: FontWeight.bold,
//             color: Get.isDarkMode ?AppColors.white :AppColors.black,
//           ),
//         ),
//       ),
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       body: SafeArea(
//         child: _buildBody(screenHeight, screenWidth),
//       ),
//     );
//   }

//   Widget _buildBody(double screenHeight, double screenWidth) {
//     if (_isLoading) {
//       return _buildLoadingWidget();
//     }

//     if (_errorMessage != null) {
//       return _buildErrorWidget(_errorMessage!);
//     }

//     if (!_isLocationServiceEnabled || !_hasLocationPermission) {
//       return _buildPermissionWidget();
//     }

//     return _buildQiblaCompass(screenHeight, screenWidth);
//   }

//   Widget _buildLoadingWidget() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           AnimatedBuilder(
//             animation: _pulseAnimation,
//             builder: (context, child) {
//               return Transform.scale(
//                 scale: _pulseAnimation.value,
//                 child: Container(
//                   width: 120,
//                   height: 120,
//                   decoration: BoxDecoration(
//                     gradient: RadialGradient(
//                       colors: [
//                         primary700.withOpacity(0.3),
//                         primary700.withOpacity(0.1),
//                         transparent,
//                       ],
//                     ),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Container(
//                     margin: const EdgeInsets.all(25),
//                     decoration: BoxDecoration(
//                       color: primary700,
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: primary700.withOpacity(0.3),
//                           blurRadius: 15,
//                           offset: const Offset(0, 5),
//                         ),
//                       ],
//                     ),
//                     child: const Icon(
//                       FlutterIslamicIcons.solidKaaba,
//                       color:AppColors.white,
//                       size: 35,
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//           const SizedBox(height: 40),
//           Text(
//             'Initializing Compass...',
//             style: GoogleFonts.poppins(
//               color: Get.isDarkMode ?AppColors.white :AppColors.black87,
//               fontSize: 22,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             'Please hold your device steady',
//             style: GoogleFonts.poppins(
//               color: Get.isDarkMode ?AppColors.white60 :AppColors.black54,
//               fontSize: 16,
//             ),
//           ),
//           const SizedBox(height: 30),
//           SizedBox(
//             width: 30,
//             height: 30,
//             child: CircularProgressIndicator(
//               strokeWidth: 3,
//               valueColor: AlwaysStoppedAnimation<Color>(primary700),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildQiblaCompass(double screenHeight, double screenWidth) {
//     return StreamBuilder<QiblahDirection>(
//       stream: FlutterQiblah.qiblahStream,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return _buildLoadingWidget();
//         }

//         if (snapshot.hasError) {
//           String errorMsg = snapshot.error.toString();
//           if (errorMsg.contains('MissingPluginException') ||
//               errorMsg.contains('androidSupportSensor')) {
//             return _buildUnsupportedDeviceWidget();
//           }
//           return _buildErrorWidget(
//               'Error getting compass direction: $errorMsg');
//         }

//         if (!snapshot.hasData) {
//           return _buildErrorWidget(
//               'No compass data available. Your device may not support compass functionality.');
//         }

//         final qiblahDirection = snapshot.data!;

//         return AnimatedBuilder(
//           animation: _scaleAnimation,
//           builder: (context, child) {
//             return Transform.scale(
//               scale: _scaleAnimation.value,
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 10),

//                     // Main Compass Container
//                     Container(
//                       width: double.infinity,
//                       height: screenWidth * 0.95, // Make it square-ish
//                       margin: const EdgeInsets.symmetric(vertical: 20),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(30),
//                         gradient: LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                           colors: Get.isDarkMode
//                               ? [
//                                   const Color(0xFF2C2C2E),
//                                   const Color(0xFF1C1C1E),
//                                   const Color(0xFF2C2C2E),
//                                 ]
//                               : [
//                                   const Color(0xFFF8FAFC),
//                                  AppColors.white,
//                                   const Color(0xFFE2E8F0),
//                                 ],
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Get.isDarkMode
//                                 ?AppColors.black.withOpacity(0.3)
//                                 : primary700.withOpacity(0.15),
//                             blurRadius: 25,
//                             offset: const Offset(0, 10),
//                             spreadRadius: 2,
//                           ),
//                         ],
//                       ),
//                       child: Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           // Compass widget with proper sizing
//                           SizedBox(
//                             width: screenWidth * 0.75,
//                             height: screenWidth * 0.75,
//                             child: CustomPaint(
//                               size:
//                                   Size(screenWidth * 0.75, screenWidth * 0.75),
//                               painter: QiblaCompassPainter(
//                                 direction: qiblahDirection.direction,
//                                 qibla: qiblahDirection.qiblah,
//                               ),
//                             ),
//                           ),

//                           // Qibla angle indicator at top
//                           Positioned(
//                             top: 30,
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 16, vertical: 8),
//                               decoration: BoxDecoration(
//                                 gradient: const LinearGradient(
//                                   colors: [
//                                     Color(0xFFFFD700),
//                                     Color(0xFFFFA500),
//                                   ],
//                                 ),
//                                 borderRadius: BorderRadius.circular(20),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: const Color(0xFFFFD700)
//                                         .withOpacity(0.4),
//                                     blurRadius: 8,
//                                     offset: const Offset(0, 3),
//                                   ),
//                                 ],
//                               ),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   const Icon(
//                                     FlutterIslamicIcons.solidKaaba,
//                                     color:AppColors.white,
//                                     size: 16,
//                                   ),
//                                   const SizedBox(width: 6),
//                                   Text(
//                                     '${qiblahDirection.qiblah.toStringAsFixed(1)}°',
//                                     style: GoogleFonts.poppins(
//                                       color:AppColors.white,
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),

//                           // Status indicator at bottom
//                           Positioned(
//                             bottom: 8.0,
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 12, vertical: 6),
//                               decoration: BoxDecoration(
//                                 color: Get.isDarkMode
//                                     ?AppColors.white.withOpacity(0.1)
//                                     :AppColors.black.withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                               child: Text(
//                                 'Hold device flat',
//                                 style: GoogleFonts.poppins(
//                                   color: Get.isDarkMode ?AppColors.white70 :AppColors.black54,
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     // Information Cards Row
//                     Row(
//                       children: [
//                         Expanded(
//                           child: _buildInfoCard(
//                             'Qibla Direction',
//                             '${qiblahDirection.qiblah.toStringAsFixed(1)}°',
//                             FlutterIslamicIcons.solidMosque,
//                             const Color(0xFF10B981),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: _buildInfoCard(
//                             'Device Heading',
//                             '${qiblahDirection.direction.toStringAsFixed(1)}°',
//                             Icons.explore,
//                             const Color(0xFF3B82F6),
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 20),

//                     // Instructions Card
//                     Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: Get.isDarkMode
//                               ? [
//                                   const Color(0xFF374151),
//                                   const Color(0xFF1F2937),
//                                 ]
//                               : [
//                                   const Color(0xFFFEF3C7),
//                                   const Color(0xFFFDE68A),
//                                 ],
//                         ),
//                         borderRadius: BorderRadius.circular(20),
//                         boxShadow: [
//                           BoxShadow(
//                             color: (Get.isDarkMode
//                                     ?AppColors.black
//                                     : const Color(0xFFFDE68A))
//                                 .withOpacity(0.2),
//                             blurRadius: 10,
//                             offset: const Offset(0, 5),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               color: Get.isDarkMode
//                                   ? const Color(0xFF10B981)
//                                   : const Color(0xFFF59E0B),
//                               shape: BoxShape.circle,
//                             ),
//                             child: const Icon(
//                               Icons.info_outline,
//                               color:AppColors.white,
//                               size: 20,
//                             ),
//                           ),
//                           const SizedBox(height: 12),
//                           Text(
//                             'How to Use Qibla Compass',
//                             style: GoogleFonts.poppins(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Get.isDarkMode
//                                   ?AppColors.white
//                                   : const Color(0xFF92400E),
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             '• Hold your device flat (parallel to ground)\n'
//                             '• The red needle shows North direction\n'
//                             '• The golden arrow points to Qibla\n'
//                             '• Rotate untilAppColors.black needle align with golden arrow pointer',
//                             style: GoogleFonts.poppins(
//                               fontSize: 13,
//                               color: Get.isDarkMode
//                                   ?AppColors.white70
//                                   : const Color(0xFF92400E),
//                               fontWeight: FontWeight.w500,
//                               height: 1.6,
//                             ),
//                             textAlign: TextAlign.left,
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 30),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildInfoCard(
//       String title, String value, IconData icon, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color:
//             Get.isDarkMode ? color.withOpacity(0.15) : color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: color.withOpacity(0.3),
//           width: 1,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: color.withOpacity(0.1),
//             blurRadius: 5,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: color,
//               shape: BoxShape.circle,
//             ),
//             child: Icon(icon, color:AppColors.white, size: 18),
//           ),
//           const SizedBox(height: 10),
//           Text(
//             title,
//             style: GoogleFonts.poppins(
//               fontSize: 11,
//               color: Get.isDarkMode ?AppColors.white70 :AppColors.black54,
//               fontWeight: FontWeight.w500,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 4),
//           Text(
//             value,
//             style: GoogleFonts.poppins(
//               fontSize: 16,
//               color: Get.isDarkMode ?AppColors.white :AppColors.black87,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPermissionWidget() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 gradient: RadialGradient(
//                   colors: [
//                     primary700.withOpacity(0.2),
//                     transparent,
//                   ],
//                 ),
//                 shape: BoxShape.circle,
//               ),
//               child: Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: primary700,
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: primary700.withOpacity(0.4),
//                       blurRadius: 20,
//                       offset: const Offset(0, 10),
//                     ),
//                   ],
//                 ),
//                 child: const Icon(
//                   FlutterIslamicIcons.solidMosque,
//                   color:AppColors.white,
//                   size: 48,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 32),
//             Text(
//               'Location Access Required',
//               style: GoogleFonts.poppins(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Get.isDarkMode ?AppColors.white :AppColors.black87,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               !_isLocationServiceEnabled
//                   ? 'Please enable location services to find the accurate Qibla direction for your current location.'
//                   : 'We need your location to calculate the precise Qibla direction. Your privacy is protected.',
//               style: GoogleFonts.poppins(
//                 fontSize: 16,
//                 color: Get.isDarkMode ?AppColors.white70 :AppColors.black54,
//                 height: 1.5,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 32),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: !_isLocationServiceEnabled
//                     ? _openLocationSettings
//                     : _requestLocationPermission,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: primary700,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   elevation: 8,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       !_isLocationServiceEnabled
//                           ? Icons.location_on
//                           : Icons.location_searching,
//                       color:AppColors.white,
//                     ),
//                     const SizedBox(width: 12),
//                     Text(
//                       !_isLocationServiceEnabled
//                           ? 'Enable Location Services'
//                           : 'Grant Permission',
//                       style: GoogleFonts.poppins(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color:AppColors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextButton(
//               onPressed: _initializeLocationServices,
//               child: Text(
//                 'Retry',
//                 style: GoogleFonts.poppins(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: primary700,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildErrorWidget(String message) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: red.withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.error_outline,
//                 color: red,
//                 size: 64,
//               ),
//             ),
//             const SizedBox(height: 24),
//             Text(
//               'Something went wrong',
//               style: GoogleFonts.poppins(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Get.isDarkMode ?AppColors.white :AppColors.black87,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               message,
//               style: GoogleFonts.poppins(
//                 fontSize: 16,
//                 color: Get.isDarkMode ?AppColors.white70 :AppColors.black54,
//                 height: 1.5,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 32),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _initializeLocationServices,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: primary700,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.refresh, color:AppColors.white),
//                     const SizedBox(width: 12),
//                     Text(
//                       'Try Again',
//                       style: GoogleFonts.poppins(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color:AppColors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildUnsupportedDeviceWidget() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: orange.withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.phonelink_off,
//                 color: orange,
//                 size: 64,
//               ),
//             ),
//             const SizedBox(height: 24),
//             Text(
//               'Device Not Supported',
//               style: GoogleFonts.poppins(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Get.isDarkMode ?AppColors.white :AppColors.black87,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Your device doesn\'t have the required magnetometer sensor for compass functionality. Please use a device with compass support.',
//               style: GoogleFonts.poppins(
//                 fontSize: 16,
//                 color: Get.isDarkMode ?AppColors.white70 :AppColors.black54,
//                 height: 1.5,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 32),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () => Get.back(),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: primary700,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.arrow_back, color:AppColors.white),
//                     const SizedBox(width: 12),
//                     Text(
//                       'Go Back',
//                       style: GoogleFonts.poppins(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color:AppColors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
// import 'package:flutter_qiblah/flutter_qiblah.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../../../Controller/qibla_controller.dart';
// import '../../../Utils/app_colors.dart';
// import 'qibla_compass.dart';

// class QiblaScreen extends StatefulWidget {
//   const QiblaScreen({super.key});

//   @override
//   State<QiblaScreen> createState() => _QiblaScreenState();
// }

// class _QiblaScreenState extends State<QiblaScreen>
//     with TickerProviderStateMixin {
//   late QiblaController _controller;
//   late AnimationController _pulseController;
//   late AnimationController _compassController;
//   late Animation<double> _pulseAnimation;
//   late Animation<double> _scaleAnimation;

//   bool _isLocationServiceEnabled = false;
//   bool _hasLocationPermission = false;
//   bool _isLoading = true;
//   String? _errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _controller = Get.put(QiblaController());

//     // Pulse animation for loading
//     _pulseController = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     )..repeat(reverse: true);

//     // Compass appearance animation
//     _compassController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );

//     _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
//       CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
//     );

//     _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _compassController, curve: Curves.elasticOut),
//     );

//     _initializeLocationServices();
//   }

//   @override
//   void dispose() {
//     _pulseController.dispose();
//     _compassController.dispose();
//     super.dispose();
//   }

//   Future<void> _initializeLocationServices() async {
//     await _controller.initializeLocationServices(
//       setState,
//       (value) => _isLocationServiceEnabled = value,
//       (value) => _hasLocationPermission = value,
//       (value) => _errorMessage = value,
//       (value) {
//         _isLoading = value;
//         if (!value && _isLocationServiceEnabled && _hasLocationPermission) {
//           _compassController.forward();
//         }
//       },
//     );
//   }

//   Future<void> _requestLocationPermission() async {
//     await _controller.requestLocationPermission(_initializeLocationServices);
//   }

//   Future<void> _openLocationSettings() async {
//     await _controller.openLocationSettings(_initializeLocationServices);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _buildAppBar(),
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       body: SafeArea(
//         child: _buildBody(),
//       ),
//     );
//   }

//   AppBar _buildAppBar() {
//     return AppBar(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       centerTitle: true,
//       elevation: 0,
//       scrolledUnderElevation: 0,
//       title: Text(
//         "Qibla Direction",
//         style: GoogleFonts.poppins(
//           fontWeight: FontWeight.bold,
//           color: Get.isDarkMode ?AppColors.white :AppColors.black,
//         ),
//       ),
//     );
//   }

//   Widget _buildBody() {
//     if (_isLoading) return _buildLoadingWidget();
//     if (_errorMessage != null) return _buildErrorWidget(_errorMessage!);
//     if (!_isLocationServiceEnabled || !_hasLocationPermission) {
//       return _buildPermissionWidget();
//     }
//     return _buildQiblaCompass();
//   }

//   // ==========================
//   // WIDGETS
//   // ==========================

//   Widget _buildLoadingWidget() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           AnimatedBuilder(
//             animation: _pulseAnimation,
//             builder: (context, child) => Transform.scale(
//               scale: _pulseAnimation.value,
//               child: _buildLoadingIcon(),
//             ),
//           ),
//           const SizedBox(height: 40),
//           Text(
//             'Initializing Compass...',
//             style: GoogleFonts.poppins(
//               color: Get.isDarkMode ?AppColors.white :AppColors.black87,
//               fontSize: 22,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             'Please hold your device steady',
//             style: GoogleFonts.poppins(
//               color: Get.isDarkMode ?AppColors.white60 :AppColors.black54,
//               fontSize: 16,
//             ),
//           ),
//           const SizedBox(height: 30),
//           SizedBox(
//             width: 30,
//             height: 30,
//             child: CircularProgressIndicator(strokeWidth: 3, color: primary700),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLoadingIcon() {
//     return Container(
//       width: 120,
//       height: 120,
//       decoration: BoxDecoration(
//         gradient: RadialGradient(
//           colors: [
//             primary700.withOpacity(0.3),
//             primary700.withOpacity(0.1),
//             transparent,
//           ],
//         ),
//         shape: BoxShape.circle,
//       ),
//       child: Container(
//         margin: const EdgeInsets.all(25),
//         decoration: BoxDecoration(
//           color: primary700,
//           shape: BoxShape.circle,
//           boxShadow: [
//             BoxShadow(
//               color: primary700.withOpacity(0.3),
//               blurRadius: 15,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: const Icon(
//           FlutterIslamicIcons.solidKaaba,
//           color:AppColors.white,
//           size: 35,
//         ),
//       ),
//     );
//   }

//   Widget _buildQiblaCompass() {
//     final screenWidth = MediaQuery.of(context).size.width;

//     return StreamBuilder<QiblahDirection>(
//       stream: FlutterQiblah.qiblahStream,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return _buildLoadingWidget();
//         }

//         if (snapshot.hasError) {
//           final errorMsg = snapshot.error.toString();
//           if (errorMsg.contains('MissingPluginException') ||
//               errorMsg.contains('androidSupportSensor')) {
//             return _buildUnsupportedDeviceWidget();
//           }
//           return _buildErrorWidget(
//               'Error getting compass direction: $errorMsg');
//         }

//         if (!snapshot.hasData) {
//           return _buildErrorWidget(
//               'No compass data available. Your device may not support compass functionality.');
//         }

//         final qiblahDirection = snapshot.data!;

//         return AnimatedBuilder(
//           animation: _scaleAnimation,
//           builder: (context, child) => Transform.scale(
//             scale: _scaleAnimation.value,
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   _buildCompassWidget(qiblahDirection, screenWidth),
//                   const SizedBox(height: 20),
//                   _buildInfoRow(qiblahDirection),
//                   const SizedBox(height: 20),
//                   _buildInstructionsCard(),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildCompassWidget(
//       QiblahDirection qiblahDirection, double screenWidth) {
//     return Container(
//       width: double.infinity,
//       height: screenWidth * 0.95,
//       margin: const EdgeInsets.symmetric(vertical: 20),
//       decoration: _compassBoxDecoration(),
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           SizedBox(
//             width: screenWidth * 0.75,
//             height: screenWidth * 0.75,
//             child: const QiblahCompassWidget(),
//             // child: CustomPaint(
//             //   painter: QiblaCompassPainter(
//             //     direction: qiblahDirection.direction,
//             //     qibla: qiblahDirection.qiblah,
//             //   ),
//             // ),
//           ),
//           _buildQiblaAngleIndicator(qiblahDirection.qiblah),
//           _buildStatusIndicator(),
//         ],
//       ),
//     );
//   }

//   BoxDecoration _compassBoxDecoration() {
//     return BoxDecoration(
//       borderRadius: BorderRadius.circular(30),
//       gradient: LinearGradient(
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//         colors: Get.isDarkMode
//             ? [const Color(0xFF2C2C2E), const Color(0xFF1C1C1E)]
//             : [const Color(0xFFF8FAFC),AppColors.white, const Color(0xFFE2E8F0)],
//       ),
//       boxShadow: [
//         BoxShadow(
//           color: Get.isDarkMode
//               ?AppColors.black.withOpacity(0.3)
//               : primary700.withOpacity(0.15),
//           blurRadius: 25,
//           offset: const Offset(0, 10),
//           spreadRadius: 2,
//         ),
//       ],
//     );
//   }

//   Widget _buildQiblaAngleIndicator(double qiblaAngle) {
//     return Positioned(
//       top: 30,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
//           ),
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFFFFD700).withOpacity(0.4),
//               blurRadius: 8,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(FlutterIslamicIcons.solidKaaba, color:AppColors.white, size: 16),
//             const SizedBox(width: 6),
//             Text(
//               '${qiblaAngle.toStringAsFixed(1)}°',
//               style: GoogleFonts.poppins(
//                 color:AppColors.white,
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusIndicator() {
//     return Positioned(
//       bottom: 8.0,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//         decoration: BoxDecoration(
//           color:
//               Get.isDarkMode ?AppColors.white.withOpacity(0.1) :AppColors.black.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Text(
//           'Hold device flat',
//           style: GoogleFonts.poppins(
//             color: Get.isDarkMode ?AppColors.white70 :AppColors.black54,
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(QiblahDirection qiblahDirection) {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildInfoCard(
//             'Qibla Direction',
//             '${qiblahDirection.qiblah.toStringAsFixed(1)}°',
//             FlutterIslamicIcons.solidMosque,
//             const Color(0xFF10B981),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: _buildInfoCard(
//             'Device Heading',
//             '${qiblahDirection.direction.toStringAsFixed(1)}°',
//             Icons.explore,
//             const Color(0xFF3B82F6),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildInfoCard(
//       String title, String value, IconData icon, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color:
//             Get.isDarkMode ? color.withOpacity(0.15) : color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: color.withOpacity(0.3), width: 1),
//         boxShadow: [
//           BoxShadow(
//             color: color.withOpacity(0.1),
//             blurRadius: 5,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           CircleAvatar(
//             backgroundColor: color,
//             radius: 18,
//             child: Icon(icon, color:AppColors.white, size: 18),
//           ),
//           const SizedBox(height: 10),
//           Text(title,
//               style: GoogleFonts.poppins(
//                 fontSize: 11,
//                 color: Get.isDarkMode ?AppColors.white70 :AppColors.black54,
//                 fontWeight: FontWeight.w500,
//               )),
//           const SizedBox(height: 4),
//           Text(value,
//               style: GoogleFonts.poppins(
//                 fontSize: 16,
//                 color: Get.isDarkMode ?AppColors.white :AppColors.black87,
//                 fontWeight: FontWeight.bold,
//               )),
//         ],
//       ),
//     );
//   }

//   Widget _buildInstructionsCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: Get.isDarkMode
//               ? [const Color(0xFF374151), const Color(0xFF1F2937)]
//               : [const Color(0xFFFEF3C7), const Color(0xFFFDE68A)],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: (Get.isDarkMode ?AppColors.black : const Color(0xFFFDE68A))
//                 .withOpacity(0.2),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           CircleAvatar(
//             backgroundColor: Get.isDarkMode
//                 ? const Color(0xFF10B981)
//                 : const Color(0xFFF59E0B),
//             child: const Icon(Icons.info_outline, color:AppColors.white, size: 20),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             'How to Use Qibla Compass',
//             style: GoogleFonts.poppins(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Get.isDarkMode ?AppColors.white : const Color(0xFF92400E),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             '• Hold your device flat (parallel to ground)\n'
//             '• The red needle shows North direction\n'
//             '• The golden arrow points to Qibla\n'
//             '• Rotate untilAppColors.black needle aligns with golden arrow',
//             style: GoogleFonts.poppins(
//               fontSize: 13,
//               color: Get.isDarkMode ?AppColors.white70 : const Color(0xFF92400E),
//               fontWeight: FontWeight.w500,
//               height: 1.6,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPermissionWidget() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _buildPermissionIcon(),
//             const SizedBox(height: 32),
//             Text(
//               'Location Access Required',
//               style: GoogleFonts.poppins(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Get.isDarkMode ?AppColors.white :AppColors.black87,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               !_isLocationServiceEnabled
//                   ? 'Please enable location services to find the accurate Qibla direction.'
//                   : 'We need your location to calculate Qibla direction. Your privacy is protected.',
//               style: GoogleFonts.poppins(
//                 fontSize: 16,
//                 color: Get.isDarkMode ?AppColors.white70 :AppColors.black54,
//                 height: 1.5,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 32),
//             _buildPermissionButton(),
//             const SizedBox(height: 16),
//             TextButton(
//               onPressed: _initializeLocationServices,
//               child: Text('Retry',
//                   style: GoogleFonts.poppins(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: primary700,
//                   )),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPermissionIcon() {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         gradient: RadialGradient(
//           colors: [primary700.withOpacity(0.2), transparent],
//         ),
//         shape: BoxShape.circle,
//       ),
//       child: CircleAvatar(
//         backgroundColor: primary700,
//         radius: 40,
//         child:
//             const Icon(FlutterIslamicIcons.solidMosque, color:AppColors.white, size: 48),
//       ),
//     );
//   }

//   Widget _buildPermissionButton() {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: !_isLocationServiceEnabled
//             ? _openLocationSettings
//             : _requestLocationPermission,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: primary700,
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           elevation: 8,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//                 !_isLocationServiceEnabled
//                     ? Icons.location_on
//                     : Icons.location_searching,
//                 color:AppColors.white),
//             const SizedBox(width: 12),
//             Text(
//               !_isLocationServiceEnabled
//                   ? 'Enable Location Services'
//                   : 'Grant Permission',
//               style: GoogleFonts.poppins(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color:AppColors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildErrorWidget(String message) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.error_outline, color: red, size: 64),
//             const SizedBox(height: 24),
//             Text(
//               'Something went wrong',
//               style: GoogleFonts.poppins(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Get.isDarkMode ?AppColors.white :AppColors.black87,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               message,
//               style: GoogleFonts.poppins(
//                 fontSize: 16,
//                 color: Get.isDarkMode ?AppColors.white70 :AppColors.black54,
//                 height: 1.5,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 32),
//             ElevatedButton(
//               onPressed: _initializeLocationServices,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: primary700,
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12)),
//               ),
//               child: Text('Retry',
//                   style: GoogleFonts.poppins(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color:AppColors.white,
//                   )),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildUnsupportedDeviceWidget() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.warning_amber_rounded,
//                 color: Colors.orange, size: 64),
//             const SizedBox(height: 24),
//             Text(
//               'Device Not Supported',
//               style: GoogleFonts.poppins(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Get.isDarkMode ?AppColors.white :AppColors.black87,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Your device does not support the required compass sensors to detect Qibla direction. Please try using another device.',
//               style: GoogleFonts.poppins(
//                 fontSize: 16,
//                 color: Get.isDarkMode ?AppColors.white70 :AppColors.black54,
//                 height: 1.5,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Controller/qibla_controller.dart';
import '../../../Utils/app_colors.dart';
import 'qibla_compass.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen>
    with TickerProviderStateMixin {
  late QiblaController _controller;
  late AnimationController _pulseController;
  late AnimationController _compassController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  bool _isLocationServiceEnabled = false;
  bool _hasLocationPermission = false;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(QiblaController());

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _compassController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _compassController, curve: Curves.elasticOut),
    );

    _initializeLocationServices();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _compassController.dispose();
    super.dispose();
  }

  Future<void> _initializeLocationServices() async {
    await _controller.initializeLocationServices(
      setState,
      (value) => _isLocationServiceEnabled = value,
      (value) => _hasLocationPermission = value,
      (value) => _errorMessage = value,
      (value) {
        _isLoading = value;
        if (!value && _isLocationServiceEnabled && _hasLocationPermission) {
          _compassController.forward();
        }
      },
    );
  }

  Future<void> _requestLocationPermission() async {
    await _controller.requestLocationPermission(_initializeLocationServices);
  }

  Future<void> _openLocationSettings() async {
    await _controller.openLocationSettings(_initializeLocationServices);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Text(
        "Qibla Direction",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode ? AppColors.white : AppColors.black,
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return _buildLoadingWidget();
    if (_errorMessage != null) return _buildErrorWidget(_errorMessage!);
    if (!_isLocationServiceEnabled || !_hasLocationPermission) {
      return _buildPermissionWidget();
    }
    return _buildQiblaCompass();
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) => Transform.scale(
              scale: _pulseAnimation.value,
              child: _buildLoadingIcon(),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            'Initializing Compass...',
            style: GoogleFonts.poppins(
              color: Get.isDarkMode ? AppColors.white : AppColors.black87,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Please hold your device steady',
            style: GoogleFonts.poppins(
              color: Get.isDarkMode ? AppColors.white60 : AppColors.black54,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(strokeWidth: 3, color: primary700),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIcon() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            primary700.withOpacity(0.3),
            primary700.withOpacity(0.1),
            AppColors.transparent,
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: Container(
        margin: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: primary700,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: primary700.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Icon(
          FlutterIslamicIcons.solidKaaba,
          color: AppColors.white,
          size: 35,
        ),
      ),
    );
  }

  Widget _buildQiblaCompass() {
    final screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<QiblahDirection>(
      stream: FlutterQiblah.qiblahStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingWidget();
        }

        if (snapshot.hasError) {
          final errorMsg = snapshot.error.toString();
          if (errorMsg.contains('MissingPluginException') ||
              errorMsg.contains('androidSupportSensor')) {
            return _buildUnsupportedDeviceWidget();
          }
          return _buildErrorWidget(
              'Error getting compass direction: $errorMsg');
        }

        if (!snapshot.hasData) {
          return _buildErrorWidget(
              'No compass data available. Your device may not support compass functionality.');
        }

        final qiblahDirection = snapshot.data!;

        return AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildCompassWidget(qiblahDirection, screenWidth),
                  const SizedBox(height: 20),
                  _buildInfoRow(qiblahDirection),
                  const SizedBox(height: 20),
                  // _buildInstructionsCard(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompassWidget(
      QiblahDirection qiblahDirection, double screenWidth) {
    return Container(
      width: double.infinity,
      height: screenWidth * 0.98,
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: _compassBoxDecoration(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: screenWidth * 0.75,
            height: screenWidth * 0.75,
            child: const QiblahCompassWidget(),
          ),
          _buildQiblaAngleIndicator(qiblahDirection.qiblah),
          _buildStatusIndicator(),
        ],
      ),
    );
  }

  BoxDecoration _compassBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: Get.isDarkMode
            ? [const Color(0xFF2C2C2E), const Color(0xFF1C1C1E)]
            : [primary500, primary200, primary100],
      ),
      boxShadow: [
        BoxShadow(
          color: Get.isDarkMode
              ? AppColors.black.withOpacity(0.3)
              : primary700.withOpacity(0.15),
          blurRadius: 25,
          offset: const Offset(0, 10),
          spreadRadius: 2,
        ),
      ],
    );
  }

  Widget _buildQiblaAngleIndicator(double qiblaAngle) {
    return Positioned(
      top: 5,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD700).withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(FlutterIslamicIcons.solidKaaba,
                color: AppColors.white, size: 16),
            const SizedBox(width: 6),
            Text(
              '${qiblaAngle.toStringAsFixed(1)}°',
              style: GoogleFonts.poppins(
                color: AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Positioned(
      bottom: 8.0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Get.isDarkMode
              ? AppColors.white.withOpacity(0.1)
              : AppColors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          'Hold device flat',
          style: GoogleFonts.poppins(
            color: Get.isDarkMode ? AppColors.white70 : AppColors.black54,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(QiblahDirection qiblahDirection) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            'Qibla Direction',
            '${qiblahDirection.qiblah.toStringAsFixed(1)}°',
            FlutterIslamicIcons.solidMosque,
            const Color(0xFF10B981),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoCard(
            'Device Heading',
            '${qiblahDirection.direction.toStringAsFixed(1)}°',
            Icons.explore,
            const Color(0xFF3B82F6),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            Get.isDarkMode ? color.withOpacity(0.15) : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: color,
            radius: 18,
            child: Icon(icon, color: AppColors.white, size: 18),
          ),
          const SizedBox(height: 10),
          Text(title,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Get.isDarkMode ? AppColors.white70 : AppColors.black54,
                fontWeight: FontWeight.w500,
              )),
          const SizedBox(height: 4),
          Text(value,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Get.isDarkMode ? AppColors.white : AppColors.black87,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }

  Widget _buildPermissionWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPermissionIcon(),
            const SizedBox(height: 32),
            Text(
              'Location Access Required',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Get.isDarkMode ? AppColors.white : AppColors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              !_isLocationServiceEnabled
                  ? 'Please enable location services to find the accurate Qibla direction.'
                  : 'We need your location to calculate Qibla direction. Your privacy is protected.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Get.isDarkMode ? AppColors.white70 : AppColors.black54,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildPermissionButton(),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _initializeLocationServices,
              child: Text(
                'Retry',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: primary700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionIcon() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [primary700.withOpacity(0.2), AppColors.transparent],
        ),
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        backgroundColor: primary700,
        radius: 40,
        child: const Icon(FlutterIslamicIcons.solidMosque,
            color: AppColors.white, size: 48),
      ),
    );
  }

  Widget _buildPermissionButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: !_isLocationServiceEnabled
            ? _openLocationSettings
            : _requestLocationPermission,
        style: ElevatedButton.styleFrom(
          backgroundColor: primary700,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                !_isLocationServiceEnabled
                    ? Icons.location_on
                    : Icons.location_searching,
                color: AppColors.white),
            const SizedBox(width: 12),
            Text(
              !_isLocationServiceEnabled
                  ? 'Enable Location Services'
                  : 'Grant Permission',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.red, size: 64),
            const SizedBox(height: 24),
            Text(
              'Error Occurred',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Get.isDarkMode ? AppColors.white : AppColors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(message,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Get.isDarkMode ? AppColors.white70 : AppColors.black54,
                ),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _initializeLocationServices,
              style: ElevatedButton.styleFrom(
                backgroundColor: primary700,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Retry',
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnsupportedDeviceWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.block,
                color: Get.isDarkMode ? AppColors.white70 : AppColors.black45,
                size: 80),
            const SizedBox(height: 20),
            Text(
              'Device Not Supported',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Get.isDarkMode ? AppColors.white : AppColors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Your device does not support the necessary sensors for Qibla direction.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Get.isDarkMode ? AppColors.white70 : AppColors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
