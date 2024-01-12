import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_label/global/database_helper.dart';
import 'package:qr_label/scanner/dialog/keyvalue.dart';

/// Represents a QRCode
abstract class QRCode implements DBClass{
  QRCode({required this.dbID, required this.ownerID, required this.hash});

  late String? dbID;
  late String? ownerID;
  late String? hash;
  
  @override
  String? getID() {
    return dbID;
  }
  @override
  void setID(String? id) {
    dbID=id;
  }
}

/// Represents a QRCode that when scanned displays data
class DataQRCode extends QRCode {
  DataQRCode({required super.dbID, required super.ownerID, required super.hash, required this.data, required this.public, required this.lastAccessed, required this.publicEditable});

  // Makes things a lot easier to encode data as a list of key value pairs rather than just pure json.
  late List<KeyValuePair> data;
  late bool public;
  late bool publicEditable;
  late DateTime lastAccessed;
}

/// Represents a QRCode that when scanned sends a friend request to its owner
class FriendQRCode extends QRCode {
  FriendQRCode({required super.dbID, required super.ownerID, required super.hash});

}

class QRCodeFactory {
  /// Constructs QRCode of given type from snapshot
  static QRCode? fromDocument<T extends QRCode>(DocumentSnapshot snapshot) {
    if (!snapshot.exists) {
      return null;
    }
    if (T == DataQRCode) {
      Timestamp timestamp = snapshot['last_accessed'];
      return DataQRCode(
        dbID: snapshot.id, 
        ownerID: snapshot['owner_id'], 
        hash: snapshot['hash'], 
        data: KeyValuePairFactory.fromJson(snapshot['data']), 
        public: snapshot['public'], 
        lastAccessed: timestamp.toDate(), 
        publicEditable: snapshot['public_editable']
      );
    } else if (T == FriendQRCode) {
      return FriendQRCode(
        dbID: snapshot.id, 
        ownerID: snapshot['owner_id'], 
        hash: snapshot['hash']
      );
    } else {
      return null;
    }
  }
  static List<Color> hashToColor(String hash) {
    List<Color> colors = [];
    for (int i = 0; i < 3; i++) {
      int hashValue = int.parse(hash.substring(6*i,6*(i+1)), radix: 16);
      double opacity = 1.0; 
      int red = (hashValue >> 16) & 0xFF;
      int green = (hashValue >> 8) & 0xFF;
      int blue = hashValue & 0xFF;
      Color color = Color.fromRGBO(red,green,blue,1);
      if (color.computeLuminance() < 0.1) {
        double scaleFactor = 1.5;
        red = (red * scaleFactor).clamp(0, 255).toInt();
        green = (green * scaleFactor).clamp(0, 255).toInt();
        blue = (blue * scaleFactor).clamp(0, 255).toInt();
        color = Color.fromRGBO(red, green, blue, opacity);
      }
      colors.add(color);
    }    
    return colors;
  }
}

