import 'package:flutter/material.dart';

class ExistingClientPage extends StatefulWidget {
  @override
  _ExistingClientPageState createState() => _ExistingClientPageState();
}

class _ExistingClientPageState extends State<ExistingClientPage> {
  final _formKey = GlobalKey<FormState>();

  String jobType = 'Contact'; // Default job type

  // Controllers for text fields
  final TextEditingController idController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController qualificationController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();

  @override
  void dispose() {
    idController.dispose();
    titleController.dispose();
    salaryController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    qualificationController.dispose();
    skillsController.dispose();
    experienceController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Handle form submission logic here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Job submitted successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Job (Existing Client)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: idController,
                decoration: InputDecoration(labelText: 'ID No'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter ID No' : null,
              ),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Job Title'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter job title' : null,
              ),
              TextFormField(
                controller: salaryController,
                decoration: InputDecoration(labelText: 'Salary'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Please enter salary' : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      title: Text('Contact'),
                      value: jobType == 'Contact',
                      onChanged: (val) {
                        setState(() {
                          jobType = 'Contact';
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: CheckboxListTile(
                      title: Text('Full Time'),
                      value: jobType == 'Full Time',
                      onChanged: (val) {
                        setState(() {
                          jobType = 'Full Time';
                        });
                      },
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter location' : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Job Description'),
                maxLines: 3,
                validator: (value) => value == null || value.isEmpty ? 'Please enter job description' : null,
              ),
              TextFormField(
                controller: qualificationController,
                decoration: InputDecoration(labelText: 'Qualification'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter qualification' : null,
              ),
              TextFormField(
                controller: skillsController,
                decoration: InputDecoration(labelText: 'Skills Needed'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter skills needed' : null,
              ),
              TextFormField(
                controller: experienceController,
                decoration: InputDecoration(labelText: 'Year of Experience'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Please enter year of experience' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}