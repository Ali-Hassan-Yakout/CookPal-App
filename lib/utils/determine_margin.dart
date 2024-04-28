import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

bool determineMargin(BuildContext context) {
  if (ScreenUtil().orientation.index == 1 &&
      MediaQuery.of(context).size.width > 930) {
    return true;
  } else {
    return false;
  }
}
