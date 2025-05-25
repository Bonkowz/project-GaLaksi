import 'package:timezone/timezone.dart' as tz;

tz.TZDateTime convertToTZ(DateTime dateTime, String locationName) {
  final location = tz.getLocation(locationName);
  return tz.TZDateTime.from(dateTime, location);
}
