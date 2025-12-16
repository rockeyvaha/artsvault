import 'package:flutter/material.dart';
import 'scan_qr_page.dart';

class PaymentPage extends StatefulWidget {
  final double totalAmount;
  final List<dynamic> cartItems; // Accepting the cart items

  // Constructor to accept the cart items and total amount
  const PaymentPage({super.key, required this.totalAmount, required this.cartItems});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int _selectedPaymentMethod = 1;  // 1 = QR Pay // 2 = Card Payment (Simulated)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        centerTitle: true,
        backgroundColor: Colors.grey[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Displaying ordered items
            const Text(
              'Ordered Items:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.cartItems.length,
                itemBuilder: (context, index) {
                  final item = widget.cartItems[index];
                  final itemName = item['name'];
                  final itemSize = item['size'];
                  final itemQuantity = item['quantity'];
                  final itemPrice = double.tryParse(item['price'].toString()) ?? 0.0;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(itemName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Size: $itemSize'),
                          Text('Quantity: $itemQuantity'),
                          Text('Price: RM$itemPrice'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Payment method section
            const SizedBox(height: 20),
            const Text(
              'Payment method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.qr_code, color: Colors.green),
                    title: const Text('Scan QR Pay'),
                    trailing: Radio(
                      value: 1,
                      groupValue: _selectedPaymentMethod,
                      onChanged: (int? value) {
                        setState(() {
                          _selectedPaymentMethod = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.credit_card, color: Colors.blue),
              title: const Text('Card Payment'),
              trailing: Radio(
              value: 2,
              groupValue: _selectedPaymentMethod,
              onChanged: (int? value) {
              setState(() {
                _selectedPaymentMethod = value!;
                });
               },
            ),
          ),
            const Spacer(),
            // Total (RM) section aligned to the right
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(), // Push content to the right
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end, // Align items to the right
                  children: [
                    const Text(
                      'Total (RM):',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      widget.totalAmount.toStringAsFixed(2), // Display the total amount
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
             onPressed: () {
  // Major change: Refactored payment module to support multiple payment methods
  if (_selectedPaymentMethod == 1) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ScanQrPage()),
    );
  } else if (_selectedPaymentMethod == 2) {
    // Card payment simulation
    showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        title: Text('Card Payment'),
        content: Text('Card payment processing simulation.'),
      ),
    );
  } else {
    // Cash payment
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Payment'),
        content: const Text('You have chosen to pay with cash.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Add cash payment handling logic here
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
},

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffF7DC6F), // Custom yellow color
                minimumSize: const Size(327, 50), // Button size unchanged
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40), // Rounded corners
                ),
              ),
              child: const Text(
                'Proceed to payment',
                style: TextStyle(color: Color(0xffFF460A), fontSize: 17), // Orange text
              ),
            ),
          ],
        ),
      ),
    );
  }
}
