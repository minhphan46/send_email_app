import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:send_email_app/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controllerName = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerSubject = TextEditingController();
  final controllerMessage = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Launch Email"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            buildTextField(title: "Name", controller: controllerName),
            const SizedBox(height: 16),
            buildTextField(title: "Email", controller: controllerEmail),
            const SizedBox(height: 16),
            buildTextField(title: "Subject", controller: controllerSubject),
            const SizedBox(height: 16),
            buildTextField(
              title: "Message",
              controller: controllerMessage,
              maxLines: 8,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50),
                textStyle: TextStyle(fontSize: 20),
              ),
              child: Text("SEND"),
              onPressed: () => sendEmail(
                name: controllerName.text,
                email: controllerEmail.text,
                subject: controllerSubject.text,
                message: controllerMessage.text,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future launchEmail({
    required String toEmail,
    required String subject,
    required String message,
  }) async {
    final url =
        'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(message)}';
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  Future sendEmail({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    final serviceId = 'service_q39m2z8';
    final templateId = 'template_0xq4dbm';
    final userId = 'tAaD5e22_Mz7ZuPSK';
    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'user_name': name,
          'user_email': email,
          'to_email': 'pnhuy66@gmail.com',
          'user_subject': subject,
          'user_message': message,
        }
      }),
    );
    print(response.body);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: response.body == "OK" ? Colors.green : Colors.red,
        content: Text(response.body),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget buildTextField({
    required String title,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(border: OutlineInputBorder()),
        ),
      ],
    );
  }
}
