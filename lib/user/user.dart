import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_label/global/database_helper.dart';

class User implements DBClass{
  User({required this.dbID, required this.firstName, required this.lastName, required this.friendCodeID, required this.friendIDs, required this.friendRequestIDs});

  late String? dbID;
  late String? firstName;
  late String? lastName;
  /// Note this is friend requests that the user has sent out, not ones which have been sent by them
  late List<String?> friendRequestIDs;
  late List<String?> friendIDs;
  late String? friendCodeID;
  
  @override
  String? getID() {
    return dbID;
  }
  
  @override
  void setID(String? id) {
    dbID = id;
  }

  String getFullName() {
    return "$firstName $lastName";
  }

}

class UserFactory {
  static User? fromDocument(DocumentSnapshot snapshot) {
    if (!snapshot.exists) {
      return null;
    }
    return User(
      dbID: snapshot.id,
      firstName: snapshot['first_name'], 
      lastName: snapshot['last_name'], 
      friendCodeID: snapshot['friend_code_id'], 
      friendIDs: (snapshot['friends'] as List).map((item) => item as String).toList(),
      friendRequestIDs: (snapshot['friend_requests'] as List).map((item) => item as String).toList()
    );
  }
}



