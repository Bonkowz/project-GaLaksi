import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:galaksi/models/travel_plan/travel_plan_model.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import 'package:saver_gallery/saver_gallery.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:galaksi/utils/snackbar.dart';

class TravelPlanQrCode extends StatefulWidget {
  const TravelPlanQrCode({required TravelPlan travelPlan, super.key})
    : _travelPlan = travelPlan;

  final TravelPlan _travelPlan;

  @override
  State<TravelPlanQrCode> createState() => _TravelPlanQrCodeState();
}

class _TravelPlanQrCodeState extends State<TravelPlanQrCode> {
  late QrImage qrImage;
  Uint8List? qrImageBytes;

  @override
  void initState() {
    super.initState();
    final qrCode = QrCode(8, QrErrorCorrectLevel.H)
      ..addData(widget._travelPlan.id);
    qrImage = QrImage(qrCode);
    _generateQrBytes();
  }

  Future<void> _generateQrBytes() async {
    final bytes = await qrImage.toImageAsBytes(
      size: 512,
      format: ImageByteFormat.png,
    );
    setState(() {
      qrImageBytes = bytes?.buffer.asUint8List();
    });
  }

  Future<void> _saveQrToGallery() async {
    if (qrImageBytes == null) return;
    final result = await SaverGallery.saveImage(
      qrImageBytes!,
      quality: 100,
      fileName: "travel_plan_qr_${widget._travelPlan.id}",
      skipIfExists: false,
    );
    if (mounted) {
      showDismissableSnackbar(
        context: context,
        message:
            result.isSuccess
                ? "QR code saved to gallery!"
                : "Failed to save QR code.",
      );
    }
  }

  Future<bool> checkAndRequestPermissions({required bool skipIfExists}) async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return false; // Only Android and iOS platforms are supported
    }

    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = deviceInfo.version.sdkInt;

      if (skipIfExists) {
        // Read permission is required to check if the file already exists
        return sdkInt >= 33
            ? await Permission.photos.request().isGranted
            : await Permission.storage.request().isGranted;
      } else {
        // No read permission required for Android SDK 29 and above
        return sdkInt >= 29
            ? true
            : await Permission.storage.request().isGranted;
      }
    } else if (Platform.isIOS) {
      // iOS permission for saving images to the gallery
      return skipIfExists
          ? await Permission.photos.request().isGranted
          : await Permission.photosAddOnly.request().isGranted;
    }

    return false; // Unsupported platforms
  }

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
            PrettyQrView(
              qrImage: qrImage,
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
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: qrImageBytes == null ? null : _saveQrToGallery,
              icon: const Icon(Symbols.save_alt),
              label: const Text("Save to Gallery"),
            ),
          ],
        ),
      ),
    );
  }
}
