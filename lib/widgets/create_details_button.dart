import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class CreateDetailsButton extends StatelessWidget {
  CreateDetailsButton({
    super.key,
    required this.text,
    required this.leadingIcon,
    required this.trailingIcon,
    required this.navigateTo,
  });

  String text;
  Icon leadingIcon;
  Icon trailingIcon;
  Widget navigateTo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => navigateTo));
      },
      child: Card.outlined(
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
      ),
    );
  }
}
