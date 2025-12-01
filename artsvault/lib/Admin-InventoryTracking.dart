import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdminInventoryTracking(),
    );
  }
}

class AdminInventoryTracking extends StatefulWidget {
  const AdminInventoryTracking({super.key});

  @override
  _AdminInventoryTrackingState createState() => _AdminInventoryTrackingState();
}

class _AdminInventoryTrackingState extends State<AdminInventoryTracking> {
  List<Map<String, dynamic>> items = [
    {
      "name": "Ngepan Indu Iban",
      "stockS": 0,
      "stockM": 0,
      "image": 'assets/iban.jpg',
    },
    {
      "name": "Ngepan Lelaki Iban",
      "stockS": 0,
      "stockM": 0,
      "image": 'assets/iban2.jpg',
    },
    // Add other items here
  ];

  @override
  void initState() {
    super.initState();
    fetchItemsFromFirestore();
  }

  Future<void> fetchItemsFromFirestore() async {
    try {
      List<Map<String, dynamic>> fetchedItems = [];
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('inventory')
          .get();

      for (var doc in querySnapshot.docs) {
        fetchedItems.add({
          "name": doc.id,
          "stockS": doc["S"] ?? 0, // Match the Firestore field name
          "stockM": doc["M"] ?? 0, // Match the Firestore field name
          "image": doc["Image"] ?? "assets/default.jpg", // Provide a default value
        });
      }

      setState(() {
        items = fetchedItems;
      });
    } catch (e) {
      print("Failed to fetch items: $e");
    }
  }

  void updateStock(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController stockSController = TextEditingController();
        final TextEditingController stockMController = TextEditingController();

        return AlertDialog(
          title: const Text("Update Stock"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: stockSController,
                decoration: const InputDecoration(labelText: "Stock S"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: stockMController,
                decoration: const InputDecoration(labelText: "Stock M"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Update"),
              onPressed: () async {
                try {
                  int newStockS = int.tryParse(stockSController.text) ?? items[index]["stockS"];
                  int newStockM = int.tryParse(stockMController.text) ?? items[index]["stockM"];

                  await FirebaseFirestore.instance
                      .collection('inventory')
                      .doc(items[index]["name"])
                      .set({
                    "S": newStockS,
                    "M": newStockM,
                    "Image": items[index]["image"],
                  });

                  setState(() {
                    items[index]["stockS"] = newStockS;
                    items[index]["stockM"] = newStockM;
                  });

                  Navigator.of(context).pop();

                  // Display a success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Stock updated successfully!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  Navigator.of(context).pop();

                  // Display an error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Failed to update stock: $e"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventory Tracking"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: items.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: Image.asset(
                items[index]['image'],
                width: 50,
                height: 50,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, color: Colors.red);
                },
              ),
              title: Text(items[index]['name']),
              subtitle: Text(
                  "Stock S: ${items[index]['stockS']}\nStock M: ${items[index]['stockM']}"),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.orange),
                onPressed: () => updateStock(index),
              ),
            ),
          );
        },
      ),
    );
  }
}