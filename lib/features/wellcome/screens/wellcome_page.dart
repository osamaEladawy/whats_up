import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whats_up/core/functions/extinctions.dart';
import 'package:whats_up/shared/widgets/next_button.dart';
import 'package:whats_up/core/theme/style.dart';
import 'package:whats_up/features/user/presentation/pages/login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Welcome to WhatsApp",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: tabColor,
                  ),
                ),
              ),
              Image.asset(
                "assets/bg_image.png",
                height: 400.h,
                width: 350.w,
              ),
              Column(
                children: [
                  const Text(
                    "Read our Privacy Policy Tap ,'Agree and Continue'\n             to accept the Team of Service",
                  ),
                  SizedBox(height: 20.h),
                  NextButton(
                    text: "Agree And Continue",
                    onPressed: () {
                      context.push(const LoginPage());
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
