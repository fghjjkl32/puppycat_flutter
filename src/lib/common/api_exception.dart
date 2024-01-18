part of 'common.dart';

class APIException implements Exception {
  final String msg;
  final String code;
  final String refer;

  final String caller;
  List<dynamic>? arguments;

  APIException({
    required this.msg,
    required this.code,
    required this.refer,
    required this.caller,
    this.arguments,
  }); // []: optional positional parameters

  @override
  String toString() => '$refer : $msg(code:$code)';

  String getExceptionMsg() => msg;

  String getExceptionCode() => code;

  String getExceptionRefer() => refer;

  String getExceptionCaller() => caller;

  List<dynamic>? getExceptionArgs() => arguments;
}

// enum APIExceptionType {
//   apiExceptionIgnore,
//   apiExceptionDialog,
//   apiException
// }
