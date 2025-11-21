import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HospitalHome extends StatefulWidget {
  const HospitalHome({Key? key}) : super(key: key);

  @override
  State<HospitalHome> createState() => _HospitalHomeState();
}

class _HospitalHomeState extends State<HospitalHome> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _registrationIdController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _gstIdController = TextEditingController();
  final TextEditingController _specialisationController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _registrationIdController.dispose();
    _addressController.dispose();
    _gstIdController.dispose();
    _specialisationController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  // ✅ Submit form data to backend
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final hospitalData = {
      "name": _nameController.text.trim(),
      "registrationId": _registrationIdController.text.trim(),
      "address": _addressController.text.trim(),
      "gstId": _gstIdController.text.trim(),
      "specialisation": _specialisationController.text.trim(),
      "email": _emailController.text.trim(),
      "phoneNumber": _phoneNumberController.text.trim(),
    };

    try {
      // 🟢 Replace with your actual backend API endpoint
      final url = Uri.parse("http://10.0.2.2:3000/hospitals/register");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(hospitalData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Hospital Registered Successfully ✅"),
            backgroundColor: Colors.green,
          ),
        );

        // Clear form
        _formKey.currentState!.reset();
        _nameController.clear();
        _registrationIdController.clear();
        _addressController.clear();
        _gstIdController.clear();
        _specialisationController.clear();
        _emailController.clear();
        _phoneNumberController.clear();
      } else {
  final res = jsonDecode(response.body);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(res["message"] ?? "Registration failed"),
      backgroundColor: Colors.red,
    ),
  );
}
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? "Please enter $label" : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hospital Registration Form"),
        backgroundColor: const Color.fromARGB(255, 16, 186, 124),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField("Hospital Name", _nameController),
              const SizedBox(height: 12),
              _buildTextField("Registration ID/Certification", _registrationIdController),
              const SizedBox(height: 12),
              _buildTextField("Address/Branch", _addressController),
              const SizedBox(height: 12),
              _buildTextField("GST ID", _gstIdController),
              const SizedBox(height: 12),
              _buildTextField("Specialisation", _specialisationController),
              const SizedBox(height: 12),
              _buildTextField("Email", _emailController,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 12),
              _buildTextField("Phone Number", _phoneNumberController,
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 16, 186, 124),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  _isSubmitting ? "Submitting..." : "Register",
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
