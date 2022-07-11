import 'package:connectivity_plus/connectivity_plus.dart';

abstract class BaseRepository {
  ///Check if device is connected to an active internet connection.
  Future<bool> isConnectedToInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    //Internet is not connected.
    return false;
  }
}

class NoInternetConnectionException implements Exception {
  final String message = "'Whoops No Internet connection..'";
}
