import 'package:artsvault/Admin-LoginPage.dart';
import 'package:artsvault/Admin-MyProfile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core package
import 'User-Login.dart';
import 'User-MyProfile.dart';
import 'Clothes.dart' as ClothesPageLib1;

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const LoginPage());
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false, // Hide debug banner
      initialRoute: '/', // Set the initial route
      routes: {
        '/': (context) => const HomePage(), // Home page as the default route
        '/login': (context) => const LoginPage(), // Login page route
        '/user-login': (context) => const UserLoginPage(), // User Login page route
        '/admin-login': (context) => const AdminLoginPage(), // Admin Login page route
        '/clothes': (context) =>
        const ClothesPageLib1.ClothesPage(searchQuery: ""), // Clothes page route
        '/profile': (context) => const UserProfilePage(), // User Profile page route
        '/admin-myprofile': (context) => const AdminProfilePage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFACB10),
      body: Center(
        child: Stack(
          children: [
            // UNIMAS logo moved to top-left and resized
            const Align(
              alignment: FractionalOffset(0.05, 0.05), // Top-left corner
              child: Image(
                image: AssetImage('assets/unimas-logo.png'),
                width: 50, // Smaller width
                height: 50, // Smaller height
              ),
            ),
            // App icon at the center
            const Align(
              alignment: FractionalOffset(0.5, 0.3),
              child: Image(
                image: AssetImage('assets/app-icon.png'),
                width: 150, // Set the desired width
                height: 150, // Set the desired height
              ),
            ),
            // App title
            const Align(
              alignment: FractionalOffset(0.5, 0.55),
              child: Text(
                'ArtsVault',
                style: TextStyle(
                  fontSize: 65,
                  color: Colors.white,
                  fontFamily: 'Poppins', // Specify the font family
                  fontWeight: FontWeight.w600, // Semi-bold weight
                ),
              ),
            ),
            // Admin and User Login buttons
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: const FractionalOffset(0.5, 0.75),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffF7DC6F),
                      minimumSize: const Size(327, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40), // Set border radius
                      ),
                    ),
                    child: const Text(
                      'Admin',
                      style: TextStyle(color: Color(0xffFF460A), fontSize: 17),
                    ),
                    onPressed: () {
                      // Navigate to Admin Login Page
                      Navigator.pushNamed(context, '/admin-login');
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: const FractionalOffset(0.5, 0.85),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffF7DC6F),
                      minimumSize: const Size(327, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40), // Set border radius
                      ),
                    ),
                    child: const Text(
                      'User',
                      style: TextStyle(color: Color(0xffFF460A), fontSize: 17),
                    ),
                    onPressed: () {
                      // Navigate to User Login Page
                      Navigator.pushNamed(context, '/user-login');
                    },
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
