import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../../data/models/quiz_check_model.dart';

part 'quiz_nav_state.dart';

class QuizNavCubit extends Cubit<QuizNavState> {
  QuizNavCubit() : super(QuizNavAttempt());

  void checkAnswers({required List<QuizCheck> quizChecks}) {
    emit(QuizNavCheck(quizChecks: quizChecks));
  }
}
