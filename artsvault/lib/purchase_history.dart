import 'package:flutter/material.dart';

class PurchaseHistoryPage extends StatefulWidget {
  const PurchaseHistoryPage({super.key});

  @override
  _PurchaseHistoryPageState createState() => _PurchaseHistoryPageState();
}

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> purchaseHistory = [
    {
      'customerName': 'Dg Najah',
      'productName': 'Ngepan Indu Iban',
      'size': 'M',
      'quantity': 1,
      'totalPayment': 'RM15.00',
      'date': '1/12/24',
      'orderId': 'N1000',
      'status': 'In Progress',
      'image': 'assets/iban.jpg',
    },
    {
      'customerName': 'Davena Ivea',
      'productName': 'Ngepan Iban Lelaki',
      'size': 'S',
      'quantity': 1,
      'totalPayment': 'RM15.00',
      'date': '2/12/24',
      'orderId': 'N1001',
      'status': 'Completed',
      'image': 'assets/iban2.jpg',
    },
    {
      'customerName': 'Ali',
      'productName': 'Baju Kebarung Labuh',
      'size': 'S',
      'quantity': 1,
      'totalPayment': 'RM15.00',
      'date': '2/12/24',
      'orderId': 'N1002',
      'status': 'Shipped',
      'image': 'assets/melayu.jpg',
    },
    {
      'customerName': 'Abu',
      'productName': 'Baju Melayu',
      'size': 'S',
      'quantity': 1,
      'totalPayment': 'RM15.00',
      'date': '2/12/24',
      'orderId': 'N1003',
      'status': 'Pending',
      'image': 'assets/melayu2.jpg',
    },
    {
      'customerName': 'Amnan',
      'productName': 'Sapei Sapaq',
      'size': 'S',
      'quantity': 1,
      'totalPayment': 'RM15.00',
      'date': '2/12/24',
      'orderId': 'N1004',
      'status': 'In Progress',
      'image': 'assets/orangUlu2.jpg',
    },
    {
      'customerName': 'Amir',
      'productName': 'Ta`a',
      'size': 'S',
      'quantity': 1,
      'totalPayment': 'RM15.00',
      'date': '2/12/24',
      'orderId': 'N1005',
      'status': 'Cancelled',
      'image': 'assets/orangUlu.jpg',
    },
  ];

  List<Map<String, dynamic>> filteredHistory = [];

  @override
  void initState() {
    super.initState();
    // Initialize the filtered list with all items
    filteredHistory = purchaseHistory;
  }

  void _filterHistory(String query) {
    if (query.isEmpty) {
      // If query is empty, show all items
      setState(() {
        filteredHistory = purchaseHistory;
      });
    } else {
      // Filter items by Order ID
      setState(() {
        filteredHistory = purchaseHistory
            .where((order) =>
            order['orderId'].toString().toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Purchase History',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Show a dialog for the search bar
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Search by Order ID'),
                    content: TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Enter Order ID (e.g., N1000)',
                      ),
                      onChanged: (value) {
                        _filterHistory(value);
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          _searchController.clear();
                          _filterHistory('');
                          Navigator.of(context).pop();
                        },
                        child: const Text('Clear'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListView.builder(
          itemCount: filteredHistory.length,
          itemBuilder: (context, index) {
            final purchase = filteredHistory[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        purchase['image'],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 15),
                    // Order Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Customer Name
                          Text(
                            purchase['customerName'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          // Product Name
                          Text(
                            purchase['productName'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                          // Size and Quantity
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Size: ${purchase['size']}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                'x${purchase['quantity']}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          // Total Payment
                          Text(
                            'Total Payment: ${purchase['totalPayment']}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 5),
                          // Date and Order ID
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                purchase['date'],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                'Order ID: ${purchase['orderId']}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Status
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        purchase['status'],
                        style: TextStyle(
                          fontSize: 14,
                          color: purchase['status'] == 'In Progress'
                              ? Colors.orange
                              : purchase['status'] == 'Completed'
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
