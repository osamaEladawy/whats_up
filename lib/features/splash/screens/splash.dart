// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whats_up/core/routes/page_const.dart';
import 'package:whats_up/core/functions/extinctions.dart';
import 'package:whats_up/core/theme/style.dart';
import 'package:whats_up/features/wellcome/screens/wellcome_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // Future.delayed(const Duration(milliseconds: 3000),(){
    //   context.pushNamedAndRemoveUntil(PageConst.welcomePage);
    // });
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const WelcomePage(),
          ),
          (route) => false,
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          Image.asset(
            "assets/whats_app_logo.png",
            color: Colors.white,
            width: 100.w,
            height: 100.h,
          ),
          Column(
            children: [
              Text(
                "from",
                style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                    color: greyColor.withOpacity(.6)),
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/meta.png",
                    color: Colors.white,
                    width: 35.w,
                    height: 35.h,
                  ),
                  SizedBox(width: 5.h),
                  Text(
                    "Meta",
                    style:
                        TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
            ],
          )
        ],
      ),
    );
  }
}
