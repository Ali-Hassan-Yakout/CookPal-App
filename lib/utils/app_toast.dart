import 'package:cookpal/utils/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void displayToast(String message){
  Fluttertoast.cancel();
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: secondaryColor,
      textColor: primaryColor,
      fontSize: 18.sp
  );
}