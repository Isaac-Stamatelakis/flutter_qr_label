import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_label/global/database_helper.dart';
import 'package:qr_label/qrcode/qrcode.dart';

/// Retrieves DataQRCodes from database
class DataQRCodeRetriever extends DatabaseRetriever<DataQRCode> {
  DataQRCodeRetriever({required super.id});

  @override
  DataQRCode? fromDocument(DocumentSnapshot<Object?> snapshot) {
    return QRCodeFactory.fromDocument<DataQRCode>(snapshot) as DataQRCode;
  }

  @override
  getDatabaseReference() {
    return FirebaseFirestore.instance.collection("Codes").doc(id);
  }
}

/// Retrieves FriendQRCodes from database
class FriendQRCodeRetriever extends DatabaseRetriever<FriendQRCode> {
  FriendQRCodeRetriever({required super.id});

  @override
  FriendQRCode? fromDocument(DocumentSnapshot<Object?> snapshot) {
    return QRCodeFactory.fromDocument<FriendQRCode>(snapshot) as FriendQRCode;
  }

  @override
  getDatabaseReference() {
    return FirebaseFirestore.instance.collection("Codes").doc(id);
  }
}

class QRCodeHashQuery {
  final String hash;
  QRCodeHashQuery({required this.hash});

  Future<List<QRCode?>> retrieve() async {
    List<QRCode?> codes = [];
    List<DataQRCode?>? dataCodes = await DataQRCodeHashQuery(hash: hash).fromDatabase();
    if (dataCodes != null) {
      codes.addAll(dataCodes);
    }
    List<FriendQRCode?>? friendCodes = await FriendQRCodeHashQuery(hash: hash).fromDatabase();
    if (friendCodes != null) {
      codes.addAll(friendCodes);
    }
    return codes;
  }
}

class DataQRCodeHashQuery extends DatabaseQuery<DataQRCode> {
  final String hash;
  DataQRCodeHashQuery({required this.hash});

  @override
  DataQRCode? fromDocument(DocumentSnapshot<Object?> snapshot) {
    return QRCodeFactory.fromDocument<DataQRCode>(snapshot) as DataQRCode;
  }

  @override
  getQuery() {
    return FirebaseFirestore.instance.collection("Codes").where("hash",isEqualTo: hash);
  }
}

class FriendQRCodeHashQuery extends DatabaseQuery<FriendQRCode> {
  final String hash;
  FriendQRCodeHashQuery({required this.hash});

  @override
  FriendQRCode? fromDocument(DocumentSnapshot<Object?> snapshot) {
    //return QRCodeFactory.friendFromDocument(snapshot);
    return QRCodeFactory.fromDocument<FriendQRCode>(snapshot) as FriendQRCode?;
  }

  @override
  getQuery() {
    return FirebaseFirestore.instance.collection("FriendCodes").where("hash",isEqualTo: hash);
  }
}

