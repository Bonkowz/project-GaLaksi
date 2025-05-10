import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/providers/onboarding/onboarding_notifier.dart';
import 'package:material_symbols_icons/symbols.dart';

class Onboarding6Complete extends ConsumerWidget {
  const Onboarding6Complete({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "You're all set!",
                      style: textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Symbols.check_rounded,
                      size: constraints.maxWidth * 0.8,
                      color: colorScheme.primary,
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Welcome to Galaksi, ",
                        style: textTheme.bodyMedium!,
                        children: [
                          TextSpan(
                            text:
                                "${ref.read(onboardingNotifierProvider).firstName!}!",
                            style: textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Let's go!"),
                    ),
                  ],
                ),
              ),
              SizedBox(height: constraints.maxHeight / 12),
            ],
          );
        },
      ),
    );
  }
}
