import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:galaksi/models/user/user_model.dart';
import 'package:galaksi/widgets/public_profile.dart';

class UserAvatar extends StatefulWidget {
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
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  Widget? _cachedAvatar;
  String? _lastImageData;
  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor =
        widget.backgroundColor ??
        Theme.of(context).colorScheme.primaryContainer;
    final effectiveTextColor =
        widget.textColor ?? Theme.of(context).colorScheme.onPrimaryContainer;

    if (_cachedAvatar == null || _lastImageData != widget.user.image) {
      if (widget.user.image.isEmpty) {
        _cachedAvatar = CircleAvatar(
          backgroundColor: effectiveBackgroundColor,
          radius: widget.radius,
          child: Text(
            StringUtils.capitalize(widget.user.firstName)[0],
            style:
                widget.textStyle ??
                TextStyle(
                  fontWeight: FontWeight.bold,
                  color: effectiveTextColor,
                ),
          ),
        );
      } else {
        _cachedAvatar = CircleAvatar(
          foregroundImage: MemoryImage(base64Decode(widget.user.image)),
          radius: widget.radius,
        );
      }
      _lastImageData = widget.user.image;
    }

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => PublicProfile(user: widget.user),
          showDragHandle: true,
          useSafeArea: true,
          isScrollControlled: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
        );
      },
      child: _cachedAvatar,
    );
  }
}
