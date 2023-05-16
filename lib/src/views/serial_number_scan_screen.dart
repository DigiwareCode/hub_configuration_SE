import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hub_config/src/provider_manager/hub_manager.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:provider/provider.dart';

import '../business_logic/models/session.dart';
import 'hub_connection_screen.dart';

class SerialNumberScanScreen extends StatefulWidget {
  static MaterialPage page() {
    return const MaterialPage(
      name: routeName,
      key: ValueKey(routeName),
      child: SerialNumberScanScreen(),
    );
  }

  static const String routeName = '/scanSerialNumber';

  const SerialNumberScanScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SerialNumberScanScreenState();
}

class _SerialNumberScanScreenState extends State<SerialNumberScanScreen> {
  final _formKey = GlobalKey<FormState>();
  QRViewController? _controller;
  int scanState = 0; // 0: not yet scan; 1: error; 2: success

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller!.pauseCamera();
    } else if (Platform.isIOS) {
      _controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan QR"),
        leading: Session.instance.hubSerialNumber.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Provider.of<HubManager>(context, listen: false)
                      .quitSerialNumberScan();
                  Navigator.pop(context);
                },
              )
            : null,
      ),
      body: QRView(
        key: _formKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderRadius: 10,
          borderWidth: 5,
          borderColor: scanState == 1 ? Colors.red : Colors.white,
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
      _controller!.resumeCamera();
    });
    _controller!.scannedDataStream.listen((barcode) {
      _verifySerialNumber(barcode.code ?? '');
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _verifySerialNumber(String serialNumber) async {
    if (scanState != 2) {
      bool isValidSerialNumber = (serialNumber != null);

      HubManager myH = Provider.of<HubManager>(context,listen: false);
      myH.inputData.hubSerialNumber = serialNumber;
      myH.inputData.clientID = serialNumber;
      myH.inputData.successTopic = '$serialNumber/success';

      if (isValidSerialNumber) {
        scanState = 2;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const HubConnectionScreen()));
      }
      dispose();
    }
  }
}
