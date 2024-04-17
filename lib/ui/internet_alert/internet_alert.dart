import 'package:cookpal/main.dart';
import 'package:cookpal/utils/app_connectivity.dart';
import 'package:cookpal/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class InternetAlert extends StatelessWidget {
  const InternetAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Check Your Internet',
              style: TextStyle(
                color: secondaryColor,
                fontSize: 25.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'playFairDisplay',
              ),
            ),
            Lottie.asset(
              'assets/animations/check_internet.json',
              fit: BoxFit.contain,
              alignment: Alignment.center,
            ),
            SizedBox(
              width: 300.w,
              height: 50.h,
              child: ElevatedButton(
                onPressed: () async {
                  if (await AppConnectivity.checkConnection()) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyApp(),
                      ),
                      (route) => false,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  backgroundColor: secondaryColor,
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  'Retry',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'playFairDisplay',
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
