import 'dart:convert';

import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    required this.image,
    required this.firstName,
    this.backgroundColor,
    this.textColor,
    this.textStyle,
    this.radius,
    super.key,
  });

  final String image;
  final String firstName;
  final Color? backgroundColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor =
        backgroundColor ?? Theme.of(context).colorScheme.primaryContainer;
    final effectiveTextColor =
        textColor ?? Theme.of(context).colorScheme.onPrimaryContainer;

    if (image.isEmpty) {
      return CircleAvatar(
        backgroundColor: effectiveBackgroundColor,
        radius: radius,
        child: Text(
          firstName.isNotEmpty ? firstName[0].toUpperCase() : '',
          style:
              textStyle ??
              TextStyle(fontWeight: FontWeight.bold, color: effectiveTextColor),
        ),
      );
    } else {
      return CircleAvatar(
        foregroundImage: MemoryImage(base64Decode(image)),
        radius: radius,
      );
    }
  }
}
