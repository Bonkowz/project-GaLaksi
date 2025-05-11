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
}
