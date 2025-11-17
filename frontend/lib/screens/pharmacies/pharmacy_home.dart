import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PharmacyHome extends StatefulWidget {
  const PharmacyHome({Key? key}) : super(key: key);

  @override
  State<PharmacyHome> createState() => _PharmacyHomeState();
}

class _PharmacyHomeState extends State<PharmacyHome> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _registrationIdController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Future<void> _registerPharmacy() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final pharmacyData = {
      "name": _nameController.text.trim(),
      "registrationId": _registrationIdController.text.trim(),
      "address": _addressController.text.trim(),
      "phoneNumber": _phoneController.text.trim(),
      "emailId": _emailController.text.trim(),
    };

    try {
      final url = Uri.parse("http://10.0.2.2:3000/pharmacies/register");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(pharmacyData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Pharmacy Registered Successfully ✅"),
            backgroundColor: Colors.green,
          ),
        );

        _nameController.clear();
        _registrationIdController.clear();
        _addressController.clear();
        _phoneController.clear();
        _emailController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed (${response.statusCode}): ${response.body}"),
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

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
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
        title: const Text("Pharmacy Registration"),
        backgroundColor: const Color.fromARGB(255, 16, 186, 124),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("Pharmacy Name", _nameController),
              const SizedBox(height: 12),
              _buildTextField("Registration ID", _registrationIdController),
              const SizedBox(height: 12),
              _buildTextField("Address", _addressController),
              const SizedBox(height: 12),
              _buildTextField("Phone Number", _phoneController,
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 12),
              _buildTextField("Email ID", _emailController,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _registerPharmacy,
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
