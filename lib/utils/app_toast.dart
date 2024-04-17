import 'package:cookpal/utils/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

void displayToast(String message) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: secondaryColor,
    textColor: primaryColor,
    fontSize: 18.sp,
    timeInSecForIosWeb: 1,
    webBgColor: '#18528AFF',
    webPosition: 'center',
  );
}
