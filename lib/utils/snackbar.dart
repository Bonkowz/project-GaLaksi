import 'package:flutter/material.dart';

void showSnackbar({
  required BuildContext context,
  required String message,
  String? actionLabel,
  VoidCallback? onActionPressed,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;

  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    snackBarAnimationStyle: AnimationStyle(
      duration: Durations.medium4,
      reverseDuration: Durations.medium4,
    ),
    SnackBar(
      backgroundColor: colorScheme.inverseSurface,
      content: Text(
        message,
        style: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onInverseSurface,
        ),
      ),
      action:
          actionLabel != null && onActionPressed != null
              ? SnackBarAction(
                label: actionLabel,
                onPressed: onActionPressed,
                textColor: colorScheme.inversePrimary,
              )
              : null,
      elevation: 3.0,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
    ),
  );
}
