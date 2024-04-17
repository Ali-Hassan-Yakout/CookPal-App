import 'package:cookpal/ui/login/screen/login_screen.dart';
import 'package:cookpal/ui/register/screen/register_screen.dart';
import 'package:cookpal/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class AppOnBoarding extends StatelessWidget {
  const AppOnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoardingSlider(
        onFinish: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const RegisterScreen(),
            ),
            (route) => false,
          );
        },
        trailingFunction: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
            (route) => false,
          );
        },
        headerBackgroundColor: primaryColor,
        finishButtonText: 'Register',
        finishButtonTextStyle: TextStyle(
          color: primaryColor,
          fontSize: 19.sp,
          fontWeight: FontWeight.bold,
          fontFamily: 'playFairDisplay',
        ),
        finishButtonStyle: FinishButtonStyle(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          backgroundColor: secondaryColor,
        ),
        skipTextButton: Text(
          'Skip',
          style: TextStyle(
            color: secondaryColor,
            fontSize: 17.sp,
          ),
        ),
        trailing: Text(
          'Login',
          style: TextStyle(
            color: secondaryColor,
            fontSize: 17.sp,
          ),
        ),
        centerBackground: true,
        pageBackgroundColor: primaryColor,
        background: const [
          SizedBox(),
          SizedBox(),
          SizedBox(),
          SizedBox(),
        ],
        totalPage: 4,
        speed: 1.5,
        pageBodies: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              children: [
                Text(
                  'Welcome to CookPal!',
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 19.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'playFairDisplay',
                  ),
                ),
                Expanded(
                  child: Lottie.asset(
                    'assets/animations/slide_1.json',
                    fit: BoxFit.contain,
                  ),
                ),
                Text(
                  'Your Personal Cooking Companion',
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 17.sp,
                  ),
                ),
                SizedBox(height: 50.h),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              children: [
                Text(
                  'Explore Delicious Recipes',
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 19.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'playFairDisplay',
                  ),
                ),
                Expanded(
                  child: Lottie.asset(
                    'assets/animations/slide_2.json',
                    fit: BoxFit.contain,
                  ),
                ),
                Text(
                  'Browse a wide variety of recipes from around the world',
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 17.sp,
                  ),
                ),
                SizedBox(height: 50.h),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              children: [
                Text(
                  'Save Your Favorites',
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 19.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'playFairDisplay',
                  ),
                ),
                Expanded(
                  child: Lottie.asset(
                    'assets/animations/slide_3.json',
                    fit: BoxFit.contain,
                  ),
                ),
                Text(
                  'Bookmark recipes you love and access them anytime',
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 17.sp,
                  ),
                ),
                SizedBox(height: 50.h),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              children: [
                Text(
                  "Let's Get Cooking!",
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 19.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'playFairDisplay',
                  ),
                ),
                Expanded(
                  child: Lottie.asset(
                    'assets/animations/slide_4.json',
                    fit: BoxFit.contain,
                  ),
                ),
                Text(
                  'Start your culinary journey with CookPal now',
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 17.sp,
                  ),
                ),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
