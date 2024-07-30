import 'package:budgetbuddy/screens/onboding/components/email_signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'sign_in_form.dart';

void showCustomDialog(BuildContext context, {required ValueChanged<bool> onValue}) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Signin_Barrier",
    barrierDismissible: true, // Allows dismissing by tapping outside
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) {
      return Center(
        child: DialogContent(onClose: onValue),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      tween = Tween(begin: const Offset(0, -1), end: Offset.zero);

      return SlideTransition(
        position: tween.animate(
          CurvedAnimation(parent: anim, curve: Curves.easeInOut),
        ),
        child: child,
      );
    },
  );
}

class DialogContent extends StatefulWidget {
  final ValueChanged<bool> onClose;

  const DialogContent({super.key, required this.onClose});

  @override
  State<DialogContent> createState() => _DialogContentState();
}

class _DialogContentState extends State<DialogContent> {
  bool showSignUpPage = false;

  void toggleSignUpPage() {
    setState(() {
      showSignUpPage = !showSignUpPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // To ensure the dialog has a material ancestor
      child: Center(
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(0, 30),
                    blurRadius: 60,
                  ),
                  const BoxShadow(
                    color: Colors.black45,
                    offset: Offset(0, 30),
                    blurRadius: 60,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!showSignUpPage) ...[
                      const Text(
                        "Sign in",
                        style: TextStyle(
                          fontSize: 34,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          "keep track with your pocket size financial advisor and not lose track of your progress",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SignInForm(), // Ensure SignInForm is properly defined and used
                      const Row(
                        children: [
                          Expanded(
                            child: Divider(),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "OR",
                              style: TextStyle(
                                color: Colors.black26,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          "Sign up with Email, Apple or Google",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: toggleSignUpPage,
                            padding: EdgeInsets.zero,
                            icon: SvgPicture.asset(
                              "assets/icons/email_box.svg",
                              height: 64,
                              width: 64,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                            icon: SvgPicture.asset(
                              "assets/icons/apple_box.svg",
                              height: 64,
                              width: 64,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                            icon: SvgPicture.asset(
                              "assets/icons/google_box.svg",
                              height: 64,
                              width: 64,
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      EmailSignUpPage(toggleSignUpPage: toggleSignUpPage), // Display the email sign-up page
                    ],
                    const SizedBox(height: 24), // Add spacing for the close button
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: -24, // Adjust this value as needed
              child: CircleAvatar(
                radius: 24, // Increase the radius to make the button larger
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 20,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    widget.onClose(true);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
