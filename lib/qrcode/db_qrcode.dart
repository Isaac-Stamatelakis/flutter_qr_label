import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_label/global/database_helper.dart';
import 'package:qr_label/qrcode/qrcode.dart';
import 'package:qr_label/scanner/dialog/keyvalue.dart';

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

class UserQRCodeQueryLimitSearch extends LimitSearchDatabaseQuery<DataQRCode> {
  final String userID;
  UserQRCodeQueryLimitSearch({required super.amount, required super.search, required this.userID});
  @override
  fromDocument(DocumentSnapshot<Object?> snapshot) {
    return QRCodeFactory.fromDocument<DataQRCode>(snapshot);
  }

  @override
  Query<Object?> getQuery() {
    return FirebaseFirestore.instance.collection("Codes")
      .where("owner_id",isEqualTo: userID)
      .orderBy('last_accessed',descending: true)
      ;
  }

  @override
  bool searchCheck(DataQRCode value) {
    if (value.data.isEmpty && search == "") {
      return true;
    }
    for (KeyValuePair keyValuePair in value.data) {
      if (keyValuePair.key!.contains(search)) {
        return true;
      }
    }
    return false;
  }
  
  @override
  Query<Object?> getNextQuery(Query query) {
    return query.startAfter([(lastSnapshot!.data() as Map<String,dynamic>)['last_accessed']]);
  }
}

class FriendQRCodeQueryLimitSearch extends LimitSearchDatabaseQuery<DataQRCode> {
  final String userID;
  FriendQRCodeQueryLimitSearch({required super.amount, required super.search, required this.userID});
  @override
  fromDocument(DocumentSnapshot<Object?> snapshot) {
    return QRCodeFactory.fromDocument<DataQRCode>(snapshot);
  }

  @override
  Query<Object?> getQuery() {
    return FirebaseFirestore.instance.collection("Codes")
      .where("owner_id",isEqualTo: userID)
      .orderBy('last_accessed',descending: true)
      ;
  }

  @override
  bool searchCheck(DataQRCode value) {
    if (!value.public) {
      return false;
    }
    if (value.data.isEmpty && search == "") {
      return true;
    }
    for (KeyValuePair keyValuePair in value.data) {
      if (keyValuePair.key!.contains(search)) {
        return true;
      }
    }
    return false;
  }
  
  @override
  Query<Object?> getNextQuery(Query query) {
    return query.startAfter([(lastSnapshot!.data() as Map<String,dynamic>)['last_accessed']]);
  }
}


class QRCodeDBManager<T extends QRCode> extends IDBManager<T> {
  @override
  CollectionReference<Object?>? getCollectionReference() {
    if (T == DataQRCode) {
      return FirebaseFirestore.instance.collection("Codes");
    } else if (T == FriendQRCode) {
      return FirebaseFirestore.instance.collection("FriendCodes");
    }
    return null;
  }

  @override
  String getLogName() {
    if (T == DataQRCode) {
      return "DataQRCode";
    } else if (T == FriendQRCode) {
      return "FriendQRCode";
    }
    return "";
  }

  @override
  Map<String, dynamic> toJson(T? value) {
    if (T == DataQRCode) {
      DataQRCode dataQRCode = value as DataQRCode;
      return {
        'data' : KeyValuePairFactory.toJson(value.data),
        'hash' : dataQRCode.hash,
        'owner_id' : dataQRCode.ownerID,
        'public' : dataQRCode.public,
        'public_editable' : dataQRCode.publicEditable,
        'last_accessed' : dataQRCode.lastAccessed
      };
    } else if (T == FriendQRCode) {
      FriendQRCode friendQRCode = value as FriendQRCode;
      return {
        'hash' : friendQRCode.hash,
        'owner_id' : friendQRCode.ownerID,
      };
    }
    return {};

  }

}

