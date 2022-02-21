import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/my_colors.dart';
import '../../../core/screen_arguments/subject_screen_args.dart';
import '../../../data/models/subject_model.dart';
import '../../../logic/cubit/subject_card_cubit/subject_card_cubit.dart';
import '../../router/app_router.dart';
import 'blur_bg.dart';
import 'loading_container.dart';
import 'progress_bar.dart';

class SubjectCard extends StatelessWidget {
  final Subject subject;
  final Color color;
  const SubjectCard({
    Key? key,
    required this.subject,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SubjectCardCubit>(context)
        .loadSubjectCardDetails(subjectId: subject.id);
    return Column(
      children: [
        GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            AppRouter.subjectScreen,
            arguments: SubjectScreenArgs(
              subjectId: subject.id,
              subjectName: subject.name,
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.w),
              color: color,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject.name,
                  style: TextStyle(
                      color: MyColors.textColorDark,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 5.w,
                ),
                BlocBuilder<SubjectCardCubit, SubjectCardState>(
                  builder: (context, state) {
                    if (state is SubjectCardLoaded) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Modules",
                                style: TextStyle(
                                  color: MyColors.textColorDark,
                                  fontSize: 16.sp,
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    "${state.completedModules}/${state.moduleCount}",
                                    style: TextStyle(
                                      color: MyColors.textColorDark,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 0.5.h,
                                  ),
                                  MyProgressBar(
                                    width: 35.w,
                                    max: state.moduleCount,
                                    progress: state.completedModules,
                                    backgroundColor: MyColors.textColorLight,
                                    progressColor: MyColors.progressColor,
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 2.w,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Contents",
                                  style: TextStyle(
                                    color: MyColors.textColorDark,
                                    fontSize: 16.sp,
                                  )),
                              Column(
                                children: [
                                  Text(
                                    "${state.completedContents}/${state.contentCount}",
                                    style: TextStyle(
                                      color: MyColors.textColorDark,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 0.5.h,
                                  ),
                                  MyProgressBar(
                                    width: 35.w,
                                    max: state.contentCount,
                                    progress: state.completedContents,
                                    backgroundColor: MyColors.textColorLight,
                                    progressColor: MyColors.progressColor,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              LoadingContainer(
                                width: 20.w,
                                height: 2.5.h,
                              ),
                              LoadingContainer(
                                width: 30.w,
                                height: 2.5.h,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              LoadingContainer(
                                width: 20.w,
                                height: 2.5.h,
                              ),
                              LoadingContainer(
                                width: 30.w,
                                height: 2.5.h,
                              )
                            ],
                          )
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 2.h,
        )
      ],
    );
  }
}
