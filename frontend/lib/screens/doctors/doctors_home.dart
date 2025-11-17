import 'package:flutter/material.dart';
import 'package:frontend/widgets/custom_buttons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DoctorsHome extends StatefulWidget {
  const DoctorsHome({super.key});

  @override
  State<DoctorsHome> createState() => _DoctorsHomeState();
}

class _DoctorsHomeState extends State<DoctorsHome> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  // Controllers
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _regNumberController = TextEditingController();
  final TextEditingController _specialisationController = TextEditingController();
  final TextEditingController _yearOfRegController = TextEditingController();
  final TextEditingController _pgController = TextEditingController();
  final TextEditingController _mbbsController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _shareLocation = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _regNumberController.dispose();
    _specialisationController.dispose();
    _yearOfRegController.dispose();
    _pgController.dispose();
    _mbbsController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // ✅ Submit form data to backend
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final doctorData = {
      "fullName": _fullNameController.text.trim(),
      "regNumber": _regNumberController.text.trim(), 
      "specialisation": _specialisationController.text.trim(),
       "yearOfReg": _yearOfRegController.text.trim(),
      "pg": _pgController.text.trim(),
      "mbbs": _mbbsController.text.trim(),
      "contact": _contactController.text.trim(),
      "email": _emailController.text.trim(),
      "address": _addressController.text.trim(),
      "shareLocation": _shareLocation,
    };

    try {
      // 🟢 Replace with your actual backend API URL
      final url = Uri.parse("http://10.0.2.2:3000/doctors/register");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(doctorData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Doctor Registered Successfully ✅"),
            backgroundColor: Colors.green,
          ),
        );

        // Clear form
        _formKey.currentState!.reset();
        _fullNameController.clear();
        _regNumberController.clear();
        _specialisationController.clear();
        _yearOfRegController.clear();
        _pgController.clear();
        _mbbsController.clear();
        _contactController.clear();
        _emailController.clear();
        _addressController.clear();
        setState(() => _shareLocation = false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to register. (${response.statusCode})"),
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
        title: const Text("Doctor Registration Form"),
        backgroundColor: const Color.fromARGB(255, 16, 186, 124),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField("Full Name", _fullNameController),
              const SizedBox(height: 12),
              _buildTextField("Registration Number", _regNumberController),
              const SizedBox(height: 12),
              _buildTextField("Specialisation", _specialisationController),
              const SizedBox(height: 12),
              _buildTextField("Year of Registration", _yearOfRegController,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              _buildTextField("PG", _pgController),
              const SizedBox(height: 12),
              _buildTextField("MBBS", _mbbsController),
              const SizedBox(height: 12),
              _buildTextField("Contact Number", _contactController,
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 12),
              _buildTextField("Email ID", _emailController,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 12),
              _buildTextField("Address", _addressController),
              const SizedBox(height: 12),

              // Checkbox
              Row(
                children: [
                  Checkbox(
                    value: _shareLocation,
                    onChanged: (val) =>
                        setState(() => _shareLocation = val ?? false),
                  ),
                  const Expanded(
                    child: Text(
                      "Are you ready to share your live location in case of emergency or home visits?",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Submit Button
              Center(
                child: CustomButton(
                  text: _isSubmitting ? "Submitting..." : "Submit",
                  filled: true,
                  onPressed:  _submitForm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
