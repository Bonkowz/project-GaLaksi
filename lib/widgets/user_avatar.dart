import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:galaksi/models/user/user_model.dart';
import 'package:galaksi/widgets/public_profile.dart';

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

    Widget avatarContent;
    if (user.image.isEmpty) {
      avatarContent = CircleAvatar(
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
      avatarContent = CircleAvatar(
        foregroundImage: MemoryImage(base64Decode(user.image)),
        radius: radius,
      );
    }
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => PublicProfile(user: user),
          showDragHandle: true,
          useSafeArea: true,
          isScrollControlled: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
        );
      },
      child: avatarContent,
    );
  }
}
