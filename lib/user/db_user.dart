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
      'friend_requests' : value.friendRequestIDs,
      'friends' : value.friendIDs,
      'friend_code_id' : value.friendCodeID
    };
  }
}

class UserUIDQuery extends DatabaseQuery<User> {
  final String uid;

  UserUIDQuery({required this.uid});
  @override
  fromDocument(DocumentSnapshot<Object?> snapshot) {
    return UserFactory.fromDocument(snapshot);
  }

  @override
  getQuery() {
    return FirebaseFirestore.instance.collection("Users").where("uid",isEqualTo: uid);
  }

}
class UserFriendSearchQuery extends LimitSearchDatabaseQuery<User> {
  final User user;
  UserFriendSearchQuery({required this.user, required super.amount, required super.search});

  @override
  fromDocument(DocumentSnapshot<Object?> snapshot) {
    return UserFactory.fromDocument(snapshot);
  }

  @override
  Query<Object?> getQuery() {
    return FirebaseFirestore.instance.collection("Users").where("friends",arrayContains: user.dbID).orderBy("first_name");
  }

  @override
  bool searchCheck(User value) {
    return value.getFullName().toLowerCase().contains(search.toLowerCase()) && user.friendIDs.contains(value.dbID!);
  }
  
  @override
  Query<Object?> getNextQuery(Query<Object?> query) {
     return query.startAfter([(lastSnapshot!.data() as Map<String,dynamic>)['first_name']]);
  }
}
