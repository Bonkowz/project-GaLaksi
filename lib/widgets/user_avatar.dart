import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:galaksi/models/user/user_model.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    required this.user,
    this.backgroundColor,
    this.textColor,
    this.textStyle,
    this.radius,
    super.key,
  });

  final User user;
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

    if (user.image.isEmpty) {
      return CircleAvatar(
        backgroundColor: effectiveBackgroundColor,
        radius: radius,
        child: Text(
          StringUtils.capitalize(user.firstName)[0],
          style:
              textStyle ??
              TextStyle(fontWeight: FontWeight.bold, color: effectiveTextColor),
        ),
      );
    } else {
      return CircleAvatar(
        foregroundImage: MemoryImage(base64Decode(user.image)),
        radius: radius,
      );
    }
  }
}
