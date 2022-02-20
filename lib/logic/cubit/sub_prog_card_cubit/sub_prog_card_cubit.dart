import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../../data/models/subject_model.dart';
import '../../../data/repositories/firebase_repo/firebse_subject_repo.dart';

part 'sub_prog_card_state.dart';

class SubProgCardCubit extends Cubit<SubProgCardState> {
  SubProgCardCubit() : super(SubProgCardInitial());

  Future<void> getSubjects() async {
    try {
      emit(SubProgCardLoading());
      List<Subject> subjectList = await FirebaseSubjectRepo.getSubjects();
      emit(SubProgCardLoaded(subjectList: subjectList));
    } catch (e) {
      emit(SubProgCardFailed(errorMsg: e.toString()));
    }
  }
}
