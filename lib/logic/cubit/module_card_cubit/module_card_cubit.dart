import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/my_colors.dart';
import '../../../data/models/fire_quiz.dart';
import '../../../data/repositories/firebase_repo/firebase_quiz_repo.dart';
import '../../../data/repositories/repository.dart';

part 'module_card_state.dart';

class ModuleCardCubit extends Cubit<ModuleCardState> {
  ModuleCardCubit() : super(ModuleCardInitial());

  Future<void> loadModuleCardDetails(
      {required String subjectId, required String moduleId}) async {
    try {
      emit(ModuleCardLoading());
      int contentCount =
          await Repository.getContentCountByModId(moduleId: moduleId);
      int quizCount = await Repository.getQuizCountByModId(moduleId: moduleId);

      List<FireQuize> fireQuizes = await FirebaseQuizRepo.getFireQuizByMod(
          subjectId: subjectId, moduleId: moduleId);

      int done = fireQuizes.length;
      int correct = 0;
      int precentage = 0;
      Color color = MyColors.lightElv3;

      if (done > 0) {
        for (var i = 0; i < done; i++) {
          if (fireQuizes[i].isCorrect) {
            correct++;
          }
        }

        precentage = ((correct / done) * 100).round();
        if (precentage < 35) {
          color = MyColors.weak;
        } else if (precentage >= 35 && precentage < 65) {
          color = MyColors.needToBeImprove;
        } else if (precentage >= 65 && precentage < 75) {
          color = MyColors.good;
        } else {
          color = MyColors.grate;
        }
      }

      emit(ModuleCardLoaded(
          contentCount: contentCount, quizCount: quizCount, color: color));
    } catch (e) {
      emit(ModuleCardFailed(errorMsg: e.toString()));
    }
  }
}
