import 'package:flutter/material.dart';
import 'package:qr_label/global/global_widgets.dart';
import 'package:qr_label/qrcode/qrcode.dart';

abstract class IScanPage<T extends QRCode> extends StatelessWidget{
  final T? code;
  const IScanPage({super.key, required this.code});

}

abstract class MutablePage {
  Future<void> updateOnClose();
}
class EditScanPage<DataQRCode> extends IScanPage implements MutablePage{
  EditScanPage({required super.code});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
  
  @override
  Future<void> updateOnClose() async {
    
  }

}

class FriendScanPage<FriendQRCode> extends IScanPage implements MutablePage {
  FriendScanPage({required super.code});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
  
  @override
  Future<void> updateOnClose() async {
    
  }

}

/// 
class NewQRCodePage<DataQRCode> extends IScanPage implements MutablePage{
  NewQRCodePage({required super.code});

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              "HI",
              style: TextStyle(color: Colors.white),
            ),
            SquareGradientButton(
              onPress: (BuildContext context) {

              },
              text: "Upload", 
              colors: [Colors.green,Colors.green.shade300], 
              height: 50
            )
          ],
        ),
      ),
    );
  }
  
  @override
  Future<void> updateOnClose() async {
    
  }
}

/// Viewable but immutable to viewer
class FriendQRPage<DataQRCode> extends IScanPage {
  FriendQRPage({required super.code});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class OwnFriendCodeQRPage<FriendQRCode> extends IScanPage {
  OwnFriendCodeQRPage({required super.code});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "You cannot be your own friend :(",
        style: TextStyle(
          color: Colors.white
        ),
      ),
    );
  }

}
