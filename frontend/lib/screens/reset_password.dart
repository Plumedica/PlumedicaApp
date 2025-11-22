import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPasswordPage extends StatefulWidget {
  final String token;
  final String module;

  ResetPasswordPage({required this.token, required this.module});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _pass = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;
  String? message;

  String getUrl() {
    return "http://10.0.2.2:3000/${widget.module}/reset-password/${widget.token}";
  }

  Future<void> resetPassword() async {
    if (_pass.text != _confirm.text) {
      setState(() => message = "Passwords do not match");
      return;
    }

    setState(() => _loading = true);

    final response = await http.post(
      Uri.parse(getUrl()),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"password": _pass.text.trim()}),
    );

    final data = json.decode(response.body);

    setState(() {
      message = data["message"];
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reset Password")),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            TextField(
              controller: _pass,
              decoration: InputDecoration(labelText: "New Password"),
              obscureText: true,
            ),
            TextField(
              controller: _confirm,
              decoration: InputDecoration(labelText: "Confirm Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : resetPassword,
              child: _loading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Reset Password"),
            ),
            SizedBox(height: 10),
            if (message != null)
              Text(message!,
                  style: TextStyle(
                      color: message!.contains("success")
                          ? Colors.green
                          : Colors.red)),
          ],
        ),
      ),
    );
  }
}
