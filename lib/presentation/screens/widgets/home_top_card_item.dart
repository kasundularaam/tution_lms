import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/my_colors.dart';
import '../../../data/models/subject_model.dart';
import '../../../logic/cubit/h_t_c_Item_cubit/h_t_c_item_cubit.dart';
import 'progress_bar.dart';

class HomeTopCardItem extends StatelessWidget {
  final Subject subject;
  const HomeTopCardItem({
    Key? key,
    required this.subject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<HTCItemCubit>(context)
        .loadSubjectDetails(subjectId: subject.id);
    return BlocBuilder<HTCItemCubit, HTCItemState>(
      builder: (context, state) {
        int percentage = 0;
        if (state is HTCItemLoaded) {
          if (state.contentCount > 0) {
            percentage =
                ((state.fireContentCount / state.contentCount) * 100).toInt();
          }

          return Column(
            children: [
              SizedBox(
                height: 2.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      subject.name,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(color: MyColors.darkColor, fontSize: 14.sp),
                    ),
                  ),
                  Text(
                    "$percentage%",
                    style:
                        TextStyle(color: MyColors.darkColor, fontSize: 14.sp),
                  ),
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              MyProgressBar(
                  width: 75.w,
                  max: state.contentCount,
                  progress: state.fireContentCount,
                  backgroundColor: MyColors.primaryColor.withOpacity(0.5),
                  progressColor: MyColors.progressColor),
            ],
          );
        } else {
          return Column(
            children: [
              SizedBox(
                height: 2.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      subject.name,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(color: MyColors.darkColor, fontSize: 14.sp),
                    ),
                  ),
                  Text(
                    "...",
                    style: TextStyle(
                        color: MyColors.darkColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              MyProgressBar(
                width: 75.w,
                max: 100,
                progress: 0,
                backgroundColor: MyColors.primaryColor.withOpacity(0.5),
                progressColor: MyColors.progressColor,
              ),
            ],
          );
        }
      },
    );
  }
}
