import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/my_colors.dart';
import '../../../data/models/fire_quiz.dart';
import '../../../data/models/quiz_check_model.dart';
import '../../../data/repositories/firebase_repo/firebase_quiz_repo.dart';

part 'quiz_check_state.dart';

class QuizCheckCubit extends Cubit<QuizCheckState> {
  QuizCheckCubit() : super(QuizCheckInitial());

  Future<void> checkQuizes(
      {required List<QuizCheck> quizChecks,
      required String subjectId,
      required String moduleId}) async {
    try {
      emit(QuizCheckLoading());
      List<FireQuize> fireQuizes = [];
      quizChecks.forEach((quizCheck) {
        bool isCorrect = false;
        if (quizCheck.checkedAnswer == quizCheck.correctAnswer) {
          isCorrect = true;
        }
        fireQuizes.add(
          FireQuize(
            quizId: quizCheck.id,
            subjectId: subjectId,
            moduleId: moduleId,
            isCorrect: isCorrect,
          ),
        );
      });
      await FirebaseQuizRepo.uploadQuizes(fireQuizes: fireQuizes);
      String grade = "WEEK";
      Color color = MyColors.weak;
      int correct = 0;
      int attempted = fireQuizes.length;
      int precentage = 0;

      for (var i = 0; i < fireQuizes.length; i++) {
        if (fireQuizes[i].isCorrect) {
          correct++;
        }
      }

      precentage = ((correct / attempted) * 100).round();
      if (precentage < 35) {
        grade = "It's Ok, Let's try again";
        color = MyColors.weak;
      } else if (precentage >= 35 && precentage < 65) {
        grade = "Almost There";
        color = MyColors.needToBeImprove;
      } else if (precentage >= 65 && precentage < 75) {
        grade = "Good, You're getting there";
        color = MyColors.good;
      } else {
        grade = "Great!! Keep up the good work";
        color = MyColors.grate;
      }

      emit(QuizCheckSucceed(
          quizChecks: quizChecks,
          grade: grade,
          attempted: attempted,
          correct: correct,
          precentage: precentage,
          color: color));
    } catch (e) {
      emit(QuizCheckFailed(errorMsg: e.toString()));
    }
  }
}
