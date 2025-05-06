import 'package:flutter/material.dart';

abstract class InputDecorations {
  static InputDecoration outlineBorder({
    required BuildContext context,
    String? labelText,
    String? hintText,
    String? errorText,
    String? helperText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    EdgeInsetsGeometry? contentPadding,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      errorText: errorText,
      helperText: helperText ?? "",
      contentPadding:
          contentPadding ??
          const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
    );
  }
}
