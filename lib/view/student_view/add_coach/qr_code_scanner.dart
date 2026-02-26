import 'package:coach_student/models/CoachProfileDetailsModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../services/api/api.dart';
import '../coach_profile_screen/coach_profile_screen.dart';

class QrCodeScanner  extends StatefulWidget {
   const QrCodeScanner ({super.key});

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  MobileScannerController cameraController = MobileScannerController();

  List<Barcode> barcodeList = [];

  Future<void> getCoach(BuildContext context,String code) async {

    List<String> strList = [] ;
    if(code.contains("*")) {
      strList = code.split("*");
    }

    String finalUrl = strList.isEmpty ? "/coach?passcode=$code" : "/coach?passcode=${strList.first}" ;
    final result = await DioApi.get(path: finalUrl);

    if (result.response?.data != null) {

      print("coach passcode ${result.response?.data}");
      
      CoachProfileDetailsModel coachProfile = CoachProfileDetailsModel.fromJson(result.response?.data["coaches"][0]);
      // Utils.toast(message: '${result.response?.data["message"]}');
      if(strList.isNotEmpty){
        coachProfile.referralCode = strList.last;
      }

      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return  CoachProfileScreen(coachProfileDetailsModel: coachProfile,);
      })).then((value) => {
        barcodeList = []
      });
    } else {
      // Utils.toast(message: '${result.response?.data["message"]}');
      // result.handleError(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Scanner'),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder<MobileScannerState>(
              valueListenable: cameraController,
              builder: (context, state, child) {
                final torchState = state.torchState;
                switch (torchState) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                  case TorchState.unavailable:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.auto:
                    return const Icon(Icons.flash_auto, color: Colors.grey);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder<MobileScannerState>(
              valueListenable: cameraController,
              builder: (context, state, child) {
                final facing = state.cameraDirection;
                switch (facing) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        // fit: BoxFit.contain,
        controller: cameraController,
        onDetect: (capture) {
          final Barcode barcodes = capture.barcodes.last;
          if(barcodeList.isEmpty){
            barcodeList.add(barcodes);
            debugPrint(' Barcode found! ${barcodes.rawValue}');
            getCoach(context, barcodes.rawValue ?? "");
          }
        },
      ),
    );
  }
}
