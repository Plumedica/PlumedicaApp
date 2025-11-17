import 'package:flutter/material.dart';
import 'package:frontend/widgets/custom_buttons.dart';
import 'login_page.dart';
import 'registration_page.dart';
import 'maipage.dart';

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
      routes:{
        './login_page.dart':(context)=>const LoginPage(),
        './registration_page.dart':(context)=>const RegistrationForm(),
        './maipage.dart':(context)=>MainPage(),
      },
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
                CustomButton(
              text: "Login",
              onPressed: () {
                Navigator.pushNamed(context, './maipage.dart');
              },
              filled: true, // filled button
            ),
const SizedBox(height: 24),
                // Registration Button
                CustomButton(
                  text: "Register",
                  onPressed: () {
                    Navigator.pushNamed(context, './registration_page.dart');
                  },
                  filled: false, // outlined button
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
