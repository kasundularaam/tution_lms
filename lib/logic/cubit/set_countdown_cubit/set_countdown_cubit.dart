import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart';

import '../../../data/models/countdown_model.dart';
import '../../../data/repositories/calandar_repo.dart';
import '../../../data/repositories/firebase_repo/firebase_countdown_repo.dart';

part 'set_countdown_state.dart';

class SetCountdownCubit extends Cubit<SetCountdownState> {
  SetCountdownCubit() : super(SetCountdownInitial());

  Future<void> setCountdown({
    String? countdownIdEdit,
    required DateTime? exmDate,
    required TimeOfDay? exmTime,
    required String examTitle,
  }) async {
    try {
      emit(SetCountdownLoading());

      DateTime startTime = DateTime(
        exmDate!.year,
        exmDate.month,
        exmDate.day,
        exmTime!.hour,
        exmTime.minute,
      );
      DateTime endTime = startTime.add(const Duration(hours: 2));
      Event event = Event();
      EventDateTime start = EventDateTime();
      start.dateTime = startTime;
      start.timeZone = "GMT+5:30";
      event.start = start;

      EventDateTime end = EventDateTime();
      end.timeZone = "GMT+5:30";
      end.dateTime = endTime;
      event.end = end;

      String eventTitle = "$examTitle";
      event.summary = eventTitle;

      EventReminders reminders = EventReminders(overrides: [
        EventReminder(method: "popup", minutes: 0),
        EventReminder(method: "popup", minutes: 1440),
        EventReminder(method: "popup", minutes: 40320),
      ], useDefault: false);
      event.reminders = reminders;
      await CalandarRepo.addEventForAContent(event: event);

      if (exmDate != null && exmTime != null && examTitle.isNotEmpty) {
        String countdownId =
            countdownIdEdit ?? DateTime.now().millisecondsSinceEpoch.toString();
        int examTimeStamp = DateTime(exmDate.year, exmDate.month, exmDate.day,
                exmTime.hour, exmTime.minute)
            .millisecondsSinceEpoch;
        await FirebaseCountdownRepo.setCountdown(
          countdown: Countdown(
            countdownId: countdownId,
            examTitle: examTitle,
            examTimeStamp: examTimeStamp,
          ),
        );
        emit(SetCountdownSucceed());
      } else {
        emit(SetCountdownFaild(errorMsg: "Some fields are empty!"));
      }
    } catch (e) {
      print(e.toString());
      emit(SetCountdownFaild(errorMsg: e.toString()));
    }
  }
}
