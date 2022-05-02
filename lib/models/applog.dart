import 'package:haushaltsbuch/services/globals.dart';

class AppLog {
  String? exception;
  String? explanation;
  DateTime? datetime;
  String? appVersion;

  AppLog(String ex, String explanation) {
    this.exception = ex;
    this.explanation = explanation;
    this.datetime = DateTime.now();
    this.appVersion = Globals.version;
  }
}
