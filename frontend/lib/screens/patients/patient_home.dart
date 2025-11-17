import 'package:flutter/material.dart';
import 'package:frontend/widgets/custom_buttons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PatientHome extends StatefulWidget {
  const PatientHome({super.key});

  @override
  State<PatientHome> createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _gender;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // 🔹 Function to submit form and store data in DB
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final url = Uri.parse("http://10.0.2.2:3000/patients/register");

      final body = {
        "name": _nameController.text.trim(),
        "dob": _dobController.text.trim(),
        "gender": _gender ?? "",
        "email": _emailController.text.trim(),
        "mobile": _mobileController.text.trim(),
        "password": _passwordController.text.trim(),
      };

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // ✅ Success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ ${data['message']}")),
        );

        // Print backend response
        print("Registered Patient: ${data['patient']}");

        // Clear form after successful registration
        _formKey.currentState!.reset();
        setState(() {
          _gender = null;
        });
      } else {
        // ❌ Server error or validation failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ ${data['message']}")),
        );
      }
    } catch (e) {
      print("Error submitting form: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Failed to connect to server")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient Registration Form"),
        backgroundColor: const Color.fromARGB(255, 16, 186, 124),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Please enter Name" : null,
              ),
              const SizedBox(height: 12),

              // Date of Birth
              TextFormField(
                controller: _dobController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Date of Birth",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    _dobController.text = "${pickedDate.toLocal()}".split(' ')[0];
                  }
                },
                validator: (value) =>
                    value == null || value.isEmpty ? "Please select Date of Birth" : null,
              ),
              const SizedBox(height: 12),

              // Gender
              DropdownButtonFormField<String>(
                value: _gender,
                items: ['Male', 'Female', 'Other']
                    .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => _gender = val),
                decoration: InputDecoration(
                  labelText: "Gender",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) => value == null ? "Please select Gender" : null,
              ),
              const SizedBox(height: 12),

              // Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email ID",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) =>
                    value == null || !value.contains('@') ? "Enter a valid Email" : null,
              ),
              const SizedBox(height: 12),

              // Mobile
              TextFormField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Mobile Number",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) =>
                    value == null || value.length < 10 ? "Enter a valid Mobile Number" : null,
              ),
              const SizedBox(height: 12),

              // Password
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) =>
                    value == null || value.length < 6 ? "Password must be at least 6 characters" : null,
              ),
              const SizedBox(height: 12),

              // Confirm Password
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) => value != _passwordController.text
                    ? "Passwords do not match"
                    : null,
              ),
              const SizedBox(height: 20),

              // Submit Button
              Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : CustomButton(
                        text: "Submit",
                        filled: true,
                        onPressed: _submitForm,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
