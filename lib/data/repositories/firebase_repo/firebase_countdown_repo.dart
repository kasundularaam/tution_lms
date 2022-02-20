import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/countdown_model.dart';
import 'firebase_auth_repo.dart';

class FirebaseCountdownRepo {
  static final CollectionReference _reference = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuthRepo.currentUid())
      .collection("countdown");

  static Future<void> setCountdown({required Countdown countdown}) async {
    try {
      if (countdown.examTimeStamp > DateTime.now().millisecondsSinceEpoch) {
        _reference.doc(countdown.countdownId).set(countdown.toMap());
      } else {
        throw "date has already passed";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<List<Countdown>> getCountdowns() async {
    try {
      List<Countdown> countdowns = [];
      QuerySnapshot snapshot = await _reference.get();
      snapshot.docs.map((docs) {
        Map<String, dynamic> countdown = docs.data() as Map<String, dynamic>;
        countdowns.add(Countdown.fromMap(countdown));
      }).toList();
      return countdowns;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<void> deleteCountdown({required String countdownId}) async {
    try {
      _reference.doc(countdownId).delete();
    } catch (e) {
      throw e.toString();
    }
  }
}
