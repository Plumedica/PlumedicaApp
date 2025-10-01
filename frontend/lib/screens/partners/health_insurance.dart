import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/widgets/custom_buttons.dart';

class HealthInsurancePage extends StatefulWidget {
  const HealthInsurancePage({super.key});

  @override
  State<HealthInsurancePage> createState() => _HealthInsurancePageState();
}

class _HealthInsurancePageState extends State<HealthInsurancePage> {
  final _formKey = GlobalKey<FormState>();

  // ✅ Controllers for form fields
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _regNumberController = TextEditingController();
  final TextEditingController _gstNumberController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // ✅ Image picker
  File? _certificateImage;
  final ImagePicker _picker = ImagePicker();

  // Show dialog: choose Camera or Gallery
  Future<void> _pickCertificate() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text("Take Photo"),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _certificateImage = File(pickedFile.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Choose from Gallery"),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _certificateImage = File(pickedFile.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String message = """
Company Name: ${_companyNameController.text}
Reg Number: ${_regNumberController.text}
GST Number: ${_gstNumberController.text}
Phone: ${_phoneController.text}
Email: ${_emailController.text}
Address: ${_addressController.text}
Certificate: ${_certificateImage != null ? "Uploaded ✅" : "Not Uploaded"}
""";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Form Submitted ✅\n$message")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Health Insurance"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company Name
              TextFormField(
                controller: _companyNameController,
                decoration: const InputDecoration(
                  labelText: "Company Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Enter company name" : null,
              ),
              const SizedBox(height: 16),

              // Registration Number
              TextFormField(
                controller: _regNumberController,
                decoration: const InputDecoration(
                  labelText: "Registration Number",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Enter registration number" : null,
              ),
              const SizedBox(height: 16),

              // GST Number
              TextFormField(
                controller: _gstNumberController,
                decoration: const InputDecoration(
                  labelText: "GST Number",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Certificate Upload
              const Text("Incorporation Certificate"),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickCertificate,
                    child: const Text("Upload Image"),
                  ),
                  const SizedBox(width: 12),
                  _certificateImage != null
                      ? const Text("File Selected ✅")
                      : const Text("No file chosen"),
                ],
              ),
              const SizedBox(height: 16),

              // Contact Info
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value!.isEmpty ? "Enter phone number" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email ID",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value!.isEmpty ? "Enter email address" : null,
              ),
              const SizedBox(height: 16),

              // Address
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: "Address",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // ✅ Submit Button
              Center(
                child: CustomButton(
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
