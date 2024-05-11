import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _pseudoController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Track password visibility for both fields
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  bool isEmailValid(String email) {
    RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._]+@gmail+\.[a-zA-Z]+',
      caseSensitive: false,
    );
    return emailRegex.hasMatch(email);
  }

  Future<void> signUp() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    String pseudo = _pseudoController.text.trim();

    // Validate email
    if (!isEmailValid(email)) {
      showAlertDialog('Error', 'Please enter a valid email address.');
      return;
    }

    // Check for empty fields
    if (email.isEmpty || password.isEmpty || pseudo.isEmpty) {
      showAlertDialog('Error', 'Please fill in all fields.');
      return;
    }

    // Confirm the password matches
    if (password != confirmPassword) {
      showAlertDialog('Error', 'Passwords do not match.');
      return;
    }

    // Validate the password length (minimum 6 characters)
    if (password.length < 6) {
      showAlertDialog('Error', 'Password must be at least 6 characters long.');
      return;
    }

    try {
      // Attempt to create a new user with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Set additional user information in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'comments': [],
        'foodscore': 0,
        'placescore': 0,
        'maraboutscore': 0,
        'imgprofile': null,
        'pseudo': pseudo,
        'rate': 0,
      });

      // Redirect the user to the home screen upon successful registration
      Navigator.of(context).pushNamed('HomeScreen');
    } catch (e) {
      // Print the error to the console and show an error dialog
      showAlertDialog('Error',
          'An error occurred while creating your account. Please try again.');
    }
  }

  void showAlertDialog(String title, String content) {
    // Display an alert dialog with the provided title and content
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  bool passwordConfirmed() {
    return _passwordController.text.trim() ==
        _confirmPasswordController.text.trim();
  }

  void openLoginScreen() {
    Navigator.of(context).pushReplacementNamed('LoginScreen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[700],
      body: SafeArea(
        child: Center(
          // Center the entire content
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image
                  Image.asset(
                    'images/mascotte.png',
                    height: 100,
                  ),
                  const SizedBox(height: 30),
                  // Title
                  Text(
                    'SIGN UP',
                    style: GoogleFonts.robotoCondensed(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Subtitle
                  Text(
                    'Get Started with Sidi Bou App!',
                    style: GoogleFonts.robotoCondensed(fontSize: 18),
                  ),
                  const SizedBox(height: 50),
                  // Email
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Nickname
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: _pseudoController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Nickname',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Password
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible, // Toggle visibility
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Confirm Password
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: _confirmPasswordController,
                        obscureText:
                            !_isConfirmPasswordVisible, // Toggle visibility
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Confirm Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Button Sign Up
                  GestureDetector(
                    onTap: signUp,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red[900],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Sign up',
                          style: GoogleFonts.robotoCondensed(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  // Text Already a Member
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already a member? ',
                        style: GoogleFonts.robotoCondensed(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: openLoginScreen,
                        child: Text(
                          'Sign in here',
                          style: GoogleFonts.robotoCondensed(
                            color: Colors.red[500],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
