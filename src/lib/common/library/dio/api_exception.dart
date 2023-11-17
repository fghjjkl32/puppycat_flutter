class APIException implements Exception {
  final String msg;
  final String code;
  final String refer;

  final String caller;
  List<String>? arguments;

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
  List<String>? getExceptionArgs() => arguments;
}

// enum APIExceptionType {
//   apiExceptionIgnore,
//   apiExceptionDialog,
//   apiException
// }