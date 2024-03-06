part of 'common.dart';

enum RunningMode {
  dev,
  stg,
  prd,
}

String baseUrl = "https://api.puppycat.co.kr/";
String thumborHostUrl = "https://tb.puppycat.co.kr/";
String thumborKey = "vjvlzotvldkfel";
String inspectS3BaseUrl = "https://mnt.puppycat.co.kr/maintenance/prd"; //prd
String updateS3BaseUrl = "https://mnt.puppycat.co.kr/update/"; //prd
String walkBaseUrl = 'https://walk-api.puppycat.co.kr/';
String walkGpsBaseUrl = 'https://walk-gps.puppycat.co.kr/';
String memberBaseUrl = 'https://member-api.puppycat.co.kr/';
String chatBaseUrl = "https://chat.puppycat.co.kr/";
String commonBaseUrl = "https://common.puppycat.co.kr/";
String chatWSBaseUrl = 'https://pet-chat-ws.devlabs.co.kr/ws/puppycat';

Future setRunningMode(RunningMode mode) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  print('mode $mode');
  return prefs.setInt('runMode', mode.index);
}

Future<RunningMode> getRunningMode() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final modeIdx = prefs.getInt('runMode') ?? RunningMode.prd.index;
  return RunningMode.values[modeIdx];
}

Future initRunningMode() async {
  // final RunningMode mode = await getRunningMode();
  const RunningMode mode = RunningMode.dev;

  print('current mode : $mode');
  switch (mode) {
    case RunningMode.dev:
      print('dev');
      baseUrl = 'https://pet-api.devlabs.co.kr/';
      thumborHostUrl = 'https://tb.pcstg.co.kr/';
      thumborKey = 'Tjaqhvpt';
      inspectS3BaseUrl = 'https://mnt.puppycat.co.kr/maintenance/prd'; //prd
      updateS3BaseUrl = 'https://mnt.puppycat.co.kr/update/prd'; //prd
      walkBaseUrl = 'https://pet-walk-dev-api.devlabs.co.kr/';
      walkGpsBaseUrl = 'https://pet-walk-dev-gps.devlabs.co.kr/';
      memberBaseUrl = 'https://puppycat-dev-member-api.devlabs.co.kr/';
      chatBaseUrl = 'https://pet-chat.devlabs.co.kr/';
      commonBaseUrl = 'https://common.devlabs.co.kr/';
      chatWSBaseUrl = 'https://pet-chat-ws.devlabs.co.kr/ws/puppycat';
      break;
    case RunningMode.stg:
      print('stg');
      baseUrl = 'https://api.pcstg.co.kr/';
      thumborHostUrl = 'https://tb.pcstg.co.kr/';
      thumborKey = 'Tjaqhvpt';
      inspectS3BaseUrl = 'https://mnt.puppycat.co.kr/maintenance/prd'; //prd
      updateS3BaseUrl = 'https://mnt.puppycat.co.kr/update/prd'; //prd
      walkBaseUrl = 'https://walk-api.pcstg.co.kr/';
      walkGpsBaseUrl = 'https://walk-gps.pcstg.co.kr/';
      memberBaseUrl = 'https://member-api.pcstg.co.kr/';
      chatBaseUrl = 'https://chat.pcstg.co.kr/';
      commonBaseUrl = 'https://common.pcstg.co.kr/';
      chatWSBaseUrl = 'https://ws.pcstg.co.kr/ws/puppycat';

      break;
    case RunningMode.prd:
      print('prd');
      baseUrl = 'https://api.puppycat.co.kr/';
      thumborHostUrl = 'https://tb.puppycat.co.kr/';
      thumborKey = 'vjvlzotvldkfel';
      inspectS3BaseUrl = 'https://mnt.puppycat.co.kr/maintenance/prd'; //prd
      updateS3BaseUrl = 'https://mnt.puppycat.co.kr/update/prd'; //prd
      walkBaseUrl = 'https://walk-api.puppycat.co.kr/';
      walkGpsBaseUrl = 'https://walk-gps.puppycat.co.kr/';
      memberBaseUrl = 'https://member-api.puppycat.co.kr/';
      chatBaseUrl = 'https://chat.puppycat.co.kr/';
      commonBaseUrl = 'https://common.puppycat.co.kr/';
      chatWSBaseUrl = 'https://ws.pcstg.co.kr/ws/puppycat';
      break;
    default:
  }
}
