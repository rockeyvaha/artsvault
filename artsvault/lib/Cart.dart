import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Payment.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
        title: const Text(
          'Your Cart',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('cart')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Your cart is empty.'));
                }

                final cartItems = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    final itemName = item['name'];
                    final itemSize = item['size'];
                    final itemQuantity = item['quantity'];
                    final itemPrice = double.tryParse(item['price'].toString()) ?? 0.0; // Convert price to double
                    final itemImageUrl = item['imageUrl'];

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        leading: Image.asset(
                          itemImageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(itemName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Size: $itemSize'),
                            Text('Quantity: $itemQuantity'),
                            Text('Price: RM${itemPrice.toStringAsFixed(2)}'), // Display price with 2 decimal places
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red), // Change icon to delete
                          onPressed: () async {
                            // Remove item from cart
                            await FirebaseFirestore.instance
                                .collection('cart')
                                .doc(item.id)
                                .delete();
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('cart').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Container();
              }

              final cartItems = snapshot.data!.docs;

              double total = cartItems.fold(
                0.0,
                    (sum, item) {
                  final itemPrice = double.tryParse(item['price'].toString()) ?? 0.0; // Convert price to double
                  final itemQuantity = item['quantity'];
                  return sum + (itemPrice * itemQuantity);
                },
              );

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Total: RM${total.toStringAsFixed(2)}', // Display total with 2 decimal places
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to Payment Page with total amount
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentPage(totalAmount: total, cartItems: const [],),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow, // Button color
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Proceed to Payment',
                        style: TextStyle(
                          color: Colors.orange, // Text color for button
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
// Fixed: Cart total recalculation when removing items (Issue #17)