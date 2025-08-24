import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space
          children: [
            Expanded(
              // Allow the content above the button to take available space
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Placeholder for the image
                    Image.asset(
                      'assets/images/onboarding_image.png', // Replace with your image asset path
                      height: 200, // Adjust height as needed
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Immerse in a seamless online shopping experience.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "We promise that you'll have the most fuss-free time with us ever.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 80.0,
              ), // Add padding at the bottom
              child: ElevatedButton(
                onPressed: () {
                  context.go('/login');
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets
                      .zero, // Set padding to zero as the gradient will provide it
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors
                      .transparent, // Make button transparent to show gradient
                  shadowColor: Colors.transparent, // Remove shadow
                ),
                child: Ink(
                  // Use Ink to apply the gradient
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5B74FF), Color(0xFF2DE6AF)],
                    ),
                    borderRadius: BorderRadius.circular(
                      15,
                    ), // Match the button's border radius
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 120,
                      vertical: 13,
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
