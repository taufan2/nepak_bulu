import 'package:intl/intl.dart';

// Formatter tanggal untuk menampilkan tanggal dalam format yang diinginkan
String formatDateFromDateTime(DateTime date, String format) {
  return DateFormat(format).format(date);
}