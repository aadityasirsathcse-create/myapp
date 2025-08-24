import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80), // Adjust spacing as needed
              Center(
                child: Image.asset(
                  'assets/images/logo.png', // Replace with your logo asset path
                  height: 60, // Adjust height as needed
                  width: 60,
                ),
              ),
              const SizedBox(height: 40), // Adjust spacing as needed
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700], // Active tab color
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 3,
                          color: Colors.blue[700], // Active tab indicator
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600], // Inactive tab color
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 3,
                          color: Colors.transparent, // Inactive tab indicator
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40), // Adjust spacing as needed
              const Text(
                'Login to your account',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20), // Adjust spacing as needed
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email ID',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20), // Adjust spacing as needed
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  suffixIcon: Icon(Icons.visibility_off_outlined),
                ),
              ),
              const SizedBox(height: 40), // Adjust spacing as needed
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement login logic
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
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF5B74FF), Color(0xFF2DE6AF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      width: double.infinity, // Make button take full width
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
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
}
