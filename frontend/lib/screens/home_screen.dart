import 'package:flutter/material.dart';

void main() {
  runApp(HomeScreen());
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YourAppName',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Image
                Image.asset(
                  'assets/images/logo.png',
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 24),

                // App Name
                const Text(
                  'Plumedica',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 48),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to Login screen
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text('Login', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Registration Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      // Navigate to Registration screen
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text('Register', style: TextStyle(fontSize: 18)),
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
