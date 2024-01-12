import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/async.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:logger/logger.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_label/global/global_helper.dart';
import 'package:qr_label/global/loader.dart';
import 'package:qr_label/qrcode/db_qrcode.dart';
import 'package:qr_label/qrcode/qrcode.dart';
import 'package:qr_label/scanner/dialog/on_scan_dialog.dart';
import 'package:qr_label/scanner/dialog/scan_pages.dart';
import 'package:qr_label/user/user.dart';


/// Retrieves pages from database in proper format
class PageQuery {
  final User user;
  final Barcode? scan;
  PageQuery({required this.user, required this.scan});
  
  Future<List<IScanPage>> retrieve() async {
    String hash = GlobalHelper.calculateSHA256(scan!.code!);
    List<FriendQRCode>? friendCodeQueryResults = await FriendQRCodeHashQuery(hash: hash).fromDatabase();
    if (friendCodeQueryResults!.isNotEmpty) { // QR Code scanned is someones friend code
      FriendQRCode friendQRCode = friendCodeQueryResults[0]; // There should only ever be one
      if (friendQRCode.ownerID != null && friendQRCode.ownerID == user.dbID) {
        Logger().i("Scan case own friend code with hash : ${GlobalHelper.calculateSHA256(scan!.code!)}");
        return [OwnFriendCodeQRPage(code: friendQRCode)];
          
      } else {
        if (user.friendIDs.contains(friendQRCode.ownerID)) {
          Logger().i("Scan case already friends code with hash : ${GlobalHelper.calculateSHA256(scan!.code!)}");
          return [AlreadyFriendsScanPage(code: friendQRCode)];
        } else {
          Logger().i("Scan case friend code with hash : ${GlobalHelper.calculateSHA256(scan!.code!)}");
          return [FriendScanPage(code: friendQRCode, user: user)];
        }
        
      }
    }

    List<DataQRCode>? dataCodeQueryResults = await DataQRCodeHashQuery(hash: hash).fromDatabase();
    List<DataQRCode> returnCodes = [];
    bool userHas = false;
    for (DataQRCode dataQRCode in dataCodeQueryResults!) {
      if (dataQRCode.ownerID == user.dbID) {
        userHas = true; 
        returnCodes.add(dataQRCode);
        dataCodeQueryResults.remove(dataQRCode);
        break;
      }
    }
    for (DataQRCode dataQRCode in dataCodeQueryResults) {
      if (dataQRCode.public) {
        returnCodes.add(dataQRCode);
      }
    }
    List<IScanPage> pages = [];
    if (userHas) {
      pages.add(OwnedScanPage(code: returnCodes.removeAt(0)));
      Logger().i("Scan edit page with hash : ${GlobalHelper.calculateSHA256(scan!.code!)}");
    } else {
      pages.add(NewQRCodePage(code: DataQRCode(
        dbID: null, 
        ownerID: user.dbID, 
        hash: hash, 
        data: [], 
        public: true, 
        lastAccessed: DateTime.now(), 
        publicEditable: false
      )));
      Logger().i("Scan new page code with hash : ${GlobalHelper.calculateSHA256(scan!.code!)}");
    }
    for (DataQRCode dataQRCode in returnCodes) {
      if (dataQRCode.publicEditable) {
        pages.add(FriendEditQRPage(code: dataQRCode));
      } else {
        pages.add(FriendViewQRPage(code: dataQRCode));
      }
    }
    return pages;
    
  }
}