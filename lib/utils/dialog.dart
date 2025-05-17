import 'package:flutter/material.dart';

void showLoadingDialog({
  required BuildContext context,
  String? message,
  bool barrierDismissible = false,
}) {
  showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder:
        (context) => PopScope(
          canPop: barrierDismissible,
          onPopInvokedWithResult: (didPop, result) {},
          child: Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(width: 16),
                  Text(message ?? "Loading..."),
                ],
              ),
            ),
          ),
        ),
  );
}

void showCustomDialog({
  required BuildContext context,
  required Widget child,
  bool barrierDismissible = true,
}) {
  showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => child,
  );
}
