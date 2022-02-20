import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/my_colors.dart';
import '../../../core/my_enums.dart';
import '../../../data/repositories/firebase_repo/firebase_auth_repo.dart';
import '../../../logic/cubit/auth_nav_cubit/authscreen_nav_cubit.dart';
import '../../../logic/cubit/login_cubit/login_cubit.dart';
import '../widgets/my_text_field.dart';
import '../widgets/reguler_btn.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = "";
  String _password = "";

  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0),
      physics: const BouncingScrollPhysics(),
      children: [
        SizedBox(
          height: 2.h,
        ),
        Image.asset(
          "assets/images/autht.png",
        ),
        SizedBox(
          height: 3.h,
        ),
        MyTextField(
          onChanged: (email) => _email = email,
          onSubmitted: (_) {
            _passwordFocusNode.requestFocus();
          },
          textInputAction: TextInputAction.next,
          isPassword: false,
          hintText: "Email",
          textColor: MyColors.darkElv0,
          bgColor: MyColors.primaryColor.withOpacity(0.1),
        ),
        SizedBox(
          height: 2.h,
        ),
        MyTextField(
          onChanged: (password) => _password = password,
          onSubmitted: (_) {},
          textInputAction: TextInputAction.next,
          isPassword: true,
          focusNode: _passwordFocusNode,
          hintText: "Password",
          textColor: MyColors.darkElv0,
          bgColor: MyColors.primaryColor.withOpacity(0.1),
        ),
        SizedBox(
          height: 3.h,
        ),
        BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSucceed) {
              BlocProvider.of<AuthscreenNavCubit>(context)
                  .authNavigate(authNav: AuthNav.toAuthPage);
            } else if (state is LoginFailed) {
              SnackBar snackBar = SnackBar(content: Text(state.errorMsg));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else if (state is LoginWithInvalidValue) {
              SnackBar snackBar = SnackBar(content: Text(state.errorMsg));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          builder: (context, state) {
            if (state is LoginLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: MyColors.primaryColor,
                ),
              );
            } else {
              return Center(
                child: RegulerBtn(
                  btnText: "Log In",
                  onPressed: () => BlocProvider.of<LoginCubit>(context)
                      .loginWithEmailAndPswd(
                    email: _email,
                    password: _password,
                  ),
                  bgColor: MyColors.primaryColor,
                  txtColor: MyColors.lightElv3,
                ),
              );
            }
          },
        ),
        SizedBox(
          height: 3.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don\'t you have an account yet? ",
              style: TextStyle(
                fontSize: 14.sp,
                color: MyColors.darkElv1,
              ),
            ),
            GestureDetector(
              onTap: () =>
                  BlocProvider.of<AuthscreenNavCubit>(context).authNavigate(
                authNav: AuthNav.toSignUp,
              ),
              child: Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: MyColors.primaryDarkColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 3.h,
        ),
        Center(
          child: GestureDetector(
            onTap: () => showFpwDialog(),
            child: Text(
              "Forgot Password?",
              style: TextStyle(
                fontSize: 14.sp,
                color: MyColors.darkElv1,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 3.h,
        ),
      ],
    );
  }

  Future<void> sendEmail(
      {required String rpEmail, required BuildContext dialogContext}) async {
    try {
      await FirebaseAuthRepo.resetPassword(rpEmail);
      Navigator.pop(dialogContext);
    } catch (e) {
      print(e.toString());
      SnackBar snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  showFpwDialog() {
    String resetPwEmail = "";
    showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text("Reset password"),
            contentPadding: EdgeInsets.all(5.w),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                    "Please send Your email to get password reset link.."),
                SizedBox(
                  height: 2.h,
                ),
                MyTextField(
                  onChanged: (rpEmail) => resetPwEmail = rpEmail,
                  onSubmitted: (_) {},
                  textInputAction: TextInputAction.next,
                  isPassword: false,
                  hintText: "Email...",
                  textColor: MyColors.darkElv0,
                  bgColor: MyColors.primaryColor.withOpacity(0.1),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => sendEmail(
                        rpEmail: resetPwEmail, dialogContext: dialogContext),
                    child: Text(
                      "Send",
                      style: TextStyle(
                          color: MyColors.primaryDarkColor, fontSize: 14.sp),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
