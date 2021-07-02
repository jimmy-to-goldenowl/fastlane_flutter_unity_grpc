import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loveblocks/models/result.dart';
import 'package:loveblocks/models/user.dart';

class FirestoreService {
  static final instance = FirestoreService._();
  factory FirestoreService() => instance;
  FirestoreService._();
  final CollectionReference usersCollectionRef = FirebaseFirestore.instance.collection('users');

  Future<Result<LUser>> getUser(String id) async {
    try {
      final DocumentSnapshot doc = await usersCollectionRef.doc(id).get();
      if (doc.exists) {
        final user = LUser.fromDocument(doc);
        return Result.success(user);
      } else {
        return Result.error('User does not exist');
      }
    } catch (e) {
      return Result.exception(e);
    }
  }

  Future<Result<LUser>> addOrUpdateUser(LUser user) async {
    try {
      await usersCollectionRef.doc(user.id).set(user.toMap(), SetOptions(merge: true));
      return Result.success(user);
    } catch (e) {
      return Result.exception(e);
    }
  }
}
