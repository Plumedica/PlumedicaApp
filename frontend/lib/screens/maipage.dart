import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ✅ Import your dashboards
import './doctors//doctor_dashboard.dart';
import './hospitals//hospital_dashboard.dart';
import './patients//patient_dashboard.dart';
import './pharmacies//pharmacy_dashboard.dart';

enum ModuleType { Doctor, Hospital, Patients, Pharmacy }

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Main Modules',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
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
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          children: ModuleType.values.map((module) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ModuleLoginPage(module: module),
                  ),
                );
              },
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icons[module], size: 52, color: Colors.teal),
                      SizedBox(height: 15),
                      Text(labels[module]!, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500)),
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

  String get _moduleLabel => widget.module.toString().split('.').last;

  Future<bool> loginUser({
    required String username,
    required String password,
    required ModuleType module,
  }) async {
    final apiUrl = {
      ModuleType.Doctor: 'http://10.0.2.2:3000/doctors/login',
      ModuleType.Hospital: 'http://10.0.2.2:3000/hospitals/login',
      ModuleType.Patients: 'http://10.0.2.2:3000/patients/login',
      ModuleType.Pharmacy: 'http://10.0.2.2:3000/pharmacies/login',
    }[module]!;

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'username': username,
        'password': password,
      },
    );

    // ✅ Adjust this part based on your backend login response
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded['success'] == true) {
        return true;
      } else {
        throw Exception(decoded['message'] ?? 'Invalid credentials');
      }
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _errorMsg = null;
    });

    try {
      final success = await loginUser(
        username: _username.text.trim(),
        password: _password.text,
        module: widget.module,
      );

      if (!mounted) return;

      if (success) {
        // ✅ Navigate to correct dashboard
        Widget nextPage;
        switch (widget.module) {
          case ModuleType.Doctor:
            nextPage = DoctorDashboard();
            break;
          case ModuleType.Hospital:
            nextPage = HospitalDashboard();
            break;
          case ModuleType.Patients:
            nextPage = PatientDashboard();
            break;
          case ModuleType.Pharmacy:
            nextPage = PharmacyDashboard();
            break;
        }

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => nextPage),
        );
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _errorMsg = e.toString();
      });
    }
  }

  void _forgotPassword() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Forgot Password'),
        content: Text('Reset password flow for $_moduleLabel. Enter your email to reset.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Close')),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$_moduleLabel Login')),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(18.0),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 420),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      Text('Login as $_moduleLabel', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      SizedBox(height: 22),
                      TextFormField(
                        controller: _username,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.person),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Enter username';
                          return null;
                        },
                      ),
                      SizedBox(height: 18),
                      TextFormField(
                        controller: _password,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Enter password';
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      if (_errorMsg != null)
                        Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(_errorMsg!, style: TextStyle(color: Colors.red, fontSize: 15)),
                        ),
                      ElevatedButton(
                        onPressed: _loading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: _loading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : Text('Login'),
                      ),
                      TextButton(onPressed: _forgotPassword, child: Text('Forgot Password?')),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
