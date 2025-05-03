import 'package:flutter/material.dart';

InputDecoration outlineInputDecoration({
  required BuildContext context,
  String? labelText,
  String? hintText,
  String? errorText,
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
    contentPadding:
        contentPadding ??
        const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
  );
}
