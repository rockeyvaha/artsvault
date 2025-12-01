import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'OrderPage.dart';
import 'Admin-PurchaseHistory.dart';

class ScanQrPage extends StatefulWidget {
  const ScanQrPage({super.key});

  @override
  State<ScanQrPage> createState() => _ScanQrPageState();
}

class _ScanQrPageState extends State<ScanQrPage> {
  final TextEditingController _referenceController = TextEditingController();
  bool _isProceedEnabled = false;

  void _onReferenceChanged(String value) {
    setState(() {
      _isProceedEnabled = value.isNotEmpty;
    });
  }

  Future<void> _saveReferenceToFirestore(String referenceNumber) async {
    try {
      await FirebaseFirestore.instance.collection('payments').add({
        'referenceNumber': referenceNumber,
        'timestamp': FieldValue.serverTimestamp(),
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OrderConfirmedPage(),
        ),
      );
    } catch (error) {
      _showErrorDialog(error.toString());
    }
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text('Failed to save payment reference: $errorMessage'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _referenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        centerTitle: true,
        backgroundColor: Colors.grey[800],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Scan the QR code to make your payment',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/Qr.jpg', // Path to your QR image
              fit: BoxFit.cover,
              width: 250,
              height: 250,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _referenceController,
                decoration: InputDecoration(
                  labelText: 'Payment Reference Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: _onReferenceChanged,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffFF8C00), // Orange background
                minimumSize: const Size(150, 50),
              ),
              child: const Text(
                'Back to Payment',
                style: TextStyle(color: Color(0xffFFD700)), // Yellow text
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isProceedEnabled
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminPurchaseHistoryPage(),
                  ),
                );
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffea9431), // Orange background
                minimumSize: const Size(150, 50),
                disabledBackgroundColor: Colors.grey, // Disabled button color
              ),
              child: const Text(
                'Proceed',
                style: TextStyle(color: Color(0xffFFD700)), // Yellow text
              ),
            ),
          ],
        ),
      ),
    );
  }
}
