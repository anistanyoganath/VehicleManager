import 'package:intl/intl.dart';

class DateUtil {
  static String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }

  static DateTime parseDate(String dateString) {
    return DateFormat('yyyy-MM-dd').parse(dateString);
  }
}
