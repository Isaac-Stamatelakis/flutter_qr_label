import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_label/global/loader.dart';
import 'package:qr_label/scanner/dialog/on_scan_dialog.dart';
import 'package:qr_label/scanner/dialog/scan_pages.dart';
import 'package:qr_label/scanner/scan_query.dart';
import 'package:qr_label/user/db_user.dart';
import 'package:qr_label/user/user.dart';

class QRScannerLoader extends SizedWidgetLoader {
  final String userID;

  const QRScannerLoader({super.key, required this.userID}) : super(size: const Size(200,200));
  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    return _QRScanner(user: snapshot.data);
  }

  @override
  Future getFuture() async {
    PermissionStatus status = PermissionStatus.denied;
    while (status.isDenied) {
      status = await Permission.camera.request();
    }
    User? user = await UserRetriever(id: userID).fromDatabase();
    return user;
  }

}


class _QRScanner extends StatefulWidget {
  final User user;
  const _QRScanner({required this.user});
  @override
  State<StatefulWidget> createState() => _QRViewState();

}


class _QRViewState extends State<_QRScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel:'SCANNER');
  QRViewController? controller;

  @override 
  void initState() {
    super.initState();
  }
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
              borderColor: Colors.white,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: 300,
            ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      _handleScan(scanData);
      controller.pauseCamera();
    });
  }

  Future<void> _handleScan(Barcode result) async {
    List<IScanPage> pages = await PageQuery(user: widget.user, scan: result).retrieve();
    await _showScanDialog(pages);
    for (IScanPage page in pages) {
      if (page is MutablePage) {
        await (page as MutablePage).actionOnClose();
      }
    }
    controller!.resumeCamera();
  }

  Future<void> _showScanDialog(List<IScanPage> pages) async{
    await showDialog(
      context: context, 
      builder: (BuildContext context) {
        return OnScanDialog(pages: pages);
      }
    );
  }
  
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

}