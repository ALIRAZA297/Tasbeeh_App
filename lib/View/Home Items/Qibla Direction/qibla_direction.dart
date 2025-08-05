import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:tasbeeh_app/Utils/app_colors.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  bool _isLocationServiceEnabled = false;
  bool _hasLocationPermission = false;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeLocationServices();
  }

  Future<void> _initializeLocationServices() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Check location service first
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      setState(() {
        _isLocationServiceEnabled = serviceEnabled;
      });

      if (!serviceEnabled) {
        setState(() {
          _errorMessage = 'Location services are disabled. Please enable GPS.';
          _isLoading = false;
        });
        return;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _hasLocationPermission = false;
          _errorMessage = permission == LocationPermission.deniedForever
              ? 'Location permission permanently denied. Please enable in app settings.'
              : 'Location permission denied. Please allow location access.';
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _hasLocationPermission = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error initializing location services: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      _initializeLocationServices();
    }
  }

  Future<void> _openLocationSettings() async {
    await Geolocator.openLocationSettings();
    // Wait a bit and re-check
    await Future.delayed(const Duration(seconds: 2));
    _initializeLocationServices();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Qibla Direction',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Get.isDarkMode ? white : black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Get.isDarkMode ? white : black87),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Get.isDarkMode ? white : black87),
            onPressed: _initializeLocationServices,
          ),
        ],
      ),
      body: SafeArea(
        child: _buildBody(screenHeight),
      ),
    );
  }

  Widget _buildBody(double screenHeight) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: primary700),
            const SizedBox(height: 16),
            Text(
              'Initializing compass...',
              style: GoogleFonts.poppins(
                color: Get.isDarkMode ? white : black87,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return _buildErrorWidget(_errorMessage!);
    }

    if (!_isLocationServiceEnabled || !_hasLocationPermission) {
      return _buildPermissionWidget();
    }

    return _buildQiblaCompass(screenHeight);
  }

  Widget _buildQiblaCompass(double screenHeight) {
    return StreamBuilder<QiblahDirection>(
      stream: FlutterQiblah.qiblahStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: primary700),
                const SizedBox(height: 16),
                Text(
                  'Getting compass direction...',
                  style: GoogleFonts.poppins(
                    color: Get.isDarkMode ? white : black87,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Make sure your device has a magnetometer sensor',
                  style: GoogleFonts.poppins(
                    color: Get.isDarkMode ? white70 : black54,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          String errorMsg = snapshot.error.toString();
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

        return SingleChildScrollView(
          child: Column(
            children: [
              // Compass Section
              Container(
                height: screenHeight * 0.5,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: primary700.withOpacity(0.1),
                  boxShadow: [
                    BoxShadow(
                      color: black.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Compass background circle
                    Container(
                      width: screenHeight * 0.4,
                      height: screenHeight * 0.4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: primary700, width: 2),
                      ),
                    ),
                    // Custom painted compass
                    CustomPaint(
                      size: Size(screenHeight * 0.4, screenHeight * 0.4),
                      painter: QiblaCompassPainter(
                        direction: qiblahDirection.direction,
                        qibla: qiblahDirection.qiblah,
                      ),
                    ),
                    // Kaaba icon at top
                    Positioned(
                      top: 20,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primary700,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          FlutterIslamicIcons.solidKaaba,
                          color: white,
                          size: 24,
                        ),
                      ),
                    ),
                    // Direction indicator
                    Positioned(
                      bottom: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: primary700,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${qiblahDirection.qiblah.toStringAsFixed(1)}°',
                          style: GoogleFonts.poppins(
                            color: white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Info Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? white.withOpacity(0.1)
                      : primary700.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: primary700.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          FlutterIslamicIcons.solidCrescentMoon,
                          color: primary700,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Qibla Information',
                          style: GoogleFonts.poppins(
                            color: Get.isDarkMode ? white : black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('Qibla Direction',
                        '${qiblahDirection.qiblah.toStringAsFixed(2)}° from North'),
                    const SizedBox(height: 8),
                    _buildInfoRow('Device Heading',
                        '${qiblahDirection.direction.toStringAsFixed(2)}°'),
                    const SizedBox(height: 8),
                    _buildInfoRow('Offset',
                        '${(qiblahDirection.qiblah - qiblahDirection.direction).toStringAsFixed(2)}°'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Instructions
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? Colors.orange.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.info_outline,
                        color: Colors.orange, size: 24),
                    const SizedBox(height: 8),
                    Text(
                      'Hold your phone flat and rotate until the gold arrow points to the Kaaba icon',
                      style: GoogleFonts.poppins(
                        color: Get.isDarkMode ? white : black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUnsupportedDeviceWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.phonelink_off, color: Colors.orange, size: 64),
            const SizedBox(height: 24),
            Text(
              'Device Not Supported',
              style: GoogleFonts.poppins(
                color: Get.isDarkMode ? white : black87,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Your device does not have the required magnetometer sensor for compass functionality. Please use a device with compass/magnetometer support.',
              style: GoogleFonts.poppins(
                color: Get.isDarkMode ? white70 : black54,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back, color: white),
              label: Text(
                'Go Back',
                style: GoogleFonts.poppins(
                  color: white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary700,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: GoogleFonts.poppins(
            color: Get.isDarkMode ? white70 : black54,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: Get.isDarkMode ? white : black87,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FlutterIslamicIcons.solidMosque, color: primary700, size: 64),
            const SizedBox(height: 24),
            Text(
              'Location Access Required',
              style: GoogleFonts.poppins(
                color: Get.isDarkMode ? white : black87,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              !_isLocationServiceEnabled
                  ? 'Please enable location services to find the Qibla direction.'
                  : 'Please grant location permission to determine your position for accurate Qibla direction.',
              style: GoogleFonts.poppins(
                color: Get.isDarkMode ? white70 : black54,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: !_isLocationServiceEnabled
                  ? _openLocationSettings
                  : _requestLocationPermission,
              icon: Icon(
                !_isLocationServiceEnabled
                    ? Icons.location_on
                    : Icons.location_searching,
                color: white,
              ),
              label: Text(
                !_isLocationServiceEnabled
                    ? 'Enable Location Services'
                    : 'Grant Permission',
                style: GoogleFonts.poppins(
                  color: white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary700,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _initializeLocationServices,
              child: Text(
                'Retry',
                style: GoogleFonts.poppins(
                  color: primary700,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    debugPrint(message);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 64),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: GoogleFonts.poppins(
                color: Get.isDarkMode ? white : black87,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: GoogleFonts.poppins(
                color: Get.isDarkMode ? white70 : black54,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _initializeLocationServices,
              icon: const Icon(Icons.refresh, color: white),
              label: Text(
                'Try Again',
                style: GoogleFonts.poppins(
                  color: white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary700,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Geolocator.openAppSettings(),
              child: Text(
                'Open App Settings',
                style: GoogleFonts.poppins(
                  color: primary700,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QiblaCompassPainter extends CustomPainter {
  final double direction; // Device heading (0-360°)
  final double qibla; // Qibla direction (degrees from North)

  QiblaCompassPainter({required this.direction, required this.qibla});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Hour markers (12 main directions)
    final markerPaint = Paint()
      ..color = Get.isDarkMode ? white.withOpacity(0.7) : black54
      ..strokeWidth = 2;

    for (int i = 0; i < 12; i++) {
      final angle = i * 30 * pi / 180 - pi / 2; // Start from top (North)
      final start = center +
          Offset(cos(angle) * radius * 0.85, sin(angle) * radius * 0.85);
      final end = center +
          Offset(cos(angle) * radius * 0.95, sin(angle) * radius * 0.95);
      canvas.drawLine(start, end, markerPaint);
    }

    // Cardinal direction markers (N, E, S, W)
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    final directions = ['N', 'E', 'S', 'W'];
    for (int i = 0; i < 4; i++) {
      final angle = i * 90 * pi / 180 - pi / 2;
      textPainter.text = TextSpan(
        text: directions[i],
        style: GoogleFonts.poppins(
          color: Get.isDarkMode ? white : black87,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();

      final offset = center +
          Offset(
            cos(angle) * radius * 0.75 - textPainter.width / 2,
            sin(angle) * radius * 0.75 - textPainter.height / 2,
          );
      textPainter.paint(canvas, offset);
    }

    // North indicator (red)
    final northAngle = -direction * pi / 180 - pi / 2;
    final northPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final northStart =
        center + Offset(cos(northAngle) * 15, sin(northAngle) * 15);
    final northEnd = center +
        Offset(cos(northAngle) * radius * 0.6, sin(northAngle) * radius * 0.6);
    canvas.drawLine(northStart, northEnd, northPaint);

    // Draw North arrow head
    final arrowAngle1 = northAngle - pi / 6;
    final arrowAngle2 = northAngle + pi / 6;
    final arrowEnd1 =
        northEnd + Offset(cos(arrowAngle1) * -15, sin(arrowAngle1) * -15);
    final arrowEnd2 =
        northEnd + Offset(cos(arrowAngle2) * -15, sin(arrowAngle2) * -15);

    canvas.drawLine(northEnd, arrowEnd1, northPaint);
    canvas.drawLine(northEnd, arrowEnd2, northPaint);

    // Qibla indicator (gold)
    final qiblaAngle = (qibla - direction) * pi / 180 - pi / 2;
    final qiblaPaint = Paint()
      ..color = Colors.amber
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final qiblaStart =
        center + Offset(cos(qiblaAngle) * 20, sin(qiblaAngle) * 20);
    final qiblaEnd = center +
        Offset(cos(qiblaAngle) * radius * 0.8, sin(qiblaAngle) * radius * 0.8);
    canvas.drawLine(qiblaStart, qiblaEnd, qiblaPaint);

    // Draw Qibla arrow head
    final qiblaArrowAngle1 = qiblaAngle - pi / 6;
    final qiblaArrowAngle2 = qiblaAngle + pi / 6;
    final qiblaArrowEnd1 = qiblaEnd +
        Offset(cos(qiblaArrowAngle1) * -20, sin(qiblaArrowAngle1) * -20);
    final qiblaArrowEnd2 = qiblaEnd +
        Offset(cos(qiblaArrowAngle2) * -20, sin(qiblaArrowAngle2) * -20);

    canvas.drawLine(qiblaEnd, qiblaArrowEnd1, qiblaPaint);
    canvas.drawLine(qiblaEnd, qiblaArrowEnd2, qiblaPaint);

    // Center dot
    final centerDot = Paint()..color = primary700;
    canvas.drawCircle(center, 8, centerDot);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
