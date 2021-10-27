import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'camera_view.dart';
import 'painters/barcode_detector_painter.dart';

class BarcodeScannerView extends StatefulWidget {
  @override
  _BarcodeScannerViewState createState() => _BarcodeScannerViewState();
}

class _BarcodeScannerViewState extends State<BarcodeScannerView> {
  BarcodeScanner barcodeScanner = GoogleMlKit.vision.barcodeScanner();
  List<String> mainCodes = [];
  bool isBusy = false;
  CustomPaint? customPaint;

  @override
  void dispose() {
    barcodeScanner.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      title: 'Barcode Scanner',
      customPaint: customPaint,
      onImage: (inputImage) {
        processImage(inputImage);
      },
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (isBusy) return;
    isBusy = true;
    final barcodes = await barcodeScanner.processImage(inputImage);
    printBarcodesCaptured(barcodes);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = BarcodeDetectorPainter(
          barcodes, inputImage.inputImageData!.size, inputImage.inputImageData!.imageRotation);
      customPaint = CustomPaint(painter: painter);
    } else {
      customPaint = null;
    }

    isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  void printBarcodesCaptured(List<Barcode> barcodes) {
    print("Codigos Capturados\n");

    for (var barcode in barcodes) {
      print("* ${barcode.value.displayValue}");
      print("- Esta seria su ubicación  ${barcode.value.boundingBox!.center.dx}");
      print("- Esta seria su ubicación  ${barcode.value.boundingBox!.center.dy}");
      print("- Esta seria su ancho  ${barcode.value.boundingBox!.width}");
      print("- Esta seria su alto  ${barcode.value.boundingBox!.height}");
      print("- Esta seria su lado largo  ${barcode.value.boundingBox!.longestSide}");
      print("- Esta seria su lado corto  ${barcode.value.boundingBox!.shortestSide}");
    }
    print(mainCodes);
  }

  void detectMainBarcodesCaptured() {}
}
