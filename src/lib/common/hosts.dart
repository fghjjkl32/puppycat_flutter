part of 'common.dart';

// Future<String> getBaseUrl() async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getString('selectedURL') ?? baseUrl;
// }
//
// Future<String> getBaseWalkUrl() async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getString('selectedWalkURL') ?? walkBaseUrl;
// }
//
// Future<String> getBaseWalkGpsUrl() async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getString('selectedWalkGpsURL') ?? walkGpsBaseUrl;
// }
//
// Future<String> getThumborHostUrl() async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getString('thumborHostUrl') ?? thumborHostUrl;
// }
//
// Future<String> getThumborKey() async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getString('thumborKey') ?? thumborKey;
// }
//
// Future<String> getThumborDomain() async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getString('thumborDomain') ?? '';
// }
//
// Future<String> getInspectS3Domain() async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getString('selectedInspectS3URL') ?? inspectS3BaseUrl;
// }
//
// Future<String> getUpdateS3Domain() async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getString('selectedUpdateS3URL') ?? updateS3BaseUrl;
// }
//

enum RunningMode {
  dev,
  stg,
  prd,
}

String baseUrl = dotenv.env['PRD_API_BASE_URL']!;
String thumborHostUrl = dotenv.env['PRD_THUMBOR_HOST_URL']!;
String thumborKey = dotenv.env['PRD_THUMBOR_KEY']!;
String inspectS3BaseUrl = dotenv.env['PRD_INSPECT_S3_BASE_URL']!; //prd
String updateS3BaseUrl = dotenv.env['PRD_UPDATE_S3_BASE_URL']!; //prd
String walkBaseUrl = dotenv.env['PRD_WALK_BASE_URL']!;
String walkGpsBaseUrl = dotenv.env['PRD_WALK_GPS_BASE_URL']!;
String memberBaseUrl = dotenv.env['PRD_MEMBER_BASE_URL']!;
String chatBaseUrl = dotenv.env['PRD_CHAT_BASE_URL']!;
String commonBaseUrl = dotenv.env['PRD_COMMON_BASE_URL']!;

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
  final RunningMode mode = await getRunningMode();
  // const RunningMode mode = RunningMode.stg;

  print('current mode : $mode');
  switch (mode) {
    case RunningMode.dev:
      print('dev');
      baseUrl = dotenv.env['DEV_API_BASE_URL']!;
      thumborHostUrl = dotenv.env['DEV_THUMBOR_HOST_URL']!;
      thumborKey = dotenv.env['DEV_THUMBOR_KEY']!;
      inspectS3BaseUrl = dotenv.env['DEV_INSPECT_S3_BASE_URL']!; //prd
      updateS3BaseUrl = dotenv.env['DEV_UPDATE_S3_BASE_URL']!; //prd
      walkBaseUrl = dotenv.env['DEV_WALK_BASE_URL']!;
      walkGpsBaseUrl = dotenv.env['DEV_WALK_GPS_BASE_URL']!;
      memberBaseUrl = dotenv.env['DEV_MEMBER_BASE_URL']!;
      chatBaseUrl = dotenv.env['DEV_CHAT_BASE_URL']!;
      commonBaseUrl = dotenv.env['DEV_COMMON_BASE_URL']!;
      break;
    case RunningMode.stg:
      print('stg');
      baseUrl = dotenv.env['STG_API_BASE_URL']!;
      thumborHostUrl = dotenv.env['STG_THUMBOR_HOST_URL']!;
      thumborKey = dotenv.env['STG_THUMBOR_KEY']!;
      inspectS3BaseUrl = dotenv.env['STG_INSPECT_S3_BASE_URL']!; //prd
      updateS3BaseUrl = dotenv.env['STG_UPDATE_S3_BASE_URL']!; //prd
      walkBaseUrl = dotenv.env['STG_WALK_BASE_URL']!;
      walkGpsBaseUrl = dotenv.env['STG_WALK_GPS_BASE_URL']!;
      memberBaseUrl = dotenv.env['STG_MEMBER_BASE_URL']!;
      chatBaseUrl = dotenv.env['STG_CHAT_BASE_URL']!;
      commonBaseUrl = dotenv.env['STG_COMMON_BASE_URL']!;
      break;
    case RunningMode.prd:
      print('prd');
      baseUrl = dotenv.env['PRD_API_BASE_URL']!;
      thumborHostUrl = dotenv.env['PRD_THUMBOR_HOST_URL']!;
      thumborKey = dotenv.env['PRD_THUMBOR_KEY']!;
      inspectS3BaseUrl = dotenv.env['PRD_INSPECT_S3_BASE_URL']!; //prd
      updateS3BaseUrl = dotenv.env['PRD_UPDATE_S3_BASE_URL']!; //prd
      walkBaseUrl = dotenv.env['PRD_WALK_BASE_URL']!;
      walkGpsBaseUrl = dotenv.env['PRD_WALK_GPS_BASE_URL']!;
      memberBaseUrl = dotenv.env['PRD_MEMBER_BASE_URL']!;
      chatBaseUrl = dotenv.env['PRD_CHAT_BASE_URL']!;
      commonBaseUrl = dotenv.env['PRD_COMMON_BASE_URL']!;
      break;
    default:
  }
}
