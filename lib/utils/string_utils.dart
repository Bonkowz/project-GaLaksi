import 'package:galaksi/models/travel_plan/travel_activity_model.dart';
import 'package:galaksi/models/travel_plan/travel_plan_model.dart';
import 'package:intl/intl.dart';

abstract class StringUtils {
  /// Normalizes an input email address
  static String normalizeEmail(String email) {
    if (email.isEmpty) return email;

    final emailTrimmed = email.trim();
    final parts = emailTrimmed.split("@");

    // Not a standard email format, just return the string in lowercase
    if (parts.length != 2) {
      return emailTrimmed.toLowerCase();
    }

    // Get local part of email
    var local = parts[0];
    final domain = parts[1].toLowerCase();

    // Remove content after + (alias)
    final plusIndex = local.indexOf("+");
    if (plusIndex != -1) {
      local = local.substring(0, plusIndex);
    }

    // Remove dots from Gmail domains
    // Otherwise they are significant for other domains
    if (domain == "gmail.com" || domain == "googlemail.com") {
      local = local.replaceAll(".", "");
    }

    // Always lowercase the local part
    local = local.toLowerCase();

    return "$local@$domain";
  }

  static String normalizeEmailKeepAlias(String email) {
    if (email.isEmpty) return email;

    final emailTrimmed = email.trim();
    final parts = emailTrimmed.split("@");

    // Not a standard email format, just return the string in lowercase
    if (parts.length != 2) {
      return emailTrimmed.toLowerCase();
    }

    // Get local part of email
    var local = parts[0];
    final domain = parts[1].toLowerCase();

    // Remove dots from Gmail domains
    // Otherwise they are significant for other domains
    if (domain == "gmail.com" || domain == "googlemail.com") {
      local = local.replaceAll(".", "");
    }

    // Always lowercase the local part
    local = local.toLowerCase();

    return "$local@$domain";
  }

  static String getTravelPlanDateRange(TravelPlan travelPlan) {
    final activities = travelPlan.activities;
    if (activities.isEmpty) {
      return "No dates yet";
    }

    final startDates = activities.map((a) => a.startAt);
    final endDates = activities.map((a) => a.endAt);

    final earliest = startDates.reduce((a, b) => a.isBefore(b) ? a : b);
    final latest = endDates.reduce((a, b) => a.isAfter(b) ? a : b);

    final sameYear = earliest.year == latest.year;
    final sameMonth = sameYear && earliest.month == latest.month;
    final sameDay = sameMonth && earliest.day == latest.day;

    if (sameDay) {
      return DateFormat('MMM d, yyyy').format(earliest);
    } else if (sameMonth) {
      final month = DateFormat('MMM').format(earliest);
      final year = earliest.year;
      return "$month ${earliest.day} – ${latest.day}, $year";
    } else if (sameYear) {
      final startFormat = DateFormat('MMM d');
      final endFormat = DateFormat('MMM d, yyyy');
      return "${startFormat.format(earliest)} – ${endFormat.format(latest)}";
    } else {
      final fullFormat = DateFormat('MMM d, yyyy');
      return "${fullFormat.format(earliest)} – ${fullFormat.format(latest)}";
    }
  }

  static String getTravelPlanStatusText(TravelPlan travelPlan) {
    final activities = travelPlan.activities;
    if (activities.isEmpty) return "No dates yet";

    final now = DateTime.now();
    final earliestStart = activities
        .map((a) => a.startAt)
        .reduce((a, b) => a.isBefore(b) ? a : b);
    final latestEnd = activities
        .map((a) => a.endAt)
        .reduce((a, b) => a.isAfter(b) ? a : b);

    if (now.isAfter(latestEnd)) {
      return "Finished";
    } else if (now.isBefore(earliestStart)) {
      final daysUntil = earliestStart.difference(now).inDays + 1;

      switch (daysUntil) {
        case 1:
          return "Happening tomorrow";
        case < 30:
          return "Happening in $daysUntil days";
        case >= 30:
          return "Happening more than a month from now.";
      }
      return "";
    } else {
      return "Ongoing";
    }
  }

  static String getActivityTimeRange(TravelActivity activity) {
    final startTime = DateFormat('h:mm a').format(activity.startAt.toLocal());
    final endTime = DateFormat('h:mm a').format(activity.endAt.toLocal());
    final timeRange = "$startTime to $endTime";

    return timeRange;
  }
}
