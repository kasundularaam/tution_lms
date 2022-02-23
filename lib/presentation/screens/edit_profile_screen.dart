import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../core/constants/my_colors.dart';
import '../../logic/cubit/change_password_cubit/change_password_cubit.dart';
import '../../logic/cubit/change_pro_pic_cubit/change_pro_pic_cubit.dart';
import '../../logic/cubit/edit_name_cubit/edit_name_cubit.dart';
import '../../logic/cubit/profile_top_card_cubit/profile_top_card_cubit.dart';
import '../../logic/cubit/settings_cubit/setting_cubit.dart';
import '../templates/inner_scrn_tmpl.dart';
import 'widgets/change_password_card.dart';
import 'widgets/change_pro_pic_crd.dart';
import 'widgets/change_subjects_card.dart';
import 'widgets/edit_name_card.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SettingCubit>(context).loadProfileSettings();
  }

  @override
  Widget build(BuildContext context) {
    return InnerScrnTmpl(
      title: "Edit Profile",
      content: BlocBuilder<SettingCubit, SettingState>(
        builder: (context, state) {
          if (state is SettingInitial) {
            return const Center(child: Text("Initial State"));
          } else if (state is SettingLoading) {
            return const Center(
                child: CircularProgressIndicator(
              color: MyColors.primaryColor,
            ));
          } else if (state is SettingLoaded) {
            return ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              children: [
                SizedBox(
                  height: 3.h,
                ),
                BlocProvider(
                  create: (context) => ChangeProPicCubit(),
                  child: ChangeProPicCrd(uploaded: () {
                    SnackBar snackBar =
                        const SnackBar(content: Text("Image Uploaded!"));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    BlocProvider.of<ProfileTopCardCubit>(context)
                        .getUserDetails();
                  }, failed: (errorMsg) {
                    SnackBar snackBar = SnackBar(content: Text(errorMsg));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }),
                ),
                SizedBox(
                  height: 2.h,
                ),
                BlocProvider(
                  create: (context) => EditNameCubit(),
                  child: EditNameCard(
                      fireUser: state.fireUser,
                      onSucceed: (message) {
                        BlocProvider.of<ProfileTopCardCubit>(context)
                            .getUserDetails();
                        SnackBar succeedSnack =
                            SnackBar(content: Text(message));
                        ScaffoldMessenger.of(context)
                            .showSnackBar(succeedSnack);
                      },
                      onError: (error) {
                        SnackBar errorSnack = SnackBar(content: Text(error));
                        ScaffoldMessenger.of(context).showSnackBar(errorSnack);
                      }),
                ),
                SizedBox(
                  height: 2.h,
                ),
                BlocProvider(
                  create: (context) => ChangePasswordCubit(),
                  child: ChangePasswordCard(onSucceed: (message) {
                    SnackBar succeedSnack = SnackBar(content: Text(message));
                    ScaffoldMessenger.of(context).showSnackBar(succeedSnack);
                  }, onFailed: (errorMsg) {
                    SnackBar errorSnack = SnackBar(content: Text(errorMsg));
                    ScaffoldMessenger.of(context).showSnackBar(errorSnack);
                  }),
                ),
                SizedBox(
                  height: 2.h,
                ),
                ChangeSubjectsCard(
                  screenContext: context,
                  fireSubjects: state.fireSubjects,
                  subjects: state.subjects,
                ),
                SizedBox(
                  height: 3.h,
                ),
              ],
            );
          } else if (state is SettingFailed) {}
          return Container();
        },
      ),
    );
  }
}
