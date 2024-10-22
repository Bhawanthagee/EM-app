import 'package:app01/screens/HomePage.dart';
import 'package:app01/screens/landingScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';  // Importing modal_progress_hud package
import 'SignupPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _errorMessage;
  bool showSpinner = false;

  // Login function
  Future<void> loginUsingEmailAndPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      FirebaseAuth auth = FirebaseAuth.instance;
      setState(() {
        showSpinner = true; // Show spinner
      });
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        String userId = userCredential.user!.uid;
        // Navigate to HomePage if successful
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LandingScreen(userId: userId,)),
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = e.code == "user-not-found"
              ? "No user found for that email."
              : "An error occurred. Please try again.";
        });
      } finally {
        setState(() {
          showSpinner = false; // Hide spinner
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: Colors.white,

      body: ModalProgressHUD(
        inAsyncCall: showSpinner,

        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Image(
                      image:AssetImage(
                          'assests/loginpageimage.png'
                      )

                  ),

                  const SizedBox(height: 8.0),
                  const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 44.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 44),
                  // Email text field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "Email",
                      prefixIcon: Icon(Icons.mail, color: Colors.black),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      // Basic email validation
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 26),
                  // Password text field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Password",
                      prefixIcon: Icon(Icons.key, color: Colors.black),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 26),
                  if (_errorMessage != null) ...[
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                  ],
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SignupPage()),
                      );
                    },
                    child: const Text(
                      "Don't have an Account? Click here.",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 26),
                  Container(
                    width: double.infinity,
                    child: RawMaterialButton(
                      fillColor: Colors.blue,
                      elevation: 0.0,
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      onPressed: loginUsingEmailAndPassword,
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
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
