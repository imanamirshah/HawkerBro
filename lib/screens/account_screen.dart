import 'package:flutter/material.dart';
import 'package:hawkerbro/provider/auth_provider.dart';
// import 'package:hawkerbro/provider/auth_provider.dart';
import 'package:hawkerbro/screens/add_stall_screen.dart';
import 'package:hawkerbro/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({
    super.key,
  });

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final userModel = ap.userModel;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "My Account",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ap.userSignOut().then(
                    (value) => Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                    ),
                  );
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.black,
              backgroundImage: NetworkImage(userModel.profilePic),
              radius: 50,
            ),
            const SizedBox(height: 20),
            Text(
              userModel.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Text(userModel.email),
            Text(userModel.bio),
            const SizedBox(height: 15),
            SizedBox(
              width: 250,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddStallScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text("Add a new hawker stall"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.yellow[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
