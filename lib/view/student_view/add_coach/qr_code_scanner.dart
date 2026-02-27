import 'dart:io';

import 'package:coach_student/models/CoachProfileDetailsModel.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_new/qr_code_scanner.dart';

import '../../../services/api/api.dart';
import '../coach_profile_screen/coach_profile_screen.dart';

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({super.key});

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  final List<String> scannedCodes = [];

  Future<void> getCoach(BuildContext context, String code) async {
    List<String> strList = [];
    if (code.contains("*")) {
      strList = code.split("*");
    }

    String finalUrl =
        strList.isEmpty ? "/coach?passcode=$code" : "/coach?passcode=${strList.first}";
    final result = await DioApi.get(path: finalUrl);

    if (result.response?.data != null) {
      debugPrint('coach passcode ${result.response?.data}');

      CoachProfileDetailsModel coachProfile =
          CoachProfileDetailsModel.fromJson(result.response?.data["coaches"][0]);
      if (strList.isNotEmpty) {
        coachProfile.referralCode = strList.last;
      }

      Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (context) => CoachProfileScreen(coachProfileDetailsModel: coachProfile),
          ))
          .then((_) => scannedCodes.clear());
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scannedCodes.isEmpty) {
        final code = scanData.code ?? '';
        if (code.isNotEmpty && !scannedCodes.contains(code)) {
          scannedCodes.add(code);
          debugPrint('Barcode found! $code');
          getCoach(context, code);
        }
      }
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
        actions: [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.flash_on),
            onPressed: () => controller?.toggleFlash(),
          ),
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.cameraswitch),
            onPressed: () => controller?.flipCamera(),
          ),
        ],
      ),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }
}
