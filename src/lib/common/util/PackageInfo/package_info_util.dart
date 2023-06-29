
import 'package:package_info_plus/package_info_plus.dart';

class PackageInformationUtil {
  late PackageInfo packageInfo;
  final List<String> _installerNameList = [
    'com.skt.skaf.A000Z00040',
    'com.kt.om.ktpackageinstaller',
    'com.android.ktpackageinstaller',
    'com.kt.olleh.storefront',
    'com.kt.olleh.istore',
    'com.lguplus.installer',
    'com.lguplus.appstore',
    'android.lgt.appstore',
  ];

  Future init() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  String get appVersion => packageInfo.version;
  String get appBuildNumber => packageInfo.buildNumber;
  String get pkgName => packageInfo.packageName;
  String get applicationName => packageInfo.appName;
  String get installer => getInstaller();

  String getInstaller() {
    String? installerStore = packageInfo.installerStore;
    if(installerStore == null) {
      return "UNKNOWN_INSTALLER";
    }

    if(_installerNameList.contains(installerStore)) {
      return installerStore;
    } else {
      return "UNKNOWN_INSTALLER";
    }
  }



  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      "name": applicationName,
      "packageName": pkgName,
      "version": appVersion,
      "buildNumber": appBuildNumber,
    };

    return json;
  }
}