import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'clothes.dart';
import 'Cart.dart';

class BajuMelayu extends StatelessWidget {
  const BajuMelayu({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BajuMelayuPage(),
    );
  }
}

class BajuMelayuPage extends StatefulWidget {
  const BajuMelayuPage({super.key});

  @override
  _BajuMelayuPageState createState() => _BajuMelayuPageState();
}

class _BajuMelayuPageState extends State<BajuMelayuPage> {
  int cartCount = 0;

  void _addToCart(int quantity) {
    setState(() {
      cartCount += quantity;
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
                  )),
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
                        builder: (context) => const CartPage()),
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
                'assets/melayu2.jpg',
                height: 200,
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Baju Melayu',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Center(
              child: Text(
                'This traditional Malay attire for men consists of a long-sleeved shirt and trousers, often paired with a samping (a piece of cloth wrapped around the waist) and a songkok (cap). It is commonly worn during formal occasions and religious events.',
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
                      onAddToCart: _addToCart,
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
  final void Function(int quantity) onAddToCart;

  const AddToCartPopup({super.key, required this.onAddToCart});

  @override
  _AddToCartPopupState createState() => _AddToCartPopupState();
}

class _AddToCartPopupState extends State<AddToCartPopup> {
  String selectedSize = 'S';
  int quantity = 1;
  int stock = 7;
  double pricePerItem = 100.0;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _saveToCart() async {
    final cartData = {
      'name': 'Baju Melayu',
      'size': selectedSize,
      'quantity': quantity,
      'price': (quantity * pricePerItem).toStringAsFixed(2),
      'imageUrl': 'assets/melayu2.jpg',
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      await _firestore.collection('cart').add(cartData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item added to cart successfully!')),
      );

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
                'assets/melayu2.jpg',
                height: 50,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Baju Melayu',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text('Stock: $stock'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Size',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Row(
            children: ['S', 'M', 'L'].map((size) {
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              onPressed: _saveToCart,
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
