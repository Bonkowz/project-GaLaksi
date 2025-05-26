import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class ErrorCard extends StatelessWidget {
  const ErrorCard({required this.error, super.key});

  final String? error;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card.outlined(
      color: colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          spacing: 8,
          children: [
            const Icon(Symbols.error_rounded),
            Expanded(
              child: Text(
                error!,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
