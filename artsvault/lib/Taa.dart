import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'clothes.dart';
import 'Cart.dart';

class Taa extends StatelessWidget {
  const Taa({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TaaPage(),
    );
  }
}

class TaaPage extends StatefulWidget {
  const TaaPage({super.key});

  @override
  _TaaPageState createState() => _TaaPageState();
}

class _TaaPageState extends State<TaaPage> {
  int cartCount = 0; // Keeps track of the number of items in the cart
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _addToCart(int quantity) {
    setState(() {
      cartCount += quantity; // Update cart count
    });
    _saveToCart(quantity); // Save the data to Firestore
  }

  // Save item to Firestore
  void _saveToCart(int quantity) async {
    final cartData = {
      'name': 'Taa', // Item name
      'size': 'S', // Selected size, modify as needed
      'quantity': quantity, // Quantity
      'price': (quantity * 100).toStringAsFixed(2), // Example price per item
      'imageUrl': 'assets/orangUlu.jpg', // Image path
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      await _firestore.collection('cart').add(cartData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item added to cart successfully!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add item to cart: $error')),
      );
    }
  }

  // Update cart count after adding item
  void _updateCartCount(int quantity) {
    setState(() {
      cartCount += quantity; // Update cart count when adding to cart
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const ClothesPage(
                    searchQuery: '',
                  )), // Navigate to HomePage
            );
          },
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartPage()),
                  ); // Navigate to CartPage
                },
              ),
              if (cartCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      '$cartCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/orangUlu.jpg', // Replace with the actual image
                height: 200,
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Taa',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Center(
              child: Text(
                'This traditional dress for Orang Ulu women includes a black velvet top adorned with intricate beadwork and a matching skirt. It is often accessorized with silver jewelry and headgear.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const Text(
              'Delivery info',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Delivered / pick up between Monday - Friday from 8am to 5pm',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            const Text(
              'Return policy',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Rented clothing must be returned within [3-5 days] in the same condition as received—clean, undamaged, and without alterations—or additional charges will be incurred for any damages or cleaning required.',
              style: TextStyle(fontSize: 14),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (context) => AddToCartPopup(
                      onAddToCart: _addToCart, // Pass callback to update cart
                      updateCartCount: _updateCartCount, // Pass update function
                    ),
                  );
                },
                child: const Text(
                  'Add to cart',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.orange,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddToCartPopup extends StatefulWidget {
  final Function(int quantity) onAddToCart;
  final Function(int quantity) updateCartCount;

  const AddToCartPopup({super.key, required this.onAddToCart, required this.updateCartCount});

  @override
  _AddToCartPopupState createState() => _AddToCartPopupState();
}

class _AddToCartPopupState extends State<AddToCartPopup> {
  String selectedSize = 'S'; // Default size
  int quantity = 1; // Default quantity
  int stock = 7; // Example stock count

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save data to Firestore
  void _saveToCart() async {
    final cartData = {
      'name': 'Taa', // Item name
      'size': selectedSize, // Selected size
      'quantity': quantity, // Quantity
      'price': (quantity * 100).toStringAsFixed(2), // Total price
      'imageUrl': 'assets/orangUlu.jpg', // Path to the image
      'timestamp': FieldValue.serverTimestamp(), // To track the order time
    };

    try {
      await _firestore.collection('cart').add(cartData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item added to cart successfully!')),
      );

      widget.updateCartCount(quantity); // Update the main page cart count
      Navigator.pop(context); // Close the popup
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add item to cart: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/orangUlu.jpg', // Replace with the actual image
                height: 50,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Taa',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Stock: $stock'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Size',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: ['S', 'M'].map((size) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(size),
                  selected: selectedSize == size,
                  onSelected: (selected) {
                    setState(() {
                      selectedSize = size;
                    });
                  },
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text(
            'Quantity',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  if (quantity > 1) {
                    setState(() {
                      quantity--;
                    });
                  }
                },
              ),
              Text(
                '$quantity',
                style: const TextStyle(fontSize: 16),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  if (quantity < stock) {
                    setState(() {
                      quantity++;
                    });
                  }
                },
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _saveToCart, // Save data to Firestore
              child: const Text(
                'Add to cart',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.orange,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
