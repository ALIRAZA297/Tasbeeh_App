import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          "About us",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0, // Flat look consistent with QuranView
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Name and Icon (optional)
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/row.png",
                      height: 80,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Tasbeeh & Quran",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      "Version 1.0.8",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Get.isDarkMode
                            ? Colors.white70
                            : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // About Section
              Text(
                "About the App",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Tasbeeh & Quran is a simple and elegant app designed to help Muslims connect with the Quran and enhance their spiritual practice. It provides easy access to the full text of the Holy Quran with English translations, allowing users to read, resume their last reading, and save their progress effortlessly.",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Get.isDarkMode ? Colors.white70 : Colors.grey.shade800,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),

              // Features Section
              Text(
                "Features",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              _buildFeatureItem(
                "Last Read",
                "Resume your reading from where you left off with a single tap.",
              ),
              _buildFeatureItem(
                "Offline Access",
                "Access the Quran anytime, even without an internet connection after the initial load.",
              ),
              _buildFeatureItem(
                "Zikr Azkar",
                "Engage in daily supplications and adhkar for spiritual peace and mindfulness.",
              ),
              _buildFeatureItem(
                "Tasbeeh Counter",
                "Recite Tasbeehat with Urdu translation and create your own custom Tasbeeh for personal use.",
              ),
              // _buildFeatureItem(
              //   "Qibla Direction",
              //   "Find the accurate Qibla direction based on your location, making it easy to pray anywhere.",
              // ),
              _buildFeatureItem(
                "Masnoon Duas",
                "A collection of authentic supplications for daily life situations, including eating, sleeping, traveling, and more.",
              ),
              _buildFeatureItem(
                "Ibaadaat Guide",
                "Learn about essential worship practices such as Salah (Namaz), Namaz-e-Janaza, and other religious rituals.",
              ),
              _buildFeatureItem(
                "Namaz Timing",
                "Get accurate prayer timings based on your location.",
              ),
              const SizedBox(height: 20),

              // Credits Section
              Text(
                "Credits",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Developed by: SoloCode Tech\n"
                "Special thanks to the open-source community for tools and resources.",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Get.isDarkMode ? Colors.white70 : Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 30),

              // Contact or Support (optional)
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                  ),
                  onPressed: () async {
                    final Uri emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: 'linkplayer78@email.com',
                      queryParameters: {
                        'subject': 'Support_Request_Tasbeeh_&_Quran_App'
                      },
                    );

                    if (await canLaunchUrl(emailLaunchUri)) {
                      await launchUrl(emailLaunchUri);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Could not open email app"),
                        ),
                      );
                    }
                  },
                  child: Text(
                    "Contact Us",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green.shade700,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color:
                        Get.isDarkMode ? Colors.white70 : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
