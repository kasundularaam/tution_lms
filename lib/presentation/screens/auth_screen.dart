import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/my_colors.dart';
import '../../core/my_enums.dart';
import '../../logic/cubit/auth_cubit/auth_cubit.dart';
import '../../logic/cubit/auth_nav_cubit/authscreen_nav_cubit.dart';
import '../../logic/cubit/login_cubit/login_cubit.dart';
import '../../logic/cubit/select_sub_list_cubit/select_sub_list_cubit.dart';
import '../../logic/cubit/select_subject_cubit/select_subject_cubit.dart';
import '../../logic/cubit/signup_cubit/signup_cubit.dart';
import 'auth_pages/auth_page.dart';
import 'auth_pages/login_page.dart';
import 'auth_pages/select_subject_page.dart';
import 'auth_pages/signup_page.dart';
import 'widgets/error_msg_box.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthscreenNavCubit>(context).emit(AuthscreenNavInitial());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.lightElv3,
      body: SafeArea(
        child: BlocBuilder<AuthscreenNavCubit, AuthscreenNavState>(
          builder: (context, state) {
            if (state is AuthscreenNavInitial) {
              return BlocProvider(
                create: (context) => AuthCubit(),
                child: const AuthPage(),
              );
            } else if (state is AuthscreenNavigate) {
              if (state.authNav == AuthNav.toLogin) {
                return BlocProvider(
                  create: (context) => LoginCubit(),
                  child: const LoginPage(),
                );
              } else if (state.authNav == AuthNav.toSignUp) {
                return BlocProvider(
                  create: (context) => SignupCubit(),
                  child: const SignUpPage(),
                );
              } else if (state.authNav == AuthNav.toAuthPage) {
                return BlocProvider(
                  create: (context) => AuthCubit(),
                  child: const AuthPage(),
                );
              } else if (state.authNav == AuthNav.toSelectSubjectPage) {
                return MultiBlocProvider(
                  providers: [
                    BlocProvider<SelectSubListCubit>(
                      create: (context) => SelectSubListCubit(),
                    ),
                    BlocProvider<SelectSubjectCubit>(
                      create: (context) => SelectSubjectCubit(),
                    )
                  ],
                  child: const SelectSubjectPage(),
                );
              } else {
                return const Center(
                    child: ErrorMsgBox(errorMsg: "sorry no page available!"));
              }
            } else {
              return const Center(
                  child: ErrorMsgBox(errorMsg: "unhandled state excecuted!"));
            }
          },
        ),
      ),
    );
  }
}
