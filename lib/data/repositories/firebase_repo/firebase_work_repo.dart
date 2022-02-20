import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/my_colors.dart';
import '../../../core/screen_arguments/end_tab_args.dart';
import '../../models/fire_content.dart';
import '../../models/fire_module_model.dart';
import '../../models/pie_data_model.dart';
import '../../models/pie_sub_pres.dart';
import '../../models/subject_model.dart';
import '../repository.dart';
import 'firebase_auth_repo.dart';
import 'firebase_content_repo.dart';
import 'firebase_module_repo.dart';
import 'firebse_subject_repo.dart';

class FirebaseWorkRepo {
  static Future<void> addWorkDetails(
      {required bool isCompleted, required EndTabArgs endTabArgs}) async {
    try {
      CollectionReference reference = FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuthRepo.currentUid())
          .collection("contents");
      reference.add({
        'contentId': endTabArgs.contentScreenArgs.contentId,
        'contentName': endTabArgs.contentScreenArgs.contentName,
        'subjectName': endTabArgs.contentScreenArgs.subjectName,
        'subjectId': endTabArgs.contentScreenArgs.subjectId,
        'moduleName': endTabArgs.contentScreenArgs.moduleName,
        'moduleId': endTabArgs.contentScreenArgs.moduleId,
        'startTimestamp': endTabArgs.startTimestamp,
        'endTimestamp': endTabArgs.endTimestamp,
        'counter': endTabArgs.counter,
        'isCompleted': isCompleted,
      });
      int contentCountOfMod = await Repository.getContentCountByModId(
          moduleId: endTabArgs.contentScreenArgs.moduleId);
      int fireContentCountOfMod =
          await FirebaseContentRepo.getCleanedContentsCountForSubMod(
              subjectId: endTabArgs.contentScreenArgs.subjectId,
              moduleId: endTabArgs.contentScreenArgs.moduleId);
      if (fireContentCountOfMod == contentCountOfMod) {
        FirebaseModuleRepo.addFireModule(
          fireModule: FireModule(
            moduleId: endTabArgs.contentScreenArgs.moduleId,
            moduleName: endTabArgs.contentScreenArgs.moduleName,
            isCompleted: true,
            subjectId: endTabArgs.contentScreenArgs.subjectId,
            subjectName: endTabArgs.contentScreenArgs.subjectName,
          ),
        );
      }
    } catch (e) {
      throw e;
    }
  }

  static Future<String> getTodayWorkedTime() async {
    try {
      int workedSeconds = 0;
      List<FireContent> todayFireContents =
          await FirebaseContentRepo.getFireContentsForToday();
      todayFireContents.forEach((fireContent) {
        workedSeconds = workedSeconds + fireContent.counter;
      });
      String hoursStr =
          ((workedSeconds / (60 * 60)) % 60).floor().toString().padLeft(2, '0');
      String minutesStr =
          ((workedSeconds / 60) % 60).floor().toString().padLeft(2, '0');
      String secondsStr =
          (workedSeconds % 60).floor().toString().padLeft(2, '0');
      String timeString = "$hoursStr" ":" "$minutesStr" ":" "$secondsStr";
      return timeString;
    } catch (e) {
      throw e;
    }
  }

  static Future<List<PieDataModel>> getPieDataList() async {
    try {
      List<PieDataModel> pieDataList = [];
      List<String> subjectNames = [];
      List<PieSubPres> pieSubPresList = [];
      List<Subject> subjects = await FirebaseSubjectRepo.getSubjects();
      subjects.forEach((subject) {
        subjectNames.add(subject.name);
      });
      List<FireContent> todayFireContents =
          await FirebaseContentRepo.getFireContentsForToday();
      subjectNames.forEach((subName) {
        int counter = 0;
        todayFireContents.forEach((fireContent) {
          if (fireContent.subjectName == subName) {
            counter = counter + fireContent.counter;
          }
        });
        pieSubPresList.add(PieSubPres(name: subName, workedTime: counter));
      });
      int total = 0;
      pieSubPresList.forEach((pieSubPres) {
        total = total + pieSubPres.workedTime;
      });
      List<Color> myColorList = [
        MyColors.green,
        MyColors.blue,
        MyColors.purple,
        MyColors.pink,
        MyColors.red,
        MyColors.orange,
        MyColors.yellow,
      ];
      int i = 0;
      pieSubPresList.forEach((pieSubPres) {
        pieDataList.add(PieDataModel(
            name: pieSubPres.name,
            percent: (pieSubPres.workedTime / total) * 100,
            color: myColorList[i]));
        i++;
      });
      return pieDataList;
    } catch (e) {
      throw e;
    }
  }
}
