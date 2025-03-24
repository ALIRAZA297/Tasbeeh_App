import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          "About",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
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
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Version 1.0.0", // Replace with your app version
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey.shade700,
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
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Tasbeeh & Quran is a simple and elegant app designed to help Muslims connect with the Quran and enhance their spiritual practice. It provides easy access to the full text of the Holy Quran with English translations, allowing users to read, resume their last reading, and save their progress effortlessly.",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey.shade800,
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
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              _buildFeatureItem(
                "Quran Reading",
                "Read the complete Quran with Surah names in Arabic and English translations.",
              ),
              _buildFeatureItem(
                "Last Read",
                "Resume your reading from where you left off with a single tap.",
              ),
              _buildFeatureItem(
                "Offline Access",
                "Access the Quran anytime, even without an internet connection after the initial load.",
              ),
              const SizedBox(height: 20),

              // Credits Section
              Text(
                "Credits",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Developed by: SoloCode Tech\n"
                "Special thanks to the open-source community for tools and resources.",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey.shade800,
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
                  onPressed: () {
                    // Add contact/support action (e.g., open email)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text("Contact support: linkplayer78@email.com")),
                    );
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
                    color: Colors.black,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade700,
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
