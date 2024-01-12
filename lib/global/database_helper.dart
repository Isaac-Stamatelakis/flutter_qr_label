
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

abstract class DatabaseRetriever<T> {
  final String id;
  DatabaseRetriever({required this.id});

  Future<T?> fromDatabase() async {
    try {
      DocumentSnapshot documentSnapshot = await getDatabaseReference().get();
      if (documentSnapshot.exists && documentSnapshot.data() != null) {
        return fromDocument(documentSnapshot);
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      Logger().e('Error retrieving from database: $e');
      return null;
    }
  }
  T? fromDocument(DocumentSnapshot snapshot);

  dynamic getDatabaseReference();
}

abstract class MultiDatabaseRetriever<T> {
  final List<String>? _ids;
  MultiDatabaseRetriever(this._ids);
  Future<List<T>> fromDatabase() async {
    List<T> retrieved = [];
    for (String id in _ids!) {
      retrieved.add(await getRetriever(id).fromDatabase());
    }
    return retrieved;
  }
  DatabaseRetriever getRetriever(String id);
}

abstract class DatabaseQuery<T> {
  Future<List<T>?> fromDatabase() async {
    try {
      List<T> queryResults = [];
      QuerySnapshot querySnapshot = await getQuery().get();
      for (QueryDocumentSnapshot snapshot in querySnapshot.docs) {
        queryResults.add(fromDocument(snapshot));
      }
      return queryResults;
    } on FirebaseException catch (e) {
      Logger().e('Error retrieving from database: $e');
      return null;
    }
  }
  dynamic fromDocument(DocumentSnapshot snapshot);

  dynamic getQuery();
}

abstract class CheckDatabaseQuery<T> {
  Future<List<T>?> fromDatabase() async {
    try {
      List<T> queryResults = [];
      QuerySnapshot querySnapshot = await getQuery().get();
      for (QueryDocumentSnapshot snapshot in querySnapshot.docs) {
        T result = fromDocument(snapshot);
        if (check(result)) {
          queryResults.add(result);
        }
      }
      return queryResults;
    } on FirebaseException catch (e) {
      Logger().e('Error retrieving from database: $e');
      return null;
    }
  }
  dynamic fromDocument(DocumentSnapshot snapshot);

  dynamic getQuery();
  bool check(T result);
}



abstract class LimitSearchDatabaseQuery<T> {
  final int amount;
  final String search;
  DocumentSnapshot? lastSnapshot;
  bool complete = false;
  LimitSearchDatabaseQuery({required this.amount, required this.search});
  Future<List<T>?> fromDatabase() async {
    try {
      
      List<T> queryResults = [];
      int hardLimit = 20;
      while (queryResults.length < amount) {
        Query query = getQuery().limit(5*amount);
        if (lastSnapshot != null) {
          query = getNextQuery(query);
        }
        QuerySnapshot querySnapshot = await query.get();
        if (querySnapshot.size == 0 || hardLimit < 0) {
          complete = true;
          break;
        }
        for (QueryDocumentSnapshot snapshot in querySnapshot.docs) {
          T value = fromDocument(snapshot);
          if (searchCheck(value)) {
            queryResults.add(value);
          }
          lastSnapshot = snapshot;
          if (queryResults.length == amount) {
            break;
          }
        }
        hardLimit --;
      }
      return queryResults;
    } catch (e) {
      Logger().e('Error retrieving from database: $e');
      return null;
    }
  }
  dynamic fromDocument(DocumentSnapshot snapshot);

  Query getQuery();
  Query getNextQuery(Query query);

  bool searchCheck(T value);
}

/// Represents a class which represents a database counterpart
abstract class DBClass {
  String? getID();
  void setID(String? id);
} 

/// Abstract layout for a DBClass Database Manager which can upload, update and delete the class from the database
abstract class IDBManager<T extends DBClass> {
  
  Future<void> delete(T? value) async {
    if (value == null) {
      return;
    }
    await getCollectionReference()!.doc(value.getID()).delete();
    Logger().i("Deleted ${getLogName()} ${value.getID()}");
    await additionalDeletes();
  }

  Future<void> update(T? value) async {
    if (value == null) {
      return;
    }
    dynamic map = toJson(value);
    if (map.isEmpty) {
      return;
    }
    await getCollectionReference()!.doc(value.getID()).update(map);
    await additionalUpdates();
  }

  
  Future<String?> upload(T? value) async {
    if (value == null) {
      return null;
    }
    if (value.getID() != null) {
      return null;
    }
    dynamic map = toJson(value);
    if (map.isEmpty) {
      return null;
    }
    DocumentReference reference = await getCollectionReference()!.add(map);
    Logger().i("${getLogName()} uploaded ${reference.id}");
    value.setID(reference.id);
    await additionalUploads();
    return reference.id;
  }

  Future<void> additionalUpdates() async {
    
  }
  Future<void> additionalDeletes() async {
    
  }
  Future<void> additionalUploads() async {
    
  }
  CollectionReference? getCollectionReference();
  String getLogName();
  Map<String, dynamic> toJson(T? value);

}
