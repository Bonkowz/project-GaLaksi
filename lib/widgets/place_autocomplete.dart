import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/providers/place_search/place_search_notifier.dart';
import 'package:galaksi/utils/input_decorations.dart';
import 'package:material_symbols_icons/symbols.dart';

class PlaceAutocomplete extends ConsumerStatefulWidget {
  @override
  _PlaceAutocompleteState createState() => _PlaceAutocompleteState();
}

class _PlaceAutocompleteState extends ConsumerState<PlaceAutocomplete> {
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    final placeSearchState = ref.watch(placeSearchProvider);

    return Autocomplete<Place>(
      displayStringForOption: (Place option) => option.displayName,
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<Place>.empty();
        }
        _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 300), () {
          ref.read(placeSearchProvider.notifier).search(textEditingValue.text);
        });

        return placeSearchState.maybeWhen(
          data: (places) => places,
          loading:
              () =>
                  ref.read(placeSearchProvider.notifier).lastPlaces ?? const [],
          error:
              (e, error) =>
                  ref.read(placeSearchProvider.notifier).lastPlaces ?? const [],
          orElse: () => const Iterable<Place>.empty(),
        );
      },
      onSelected: (selection) {
        print('You selected $selection');
      },

      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) =>
              TextFormField(
                controller: textEditingController,
                focusNode: focusNode,
                decoration: InputDecorations.outlineBorder(
                  context: context,
                  borderRadius: 16,
                  hintText: "Enter location",
                  prefixIcon: const Icon(Symbols.location_on),
                ),
              ),
      optionsViewBuilder:
          (context, onSelected, options) =>
              optionsViewBuilder(context, onSelected, options),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

Widget optionsViewBuilder(
  BuildContext context,
  AutocompleteOnSelected<Place> onSelected,
  Iterable<Place> options,
) {
  return Align(
    alignment: Alignment.topLeft,
    child: Material(
      elevation: 2,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 300,
              maxWidth: constraints.maxWidth - 32,
            ),
            child: ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              separatorBuilder: (context, index) => Divider(height: 1),
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options.elementAt(index);

                return InkWell(
                  onTap: () => onSelected(option),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 8,
                    ),
                    child: Row(
                      spacing: 2,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Symbols.location_on),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                option.name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                option.displayName,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    ),
  );
}
