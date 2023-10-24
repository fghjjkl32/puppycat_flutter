import 'package:location/location.dart';

class LocationUtil {
  static checkLocationPermission() async  {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await Location().serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await Location().requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await Location().hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await Location().requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    Location().enableBackgroundMode(enable: true);
  }

  static Future<LocationData> getCurrentLocation() async {
    final locationData = await Location().getLocation();
    return locationData;
  }
}