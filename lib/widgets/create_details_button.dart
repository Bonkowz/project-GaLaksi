import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class CreateDetailsButton extends StatelessWidget {
  CreateDetailsButton({
    super.key,
    required this.text,
    required this.leadingIcon,
    required this.trailingIcon,
  });

  String text;
  Icon leadingIcon;
  Icon trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            Padding(padding: const EdgeInsets.all(24.0), child: leadingIcon),
            Expanded(child: Text(text)),
            Padding(padding: const EdgeInsets.all(24.0), child: trailingIcon),
          ],
        ),
      ),
    );
  }
}
