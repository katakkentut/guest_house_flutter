import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static Future<void> setBookingDates(String from, String to) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('bookFrom', from);
    await prefs.setString('bookTo', to);
  }

  static Future<BookDates> getBookingDates() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String from = prefs.getString('bookFrom') ?? '';
    String to = prefs.getString('bookTo') ?? '';
    return BookDates(bookFrom: from, bookTo: to);
  }
}

class BookDates {
  final String bookFrom;
  final String bookTo;

  BookDates({required this.bookFrom, required this.bookTo});
}