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
    Color? borderColor,
    double? borderRadius,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor ?? const Color(0xFF000000)),
        borderRadius:
            borderRadius == null
                ? const BorderRadius.all(Radius.circular(4.0))
                : BorderRadius.all(Radius.circular(borderRadius)),
      ),
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      errorText: errorText,
      helperText: helperText ?? "",
      contentPadding: contentPadding,
    );
  }

  static InputDecoration underlineBorder({
    required BuildContext context,
    String? labelText,
    String? hintText,
    String? errorText,
    String? helperText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    Color? borderColor,
    double? borderRadius,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return InputDecoration(
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: borderColor ?? const Color(0xFF000000)),
        borderRadius:
            borderRadius == null
                ? BorderRadius.zero
                : BorderRadius.all(Radius.circular(borderRadius)),
      ),
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      errorText: errorText,
      helperText: helperText ?? "",
      contentPadding: contentPadding,
    );
  }
}
