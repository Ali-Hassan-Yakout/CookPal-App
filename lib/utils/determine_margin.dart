import 'package:flutter_screenutil/flutter_screenutil.dart';

bool determineMargin() {
  if (ScreenUtil().orientation.index==1) {
    return true;
  } else {
    return false;
  }
}