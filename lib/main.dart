import 'package:flutter/material.dart';
import 'dashboard.dart'; // Import the DashboardPage file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFADD8E6), // Light blue color
          elevation: 0, // No shadow
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F7FE), // Background color for Scaffold
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'aMuse',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // White button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: const BorderSide(color: Colors.black), // Optional border
                        ),
                        onPressed: () {
                          // Navigate to the DashboardPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DashboardPage(),
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black, // Black text for contrast
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {},
                  child: const Text('Forgot password?'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
