import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_authentication/auth.dart';
import 'package:flutter_application_1/screens/login_page.dart';

class logout extends StatelessWidget {
  logout({super.key});

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(user?.email ?? 'User email'),
            ElevatedButton(
              onPressed: () {
                signOut();
                Navigator.push(context, MaterialPageRoute(builder:(context) => LoginPage(),));
              },
              child: const Text('Sign Out'),
            )
          ],
        ),
      ),
    );
  }
}
