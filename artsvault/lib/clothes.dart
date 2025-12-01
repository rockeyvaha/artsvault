import 'package:flutter/material.dart';
import 'package:artsvault/Baban.dart';
import 'package:artsvault/BajuKebarung.dart';
import 'package:artsvault/BajuMelayu.dart';
import 'package:artsvault/BalduHitam.dart';
import 'package:artsvault/Bidayuh.dart';
import 'package:artsvault/Bidayuh2.dart';
import 'package:artsvault/IbanLelaki.dart';
import 'package:artsvault/IbanPerempuan.dart';
import 'package:artsvault/Kadazan.dart';
import 'package:artsvault/Kadazan2.dart';
import 'package:artsvault/SapeiSapaq.dart';
import 'package:artsvault/Taa.dart';
import 'package:artsvault/widget.dart';

class ClothesPage extends StatefulWidget {
  final String? selectedLocation;
  final String searchQuery;

  const ClothesPage({super.key, this.selectedLocation, required this.searchQuery});

  @override
  ClothesPageState createState() => ClothesPageState();
}

class ClothesPageState extends State<ClothesPage> {
  String searchText = ''; // Holds the search query
  String selectedLocation = 'All Locations'; // Default location filter
  String selectedSortOption = 'Name (A-Z)'; // Default sort option
  String selectedCategory = 'All'; // Default category filter
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Get filtered and sorted costume data
    List<Map<String, String>> costumeData =
    getFilteredCostumes(selectedLocation, searchText, selectedCategory);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search clothes...',
                  hintStyle: TextStyle(color: Colors.black54),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                ),
                onChanged: (value) {
                  setState(() {
                    searchText = value; // Update the search query dynamically
                  });
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.filter_alt, color: Colors.black),
              onPressed: () {
                _showLocationDialog(context);
              },
            ),
          ],
        ),
      ),
      drawer: const SideMenuWidget(),
      body: Column(
        children: [
          // Dashboard Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 'All' category button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = 'All';
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedCategory == 'All' ? Colors.green[600] : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/all.png',
                          height: 50,
                          width: 50,
                        ),
                        const Text('All'),
                      ],
                    ),
                  ),
                ),
                // 'Men' category button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = 'Men';
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedCategory == 'Men' ? Colors.blue[700] : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/man.png',
                          height: 50,
                          width: 50,
                        ),
                        const Text('Men'),
                      ],
                    ),
                  ),
                ),
                // 'Women' category button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = 'Women';
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedCategory == 'Women' ? Colors.pink[600] : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/woman.png',
                          height: 50,
                          width: 50,
                        ),
                        const Text('Women'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Costume Grid
          Expanded(
            child: costumeData.isEmpty
                ? const Center(child: Text("No costumes found"))
                : SingleChildScrollView(
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: costumeData.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final costume = costumeData[index];
                  return GestureDetector(
                    onTap: () {
                      navigateToCostumePage(costume['name']!);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              costume['image']!,
                              fit: BoxFit.cover,
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                color: Colors.black.withOpacity(0.4),
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      costume['name']!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      costume['price']!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter by Location'),
          content: DropdownButtonFormField<String>(
            initialValue: selectedLocation,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            items: [
              'All Locations',
              'Kota Samarahan',
              'Serian',
              'Kuching',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedLocation = newValue!;
              });
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  void navigateToCostumePage(String costumeName) {
    if (costumeName == 'Ngepan Indu Iban') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const IbanPerempuan()));
    } else if (costumeName == 'Ngepan Lelaki Iban') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const IbanLelaki()));
    } else if (costumeName == 'Baju Kebarung Labuh') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Kebarung()));
    } else if (costumeName == 'Baju Melayu') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const BajuMelayuPage()));
    } else if (costumeName == 'Taa') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Taa()));
    } else if (costumeName == 'Sapei Sapaq') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const SapeiSapaq()));
    } else if (costumeName == 'Baju Baban') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const BajuBaban()));
    } else if (costumeName == 'Baju Baldu Hitam') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Balduhitam()));
    } else if (costumeName == 'Sinuangga') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Sinuangga()));
    } else if (costumeName == 'Gaung') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Gaung()));
    } else if (costumeName == 'Bojuh Bidayuh Dayung') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Bidayuh()));
    } else if (costumeName == 'Bojuh Bidayuh Dali') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Bidayuh2()));
    }
  }

  List<Map<String, String>> getFilteredCostumes(
      String? selectedLocation, String searchText, String category) {
    List<Map<String, String>> costumeData = [
      {
        'image': 'assets/iban.jpg',
        'name': 'Ngepan Indu Iban',
        'price': 'RM150.00 / day',
        'category': 'Women'
      },
      {
        'image': 'assets/iban2.jpg',
        'name': 'Ngepan Lelaki Iban',
        'price': 'RM80.00 / day',
        'category': 'Men'
      },
      {
        'image': 'assets/melayu.jpg',
        'name': 'Baju Kebarung Labuh',
        'price': 'RM150.00 / day',
        'category': 'Women'
      },
      {
        'image': 'assets/melayu2.jpg',
        'name': 'Baju Melayu',
        'price': 'RM80.00 / day',
        'category': 'Men'
      },
      {
        'image': 'assets/orangUlu.jpg',
        'name': 'Taa',
        'price': 'RM80.00 / day',
        'category': 'Women'
      },
      {
        'image': 'assets/orangUlu2.jpg',
        'name': 'Sapei Sapaq',
        'price': 'RM80.00 / day',
        'category': 'Men'
      },
      {
        'image': 'assets/melanau.jpg',
        'name': 'Baju Baban',
        'price': 'RM80.00 / day',
        'category': 'Women'
      },
      {
        'image': 'assets/melanau2.jpg',
        'name': 'Baju Baldu Hitam',
        'price': 'RM80.00 / day',
        'category': 'Men'
      },
      {
        'image': 'assets/kadazan.jpg',
        'name': 'Sinuangga',
        'price': 'RM80.00 / day',
        'category': 'Women'
      },
      {
        'image': 'assets/kadazan2.jpg',
        'name': 'Gaung',
        'price': 'RM80.00 / day',
        'category': 'Men'
      },
      {
        'image': 'assets/bidayuh.jpg',
        'name': 'Bojuh Bidayuh Dayung',
        'price': 'RM80.00 / day',
        'category': 'Women'
      },
      {
        'image': 'assets/bidayuh2.jpg',
        'name': 'Bojuh Bidayuh Dali',
        'price': 'RM80.00 / day',
        'category': 'Men'
      },
    ];

    // Filter based on location
    switch (selectedLocation) {
      case 'Kota Samarahan':
        break;
      case 'Serian':
        costumeData = costumeData.where((costume) {
          return costume['image']!.contains('iban') ||
              costume['image']!.contains('kadazan');
        }).toList();
        break;
      case 'Kuching':
        costumeData = costumeData.where((costume) {
          return costume['image']!.contains('melayu') ||
              costume['image']!.contains('orangUlu');
        }).toList();
        break;
      default:
    }

    // Filter based on search text and category
    costumeData = costumeData.where((costume) {
      final isSearchMatch = costume['name']!
          .toLowerCase()
          .contains(searchText.toLowerCase());
      final isCategoryMatch = category == 'All' ||
          costume['category']!.toLowerCase() == category.toLowerCase();
      return isSearchMatch && isCategoryMatch;
    }).toList();

    return costumeData;
  }
}
