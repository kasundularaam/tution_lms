import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../../data/models/subject_model.dart';
import '../../../data/repositories/firebase_repo/firebse_subject_repo.dart';

part 'home_tab_state.dart';

class HomeTabCubit extends Cubit<HomeTabState> {
  HomeTabCubit() : super(HomeTabInitial());

  Future<void> loadSubjects() async {
    try {
      emit(HomeTabLoading());
      List<Subject> subjectList = await FirebaseSubjectRepo.getSubjects();
      emit(HomeTabLoaded(subjectList: subjectList));
    } catch (e) {
      emit(HomeTabFailed(errorMsg: e.toString()));
    }
  }
}
