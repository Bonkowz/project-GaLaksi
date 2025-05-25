import 'package:flutter/material.dart';
import 'package:galaksi/models/travel_plan/travel_plan_model.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class TravelPlanQrCode extends StatelessWidget {
  const TravelPlanQrCode({required TravelPlan travelPlan, super.key})
    : _travelPlan = travelPlan;

  final TravelPlan _travelPlan;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: null,
                  icon: Icon(
                    Symbols.close_rounded,
                    color: colorScheme.surfaceContainerHigh,
                  ),
                ),
                const Spacer(),
                Text(
                  "Share to friends",
                  style: textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Symbols.close_rounded,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            PrettyQrView.data(
              data: _travelPlan.id,
              errorCorrectLevel: QrErrorCorrectLevel.H,
              decoration: PrettyQrDecoration(
                quietZone: PrettyQrQuietZone.standart,
                shape: PrettyQrSmoothSymbol(
                  roundFactor: 0.5,
                  color: colorScheme.primary,
                ),
                image: PrettyQrDecorationImage(
                  fit: BoxFit.cover,
                  image:
                      Theme.of(context).brightness == Brightness.light
                          ? const AssetImage(
                            "assets/images/galaksi-logo-light-qr.png",
                          )
                          : const AssetImage(
                            "assets/images/galaksi-logo-dark-qr.png",
                          ),
                ),
              ),
            ),
            const Text("Scan the QR code!"),
          ],
        ),
      ),
    );
  }
}
