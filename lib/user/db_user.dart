import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_label/global/database_helper.dart';
import 'package:qr_label/user/user.dart';

class UserRetriever extends DatabaseRetriever<User> {
  UserRetriever({required super.id});

  @override
  User? fromDocument(DocumentSnapshot<Object?> snapshot) {
    return UserFactory.fromDocument(snapshot);
  }

  @override
  getDatabaseReference() {
    return FirebaseFirestore.instance.collection("Users").doc(id);
  }
}

class UserDBManager extends IDBManager<User> {
  @override
  CollectionReference<Object?> getCollectionReference() {
    return FirebaseFirestore.instance.collection("Users");
  }

  @override
  String getLogName() {
    return "User";
  }

  @override
  Map<String, dynamic> toJson(User? value) {
    if (value == null) {
      return {};
    }
    return {
      'first_name' : value.firstName,
      'last_name' : value.lastName,
      'friend_request' : value.friendRequestIDs,
      'friends' : value.friendIDs,
      'friend_code_id' : value.friendCodeID
    };
  }

}