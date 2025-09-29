import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class CheckNetworkUtility {
  Future<bool> hasNetwork() async {
  try {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return false; // No network at all
    }

    // Fast internet check with timeout
    final result = await InternetAddress.lookup('google.com')
        .timeout(const Duration(seconds: 2));

    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } catch (_) {
    return false; // Any error treat as offline
  }
}
}