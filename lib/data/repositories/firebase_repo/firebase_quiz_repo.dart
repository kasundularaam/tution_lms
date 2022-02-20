import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/fire_quiz.dart';
import 'firebase_auth_repo.dart';

class FirebaseQuizRepo {
  static CollectionReference reference = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuthRepo.currentUid())
      .collection("quizes");

  static Future<void> uploadQuizes(
      {required List<FireQuize> fireQuizes}) async {
    try {
      fireQuizes.forEach((fireQuize) async {
        await reference.add(fireQuize.toMap());
      });
    } catch (e) {
      throw e;
    }
  }

  static Future<List<FireQuize>> getFireQuizes() async {
    try {
      List<FireQuize> fireQuizes = [];
      QuerySnapshot snapshot = await reference.get();
      snapshot.docs.map((doc) {
        Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
        fireQuizes.add(FireQuize.fromMap(map));
      }).toList();
      return fireQuizes;
    } catch (e) {
      throw e;
    }
  }

  static Future<List<FireQuize>> getFireQuizesBySub(
      {required String subjectId}) async {
    try {
      List<FireQuize> fireQuizes = [];
      QuerySnapshot snapshot =
          await reference.where("subjectId", isEqualTo: subjectId).get();
      snapshot.docs.map((doc) {
        Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
        fireQuizes.add(FireQuize.fromMap(map));
      }).toList();
      return fireQuizes;
    } catch (e) {
      throw e;
    }
  }

  static Future<List<FireQuize>> getFireQuizByMod(
      {required String subjectId, required String moduleId}) async {
    try {
      List<FireQuize> fireQuizesByMod = [];
      List<FireQuize> fireQuizesBySub =
          await getFireQuizesBySub(subjectId: subjectId);
      fireQuizesBySub.forEach((fireQuize) {
        if (fireQuize.moduleId == moduleId) {
          fireQuizesByMod.add(fireQuize);
        }
      });
      return fireQuizesByMod;
    } catch (e) {
      throw e;
    }
  }

  static Future<void> resetProgress(
      {required String subjectId, required String moduleId}) async {
    try {
      QuerySnapshot snapshot = await reference
          .where("subjectId", isEqualTo: subjectId)
          .where("moduleId", isEqualTo: moduleId)
          .get();
      for (DocumentSnapshot ds in snapshot.docs) {
        await ds.reference.delete();
      }
    } catch (e) {
      throw e;
    }
  }
}
