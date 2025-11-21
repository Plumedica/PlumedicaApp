import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// DASHBOARDS
import './doctors/doctor_dashboard.dart';
import './hospitals/hospital_dashboard.dart';
import './patients/patient_dashboard.dart';
import './pharmacies/pharmacy_dashboard.dart';

enum ModuleType { Doctor, Hospital, Patients, Pharmacy }

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Main Modules',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  final Map<ModuleType, String> labels = {
    ModuleType.Doctor: 'Doctor',
    ModuleType.Hospital: 'Hospital',
    ModuleType.Patients: 'Patients',
    ModuleType.Pharmacy: 'Pharmacy',
  };

  final Map<ModuleType, IconData> icons = {
    ModuleType.Doctor: Icons.person,
    ModuleType.Hospital: Icons.local_hospital,
    ModuleType.Patients: Icons.people,
    ModuleType.Pharmacy: Icons.local_pharmacy,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Main Modules')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          children: ModuleType.values.map((module) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ModuleLoginPage(module: module),
                  ),
                );
              },
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 22, horizontal: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icons[module], size: 52, color: Colors.teal),
                      SizedBox(height: 15),
                      Text(labels[module]!,
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class ModuleLoginPage extends StatefulWidget {
  final ModuleType module;
  ModuleLoginPage({required this.module});

  @override
  _ModuleLoginPageState createState() => _ModuleLoginPageState();
}

class _ModuleLoginPageState extends State<ModuleLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();

  bool _loading = false;
  String? _errorMsg;

  String get moduleName => widget.module.toString().split('.').last;

  // --------------- FIXED: API URL -------------------
  String getLoginUrl() {
    switch (widget.module) {
      case ModuleType.Doctor:
        return 'http://10.0.2.2:3000/doctors/login';
      case ModuleType.Hospital:
        return 'http://10.0.2.2:3000/hospitals/login';
      case ModuleType.Patients:
        return 'http://10.0.2.2:3000/patients/login';
      case ModuleType.Pharmacy:
        return 'http://10.0.2.2:3000/pharmacies/login';
    }
  }

  // --------------- FIXED: JSON LOGIN REQUEST -------------------
  Future<bool> loginUser() async {
  final url = getLoginUrl();

  final response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: json.encode({
      "username": _username.text.trim(),
      "password": _password.text.trim(),
    }),
  );

  final decoded = json.decode(response.body);

  if (response.statusCode == 200 && decoded["success"] == true) {
    return true;
  } else {
    throw Exception(decoded["message"] ?? "Login failed");
  }
}

  // --------------- FIXED: DASHBOARD SELECTOR -------------------
  Widget getDashboard() {
    switch (widget.module) {
      case ModuleType.Doctor:
        return DoctorDashboard();
      case ModuleType.Hospital:
        return HospitalDashboard();
      case ModuleType.Patients:
        return PatientDashboard();
      case ModuleType.Pharmacy:
        return PharmacyDashboard();
    }
  }

  // --------------- LOGIN SUBMIT -------------------
  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _errorMsg = null;
    });

    try {
      final success = await loginUser();

      if (!mounted) return;

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => getDashboard()),
        );
      }
    } catch (e) {
      setState(() {
        _errorMsg = e.toString().replaceAll("Exception:", "").trim();
      });
    }

    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  // ---------------- UI --------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$moduleName Login")),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
  children: [
    SizedBox(height: 30),
    Text(
      "Login as $moduleName",
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 28),

    // USERNAME
    TextFormField(
      controller: _username,
      decoration: InputDecoration(
        labelText: "Username",
        prefixIcon: Icon(Icons.email),
      ),
      validator: (v) => v!.isEmpty ? "Enter username" : null,
    ),
    SizedBox(height: 18),

    // PASSWORD
    TextFormField(
      controller: _password,
      obscureText: true,
      decoration: InputDecoration(
        labelText: "Password",
        prefixIcon: Icon(Icons.lock),
      ),
      validator: (v) => v!.isEmpty ? "Enter password" : null,
    ),

    SizedBox(height: 10),

    // ⭐ ADDED: FORGOT PASSWORD BUTTON ⭐
    Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // TODO: Navigate to Forgot Password Page
          print("Forgot password clicked for $moduleName");
        },
        child: Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.teal, fontSize: 14),
        ),
      ),
    ),

    if (_errorMsg != null)
      Text(
        _errorMsg!,
        style: TextStyle(color: Colors.red, fontSize: 15),
      ),

    SizedBox(height: 10),

    ElevatedButton(
      onPressed: _loading ? null : _submit,
      child: _loading
          ? CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            )
          : Text("Login"),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
      ),
    ),
  ],
)

              ),
            ),
          ),
        ),
      ),
    );
  }
}
