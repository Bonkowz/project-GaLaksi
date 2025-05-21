import 'dart:convert';

import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    required this.image,
    required this.firstName,
    required this.backgroundColor,
    required this.textColor,
    super.key,
    this.textStyle,
    this.radius,
  });

  final String image;
  final String firstName;
  final Color backgroundColor;
  final Color textColor;
  final TextStyle? textStyle;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    if (image.isEmpty) {
      return CircleAvatar(
        backgroundColor: backgroundColor,
        radius: radius,
        child: Text(
          firstName.isNotEmpty ? firstName[0].toUpperCase() : '',
          style:
              textStyle ??
              TextStyle(fontWeight: FontWeight.bold, color: textColor),
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
