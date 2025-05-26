import 'package:timezone/timezone.dart' as tz;

abstract class TimeUtils {
  static tz.TZDateTime convertToTZ(DateTime dateTime, String locationName) {
    final location = tz.getLocation(locationName);
    return tz.TZDateTime.from(dateTime, location);
  }

  static String convertDurationToStr(Duration duration) {
    final durations = {
      const Duration(minutes: 10): "10 minutes",
      const Duration(hours: 1): "1 hour",
      const Duration(days: 1): "1 day",
      const Duration(days: 7): "1 week",
    };

    return durations[duration] ?? "${duration.inMinutes} minutes";
  }
}
