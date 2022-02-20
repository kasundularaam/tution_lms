import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../../data/models/countdown_model.dart';
import '../../../data/repositories/firebase_repo/firebase_countdown_repo.dart';

part 'countdown_tab_state.dart';

class CountdownTabCubit extends Cubit<CountdownTabState> {
  CountdownTabCubit() : super(CountdownTabInitial());

  Future<void> loadCountdowns() async {
    try {
      emit(CountdownTabLoading());
      List<Countdown> countdowns = await FirebaseCountdownRepo.getCountdowns();
      if (countdowns.isNotEmpty) {
        emit(CountdownTabLoaded(countdowns: countdowns));
      } else {
        emit(CountdownTabNoResults());
      }
    } catch (e) {
      emit(CountdownTabFailed(errorMsg: e.toString()));
    }
  }

  Future<void> deleteCountdown(
      {required String countdownId, required int index}) async {
    try {
      emit(CountdownTabLoading());
      await FirebaseCountdownRepo.deleteCountdown(countdownId: countdownId);
      loadCountdowns();
    } catch (e) {
      emit(CountdownTabFailed(errorMsg: e.toString()));
      loadCountdowns();
    }
  }
}
