import 'package:budgetbuddy/screens/entryPoint/entry_point.dart';
import 'package:budgetbuddy/screens/onboding/onboding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthHandler extends StatelessWidget {
  const AuthHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Close the dialog if it is open
            Future.delayed(const Duration(seconds: 4), () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
            });
            // Introduce a delay before navigating to EntryPoint
            // Future.delayed(const Duration(seconds: 2), () {
            //   Navigator.of(context).pushReplacement(
            //     MaterialPageRoute(builder: (context) => const EntryPoint()),
            //   );
            // });
            return const EntryPoint(); // Return an empty SizedBox during the delay
          } else {
            return const OnbodingScreen();
          }
        },
      ),
    );
  }
}
