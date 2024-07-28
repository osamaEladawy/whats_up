import 'package:flutter/material.dart';
import 'package:whats_up/feutures/app/globel/functions/navigationpage.dart';
import 'package:whats_up/feutures/app/globel/widgets/next_button.dart';
import 'package:whats_up/feutures/theme/style.dart';
import 'package:whats_up/feutures/user/presentation/pages/login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "Welcome to WhatsApp",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: tabColor,
                  ),
                ),
              ),
              Image.asset(
                "assets/bg_image.png",
                height: 400,
                width: 350,
              ),
              Column(
                children: [
                  const Text(
                    "Read our Privacy Policy Tap ,'Agree and Continue'\n             to accept the Team of Service",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  NextButton(
                    text: "Agree And Continue",
                    onPressed: () {
                      navigationPage(context, const LoginPage());
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
