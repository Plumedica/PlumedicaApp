import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordPage extends StatefulWidget {
  final String module; // doctor / hospital / patients / pharmacy
  ForgotPasswordPage({required this.module});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _email = TextEditingController();
  bool _loading = false;
  String? message;

  String getUrl() {
    return "http://10.0.2.2:3000/${widget.module}/forgot-password";
  }

  Future<void> submitEmail() async {
  final url = Uri.parse(getUrl());

  final res = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode({"email": _email.text.trim()}),
  );

  if (res.statusCode != 200) {
    print("Response: ${res.body}");
    throw Exception("Server error: ${res.statusCode}");
  }

  final data = jsonDecode(res.body);

  if (data["success"] == true) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Reset link sent to email")),
    );
  } else {
    throw Exception(data["message"]);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            TextField(
              controller: _email,
              decoration: InputDecoration(labelText: "Enter Email"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : submitEmail,
              child: _loading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Submit"),
            ),
            SizedBox(height: 10),
            if (message != null)
              Text(message!, style: TextStyle(color: Colors.green)),
          ],
        ),
      ),
    );
  }
}
