import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/my_colors.dart';
import '../../../logic/cubit/profile_top_card_cubit/profile_top_card_cubit.dart';
import '../../router/app_router.dart';
import 'blur_bg.dart';

class ProfileTopCard extends StatelessWidget {
  const ProfileTopCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ProfileTopCardCubit>(context).getUserDetails();
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.w),
        color: MyColors.lightElv3,
        boxShadow: [
          BoxShadow(
            color: MyColors.darkElv1.withOpacity(0.1),
            offset: const Offset(1, 1),
            blurRadius: 2,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<ProfileTopCardCubit, ProfileTopCardState>(
            builder: (context, state) {
              if (state is ProfileTopCardLoaded) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.w),
                      child: state.fireUser.profilePic != "null"
                          ? FadeInImage(
                              placeholder:
                                  const AssetImage("assets/images/boy.jpg"),
                              image: NetworkImage(
                                state.fireUser.profilePic,
                              ),
                              width: 24.w,
                              height: 24.w,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              "assets/images/boy.jpg",
                              width: 24.w,
                              height: 24.w,
                              fit: BoxFit.cover,
                            ),
                    ),
                    SizedBox(width: 6.w),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.fireUser.name,
                          style: TextStyle(
                            color: MyColors.darkElv0,
                            fontSize: 18.sp,
                          ),
                        ),
                        Text(
                          state.fireUser.email,
                          style: TextStyle(
                            color: MyColors.darkElv1,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.w),
                      child: Image.asset(
                        "assets/images/boy.jpg",
                        width: 24.w,
                        height: 24.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 20.w,
                          height: 1.6.h,
                          decoration: BoxDecoration(
                            color: MyColors.lightElv2,
                            borderRadius: BorderRadius.circular(1.w),
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Container(
                          width: 40.w,
                          height: 1.2.h,
                          decoration: BoxDecoration(
                            color: MyColors.lightElv2,
                            borderRadius: BorderRadius.circular(1.w),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () =>
                  Navigator.pushNamed(context, AppRouter.editProfileScreen),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: MyColors.darkElv0,
                    ),
                    borderRadius: BorderRadius.circular(2.w)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.settings_rounded,
                      size: 14.sp,
                      color: MyColors.darkElv0,
                    ),
                    SizedBox(
                      width: 1.w,
                    ),
                    Text(
                      "Edit",
                      style: TextStyle(
                        color: MyColors.darkElv0,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
