import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:javalearn/screen/admin/admin_menu.dart';
import 'package:javalearn/screen/auth/auth_screen.dart';
import 'package:javalearn/screen/main_menu.dart';

class LoginChecker extends StatelessWidget {
  const LoginChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(snapshot.data!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data!.data()!['is_admin'] == true) {
                    return const AdminMenu();
                  }
                  return const MainMenu();
                });
          }
          return const AuthScreen();
        });
  }
}
