import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'login_page.dart';

class ProfileScreen extends StatefulWidget {
  final dynamic userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? profilePictureUrl;
  String name = "";
  String email = "";
  bool isLoading = true; // Track loading state
  String errorMessage = ""; // To store any error messages

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        email = user.email ?? "No email";
      });

      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('userId', isEqualTo: widget.userId)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot docSnapshot = querySnapshot.docs.first;

          setState(() {
            name = docSnapshot['name'] ?? "No name";
            profilePictureUrl = null;
            isLoading = false;
          });
        } else {
          setState(() {
            name = "User not found";
            isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          errorMessage = "Error fetching user data: ${e.toString()}";
          isLoading = false;
        });
      }
    } else {
      setState(() {
        errorMessage = "User not logged in";
        isLoading = false;
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut(); // Sign out the user
    // Navigate back to the login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()), // Replace with your login screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : errorMessage.isNotEmpty
            ? Text(errorMessage)
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: profilePictureUrl != null
                  ? NetworkImage(profilePictureUrl!)
                  : null,
              child: profilePictureUrl == null
                  ? const Icon(
                Icons.person,
                size: 50,
                color: Colors.grey,
              )
                  : null,
            ),
            const SizedBox(height: 20),
            Text(
              name.isNotEmpty ? name : "Loading...",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              email.isNotEmpty ? email : "Loading...",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Edit Profile logic here
              },
              child: const Text('Edit Profile'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Change Password logic here
              },
              child: const Text('Change Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _logout(context), // Call the logout function
              child: const Text('Logout'),
            ),
            const SizedBox(height: 20),
            const Text('Contact us'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.linkedin),
                  onPressed: () {
                    // Open LinkedIn profile
                  },
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.twitter),
                  onPressed: () {
                    // Open Twitter profile
                  },
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.facebook),
                  onPressed: () {
                    // Open Facebook profile
                  },
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.instagram),
                  onPressed: () {
                    // Open Instagram profile
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
