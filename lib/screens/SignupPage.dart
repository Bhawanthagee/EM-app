import 'package:app01/model/user.dart';
import 'package:app01/service/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DatabaseService _databaseService = DatabaseService();

  String? _errorMessage;

  // Signup function with Firestore
  Future<void> signUpUsingEmailAndPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_passwordController.text != _confirmPasswordController.text) {
        setState(() {
          _errorMessage = "Passwords do not match";
        });
        return;
      }

      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      try {
        // Create user with FirebaseAuth
        UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        String uid = userCredential.user!.uid;

        AppUser newUser = AppUser(
          userId: uid,
          name: _nameController.text,
          email: _emailController.text,
          createdOn: Timestamp.now(),
        );

        await _databaseService.addUser(uid, newUser);
        

        print("User registered and saved to Firestore successfully");

        // Navigate back to login page after successful signup
        Navigator.of(context).pop();
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = e.code == "email-already-in-use"
              ? "This email is already in use."
              : "Error: ${e.message}";
        });
        print("Firebase Auth error: ${e.message}");
      } catch (e) {
        setState(() {
          _errorMessage = "Error saving data to Firestore";
        });
        print("Firestore error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Signup")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "SpendWise",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 44.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 44),
                  // Name text field
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: "Name",
                      prefixIcon: Icon(Icons.person, color: Colors.black),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 26),
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
                  // Confirm Password text field
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Confirm Password",
                      prefixIcon: Icon(Icons.key, color: Colors.black),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
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
                  Container(
                    width: double.infinity,
                    child: RawMaterialButton(
                      fillColor: Colors.blue,
                      elevation: 0.0,
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      onPressed: signUpUsingEmailAndPassword,
                      child: const Text(
                        "Sign Up",
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
        )
      ),
    );
  }
}
