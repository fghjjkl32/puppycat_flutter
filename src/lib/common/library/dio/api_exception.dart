class APIException implements Exception {
  final String msg;
  final String code;
  final String refer;

  const APIException({
    required this.msg,
    required this.code,
    required this.refer,
  }); // []: optional positional parameters

  @override
  String toString() => '$refer : $msg(code:$code)';

  String getExceptionMsg() => msg;
  String getExceptionCode() => code;
  String getExceptionRefer() => refer;
}

// enum APIExceptionType {
//   apiExceptionIgnore,
//   apiExceptionDialog,
//   apiException
// }