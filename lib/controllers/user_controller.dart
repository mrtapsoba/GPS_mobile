import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserController {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("utilisateurs");

  Future<void> setNewUser() async {
    return await userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'creation': DateTime.now(),
    });
  }

  Stream<List<QueryDocumentSnapshot>> userById(String userId) {
    return userCollection
        .where("userId", isEqualTo: userId)
        .snapshots()
        .map((event) {
      return event.docs.map((e) => e).toList();
    });
  }
}
