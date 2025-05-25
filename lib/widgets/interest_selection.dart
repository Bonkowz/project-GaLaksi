import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/models/user/interest_model.dart';

class InterestSelection extends ConsumerStatefulWidget {
  const InterestSelection({
    required this.selection,
    required this.onSelectionChanged,
    super.key,
  });

  final Set<Interest> selection;
  final VoidCallback onSelectionChanged;

  @override
  ConsumerState<InterestSelection> createState() => _InterestSelectionState();
}

class _InterestSelectionState extends ConsumerState<InterestSelection> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children:
          Interest.categorized.entries.map((entry) {
            final category = entry.key;
            final interests = entry.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 18, bottom: 6),
                  child: Text(
                    StringUtils.capitalize(category.title),
                    style: textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children:
                      interests.map((e) {
                        return InputChip(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          label: Text(e.title),
                          selected: widget.selection.contains(e),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                widget.selection.add(e);
                              } else {
                                widget.selection.remove(e);
                              }
                              widget.onSelectionChanged();
                            });
                          },
                        );
                      }).toList(),
                ),
              ],
            );
          }).toList(),
    );
  }
}
