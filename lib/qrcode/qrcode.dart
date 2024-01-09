import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_label/global/database_helper.dart';

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
  DataQRCode({required super.dbID, required super.ownerID, required super.hash, required this.data, required this.public});

  late Map<String, dynamic> data;
  late bool public;
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
      return DataQRCode(
        dbID: snapshot.id, 
        ownerID: snapshot['owner_id'], 
        hash: snapshot['hash'], 
        data: snapshot['data'], 
        public: snapshot['public']
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
}
