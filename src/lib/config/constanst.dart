import 'package:intl/intl.dart';

String displayedAt(DateTime time) {
  var milliSeconds = DateTime.now().difference(time).inMilliseconds;
  var seconds = milliSeconds / 1000;
  if (seconds < 60) return '방금 전';
  var minutes = seconds / 60;
  if (minutes < 60) return '${minutes.floor()}분 전';
  var hours = minutes / 60;
  if (hours < 24) return '${hours.floor()}시간 전';
  var days = hours / 24;
  if (days < 7) return '${days.floor()}일 전';
  return DateFormat('yyyy-MM-dd').format(time);
}
