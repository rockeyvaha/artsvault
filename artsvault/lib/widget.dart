import 'package:flutter/material.dart';
import 'package:artsvault/LoginPage.dart';
import 'Cart.dart';
import 'order_tracking.dart';
import 'privacy_policy.dart';
import 'Payment.dart';
import 'User-MyProfile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String phoneNumber = '';
  String email = '';
  String address = '';
  String? gender; // Set to null for blank default
  String password = '';
  String newPassword = '';
  String? passwordError;
  bool passwordValid = true;

  // List of password validation conditions
  List<String> passwordRequirements = [
    "- Password must include a lowercase letter.",
    "- Password must include an uppercase letter.",
    "- Password must include a symbol (e.g. @\$!%*?&).",
    "- Password must be at least 8 characters long."
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Image.asset('assets/close.png', height: 24, width: 24),
              onPressed: () {
                Navigator.pop(context); // Return to the previous page
              },
            );
          },
        ),
      ),
      drawer: const SideMenuWidget(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 60),
                Center(
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey.shade200,
                    child: Image.asset(
                      'assets/app-icon.png',
                      fit: BoxFit.cover,
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Name field
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Name', style: TextStyle(fontSize: 10)),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    name = value;
                  },
                ),
                const SizedBox(height: 10),
                // Phone Number field
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Phone Number', style: TextStyle(fontSize: 10)),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter your phone number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number is required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    phoneNumber = value;
                  },
                ),
                const SizedBox(height: 10),
                // Gmail field
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Gmail', style: TextStyle(fontSize: 10)),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter your Gmail',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Gmail is required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    email = value;
                  },
                ),
                const SizedBox(height: 10),
                // Address field
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Address', style: TextStyle(fontSize: 10)),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter your address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.location_on),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Address is required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    address = value;
                  },
                ),
                const SizedBox(height: 7),
                // Gender field
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Gender', style: TextStyle(fontSize: 10)),
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    hintText: 'Select Gender',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  initialValue: gender,
                  items: <String>['Male', 'Female']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          value,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      gender = newValue;
                    });
                  },
                ),
                const SizedBox(height: 10),
                // Enter Password field
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Enter Password', style: TextStyle(fontSize: 10)),
                ),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    // Regex for password validation: at least one lowercase, one uppercase, one symbol, and 8 characters long
                    if (!RegExp(
                        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
                        .hasMatch(value)) {
                      setState(() {
                        passwordValid = false;
                      });
                      return null; // Let the custom error display below
                    }
                    setState(() {
                      passwordValid = true;
                    });
                    password = value;
                    return null;
                  },
                ),
                // Display password requirements bullet points if the password is invalid
                if (!passwordValid)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        'Password must meet the following requirements:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      for (var requirement in passwordRequirements)
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Row(
                            children: [
                              const Icon(Icons.fiber_manual_record, size: 8),
                              const SizedBox(width: 5),
                              Expanded(child: Text(requirement)),
                            ],
                          ),
                        ),
                    ],
                  ),
                const SizedBox(height: 10),
                // Enter New Password field
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Enter New Password',
                      style: TextStyle(fontSize: 10)),
                ),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your new password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'New password is required';
                    }
                    // Ensure that the new password matches the original password
                    if (value != password) {
                      return 'Passwords do not match';
                    }
                    // Regex for new password validation (same requirements as password)
                    if (!RegExp(
                        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
                        .hasMatch(value)) {
                      return 'Password must include lowercase, uppercase, a symbol, and be at least 8 characters long';
                    }
                    newPassword = value;
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Submit Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFCF4A3),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _showSubmitDialog(context);
                    }
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSubmitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Your personal details have been submitted'),
          content: const Text('Your information has been saved successfully.'),
          actions: <Widget>[
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  alignment: Alignment.center,
                  side: const BorderSide(color: Color(0xFFFCF4A3), width: 2),
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ),
          ],
        );
      },
    );
  }
}

// HomePage Class (with clothing and stuff)
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding:
          const EdgeInsets.only(top: 16.0), // Moves the icon a bit lower
          child: IconButton(
            icon: Image.asset('assets/close.png', height: 24, width: 24),
            onPressed: () {
              Navigator.pop(context); // Return to the previous page
            },
          ),
        ),
      ),
    );
  }
}

// SideMenuWidget Class
class SideMenuWidget extends StatelessWidget {
  const SideMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header Section
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFFFCF4A3), // Yellow background for the header
            ),
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.end, // Align content to the bottom
              children: [
                const Text(
                  'Welcome to ArtsVault',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w200),
                ),
                const SizedBox(height: 20), // Space between the text and images
                // Align the Row to the bottom-left
                Align(
                  alignment: Alignment
                      .bottomLeft, // Align the Row to the bottom-left corner
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.start, // Align content to the left
                    crossAxisAlignment:
                    CrossAxisAlignment.end, // Align content to the bottom
                    children: [
                      // App Icon Image
                      Image.asset(
                        'assets/app-icon.png', // Adjust the path to your app icon
                        width: 40, // Adjust the size as needed
                        height: 40,
                      ),
                      const SizedBox(width: 10), // Space between the images
                      // UNIMAS Logo Image
                      Image.asset(
                        'assets/unimas-logo.png', // Adjust the path to the UNIMAS logo
                        width: 80, // Adjust the size as needed
                        height: 40, // Adjust the size as needed
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          ListTile(
            leading: Image.asset('assets/profile.png', height: 24, width: 24),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UserProfilePage()),
              );
            },
          ),
          ListTile(
            leading: Image.asset('assets/cart.png', height: 24, width: 24),
            title: const Text('Cart'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
          ListTile(
            leading:
            Image.asset('assets/orderTrack.png', height: 24, width: 24),
            title: const Text('Order Tracking'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const OrderTrackingPage()),
              );
            },
          ),
          ListTile(
            leading:
            Image.asset('assets/privacyPolicy.png', height: 24, width: 24),
            title: const Text('Privacy Policy'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyPage()),
              );
            },
          ),
          // Added Help & FAQ Button (Feature)
          ListTile(
            leading: const Icon(Icons.help_outline, size: 24),
            title: const Text('Help & FAQ'),
            onTap: () {
              Navigator.pop(context);
              // Navigation to HelpPage logic here
            },
          ),
          ListTile(
            leading: Image.asset('assets/payment.png', height: 24, width: 24),
            title: const Text('Payment'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentPage(
                    totalAmount: 100.0, cartItems: [], // Replace with the actual total amount
                  ),
                ),
              );
            },
          ),
          // Spacer pushes logout button to the bottom
          const Spacer(),
          // Logout Button
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[400],
                // yellow color for the button
                padding: const EdgeInsets.symmetric(vertical: 5),
              ),
              onPressed: () {
                _showLogoutDialog(context); // Show logout confirmation dialog
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to show the logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                      const LoginPage()), // Navigate to LoginPage
                      (route) => false, // Remove all previous routes
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
