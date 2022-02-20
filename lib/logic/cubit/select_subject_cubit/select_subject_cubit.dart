import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../../data/models/subject_model.dart';
import '../../../data/repositories/firebase_repo/firebse_subject_repo.dart';
import '../../../data/value validator/auth_value_validator.dart';

part 'select_subject_state.dart';

class SelectSubjectCubit extends Cubit<SelectSubjectState> {
  SelectSubjectCubit() : super(SelectSubjectInitial());

  Future<void> updateSubjectList({required List<Subject> subjectList}) async {
    try {
      emit(
        SelectedSubjectLoading(
            loadingMsg: "adding selected subjects to the database..."),
      );
      await FirebaseSubjectRepo.addSubjects(
        subjectList:
            ValueValidator.validateSubjectList(subjectList: subjectList),
      );
      emit(
        SelectedSubjectSucceed(),
      );
    } catch (e) {
      emit(
        SelectedSubjectFailed(
          errorMsg: e.toString(),
        ),
      );
    }
  }
}
