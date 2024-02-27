import 'package:connectivity_plus/connectivity_plus.dart';

class AppConnectivity {
  static Future<bool> checkConnection() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }
}
