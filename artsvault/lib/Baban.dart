import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'clothes.dart';
import 'Cart.dart';

class BajuBaban extends StatelessWidget {
  const BajuBaban({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BajuBabanPage(),
    );
  }
}

class BajuBabanPage extends StatefulWidget {
  const BajuBabanPage({super.key});

  @override
  _BajuBabanPageState createState() => _BajuBabanPageState();
}

class _BajuBabanPageState extends State<BajuBabanPage> {
  int cartCount = 0; // Keeps track of the number of items in the cart

  void _addToCart(int quantity) {
    setState(() {
      cartCount += quantity; // Update cart count
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
                ),
              ),
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
                    MaterialPageRoute(
                      builder: (context) =>
                      const CartPage(), // Navigate to CartPage
                    ),
                  );
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
                'assets/melanau.jpg',
                height: 200,
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Baju Baban Melanau',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Center(
              child: Text(
                'Traditionally worn by Melanau women, this attire includes a short black blouse paired with a songket sarong. It is often worn during weddings and special ceremonies.',
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
                    ),
                  );
                },
                child: const Text(
                  'Add to cart',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
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

  const AddToCartPopup({super.key, required this.onAddToCart});

  @override
  _AddToCartPopupState createState() => _AddToCartPopupState();
}

class _AddToCartPopupState extends State<AddToCartPopup> {
  String selectedSize = 'S'; // Default size
  int quantity = 1; // Default quantity
  int stock = 7; // Example stock count
  double pricePerItem = 120.0; // Example price per item

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save data to Firestore
  void _saveToCart() async {
    final cartData = {
      'name': 'Baju Baban Melanau', // Name of the costume
      'size': selectedSize, // Selected size
      'quantity': quantity, // Quantity
      'price': (quantity * pricePerItem).toStringAsFixed(2), // Total price
      'imageUrl': 'assets/melanau.jpg', // Path to the image
      'timestamp': FieldValue.serverTimestamp(), // To track the order time
    };

    try {
      // Save the data to Firestore
      await _firestore.collection('cart').add(cartData);

      // Notify the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item added to cart successfully!')),
      );

      // Close the popup
      Navigator.pop(context);
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
                'assets/melanau.jpg',
                height: 50,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Baju Baban Melanau',
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
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
