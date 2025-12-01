import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Light grey background
      appBar: AppBar(
        backgroundColor: Colors.white, // White app bar
        elevation: 0, // Remove shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back
          },
        ),
        title: const Text(
          'Privacy policy',
          style: TextStyle(
            fontFamily: 'Poppins', // Replace with your desired font
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // Center-align the title
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Add padding around the content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20), // Space below the title
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white, // White background
                borderRadius: BorderRadius.circular(15), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '1. Data Collection: We collect personal information such as your name, contact details, payment information, and rental history to process orders and improve services.',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.black,
                      height: 1.5, // Line height
                    ),
                  ),
                  SizedBox(height: 10), // Space between points
                  Text(
                    '2. Data Usage: Your information is used for rental transactions, customer support, and marketing (with consent).',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.black,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '3. Data Protection: We implement strict security measures to safeguard your data and do not share it with third parties except for payment processing and legal requirements.',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.black,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '4. Your Rights: You may access, update, or request deletion of your data by contacting us directly.',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.black,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
