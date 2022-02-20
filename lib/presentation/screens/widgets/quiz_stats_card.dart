import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/my_colors.dart';
import '../../../data/models/subject_model.dart';
import '../../../logic/cubit/qs_cubit_cubit/qs_item_cubit.dart';
import '../../../logic/cubit/quiz_summary_cubit/quiz_summary_card_cubit.dart';
import 'blur_bg.dart';
import 'qs_item.dart';

class QuizStatsCard extends StatelessWidget {
  const QuizStatsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<QuizSummaryCardCubit>(context).loadSubjects();
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
          Text(
            "Quiz Summary",
            style: TextStyle(
              color: MyColors.darkElv0,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          BlocBuilder<QuizSummaryCardCubit, QuizSummaryCardState>(
            builder: (context, state) {
              if (state is QuizSummaryLoaded) {
                return Column(
                  children: buildItemList(subjects: state.subjects),
                );
              } else {
                return Center(
                  child: Text(
                    "Loading...",
                    style: TextStyle(
                      color: MyColors.darkElv1,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  List<Widget> buildItemList({required List<Subject> subjects}) {
    List<Widget> itemList = [];
    for (var subject in subjects) {
      itemList.add(BlocProvider(
        create: (context) => QsItemCubit(),
        child: QsItem(
          subject: subject,
        ),
      ));
    }
    return itemList;
  }
}
