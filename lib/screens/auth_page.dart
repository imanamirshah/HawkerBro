import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hawkerbro/screens/home_screen.dart';
import 'package:hawkerbro/screens/login_or_register.dart';
import 'package:hawkerbro/screens/register_screen.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return HomeScreen();
          }

          // user is NOT logged in
          else {
            return LoginOrRegisterPage(
              onTap: () {},
            );
          }
        },
      ),
    );
  }
}
