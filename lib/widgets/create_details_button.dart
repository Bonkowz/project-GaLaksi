import 'package:flutter/material.dart';

class CreateDetailsButton extends StatelessWidget {
  const CreateDetailsButton({
    required this.text,
    required this.leadingIcon,
    required this.trailingIcon,
    required this.navigateTo,
    super.key,
  });

  final String text;
  final Icon leadingIcon;
  final Icon trailingIcon;
  final Widget navigateTo;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: InkWell(
        onTap: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => navigateTo));
        },
        borderRadius: BorderRadius.circular(12),
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
