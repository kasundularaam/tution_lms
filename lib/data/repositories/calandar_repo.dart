import 'dart:developer';

import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/add_mod_eve_cal_cu_model.dart';
import '../models/cal_event_modle.dart';
import 'firebase_repo/firebase_cal_repo.dart';

class CalandarRepo {
  static const scopes = [CalendarApi.calendarScope];
  static const clId =
      "1095616754506-fhcqiardnkrevq309n5ouvnakg3nrnrc.apps.googleusercontent.com";

  static Future<String?> addEventForAContent({required Event event}) async {
    try {
      var clientId = ClientId(clId, "");
      AuthClient authClient =
          await clientViaUserConsent(clientId, scopes, userPrompt);
      var calendar = CalendarApi(authClient);
      String calendarId = "primary";
      Event returningEvent = await calendar.events.insert(event, calendarId);
      if (returningEvent.status == "confirmed") {
        log('Event added in google calendar');
        return returningEvent.id;
      } else {
        log("Unable to add event in google calendar");
        return null;
      }
    } catch (e) {
      throw e;
    }
  }

  static Future<String?> addExamCountdown({required Event event}) async {
    try {
      var clientId = ClientId(clId, "");
      AuthClient authClient =
          await clientViaUserConsent(clientId, scopes, userPrompt);
      var calendar = CalendarApi(authClient);
      String calendarId = "primary";
      Event returningEvent = await calendar.events.insert(event, calendarId);
      if (returningEvent.status == "confirmed") {
        log('Event added in google calendar');
        return returningEvent.id;
      } else {
        log("Unable to add countdown in google calendar");
        return null;
      }
    } catch (e) {
      throw e;
    }
  }

  static Future<void> addModEveToCal(
      {required List<Event> events,
      required AddModEveCalCuMod addModEveCalCuMod,
      required DateTime selectedDateTime}) async {
    try {
      var clientId = ClientId(clId, "");
      AuthClient authClient =
          await clientViaUserConsent(clientId, scopes, userPrompt);
      var calendar = CalendarApi(authClient);
      String calendarId = "primary";

      int weekIntForFire = 1;
      int indexForFire = 0;

      events.forEach((singleEvent) async {
        Event addedEvent =
            await calendar.events.insert(singleEvent, calendarId);
        if (addedEvent.status == "confirmed") {
          log('Event added in google calendar');

          String titleForFire =
              "${addModEveCalCuMod.subjectName} > ${addModEveCalCuMod.moduleName} | week $weekIntForFire";
          int timeForFire = selectedDateTime
              .add(
                Duration(
                  days: (7 * indexForFire),
                ),
              )
              .millisecondsSinceEpoch;

          await FirebaseCalRepo.addEventToCal(
            calEvent: CalEvent(
              id: addedEvent.id!,
              title: titleForFire,
              time: timeForFire,
              type: "module",
              subjectId: addModEveCalCuMod.subjectId,
              subjectName: addModEveCalCuMod.subjectName,
              moduleId: addModEveCalCuMod.moduleId,
              moduleName: addModEveCalCuMod.moduleName,
              contentId: "",
              contentName: "",
            ),
          );

          weekIntForFire++;
          indexForFire++;
        } else {
          log("Unable to add event in google calendar");
        }
      });
    } catch (e) {
      throw e;
    }
  }

  static void userPrompt(String url) async {
    print("Please go to the following URL and grant access:");
    print("  => $url");
    print("");

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
