import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/repositories/firebase_repo/firebase_auth_repo.dart';
import '../../../data/value validator/auth_value_validator.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> loginWithEmailAndPswd(
      {required String email, required String password}) async {
    String emailFeedback = ValueValidator.validateEmail(email: email);
    String passwordFeedback =
        ValueValidator.validatePassword(password: password);
    if (emailFeedback == ValueValidator.validEmail) {
      if (passwordFeedback == ValueValidator.validPassword) {
        try {
          emit(LoginLoading(loadingMsg: "Logging to your account..."));
          await FirebaseAuthRepo.loginWithEmailAndPswd(
              email: email, password: password);
          emit(LoginSucceed());
        } catch (e) {
          emit(LoginFailed(errorMsg: e.toString()));
        }
      } else {
        emit(LoginWithInvalidValue(errorMsg: passwordFeedback));
      }
    } else {
      emit(LoginWithInvalidValue(errorMsg: emailFeedback));
    }
  }
}
