import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/my_colors.dart';
import '../../../data/models/subject_model.dart';
import '../../../logic/cubit/sub_prog_card_cubit/sub_prog_card_cubit.dart';
import '../../../logic/cubit/sub_prog_cubit/sub_prog_cubit.dart';
import 'sub_prog_card_item.dart';

class SubProgCard extends StatelessWidget {
  const SubProgCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SubProgCardCubit>(context).getSubjects();
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
            "Summary",
            style: TextStyle(
              color: MyColors.darkElv0,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          BlocBuilder<SubProgCardCubit, SubProgCardState>(
            builder: (context, state) {
              if (state is SubProgCardLoaded) {
                return Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: builedItemList(subjectList: state.subjectList),
                  ),
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

  List<Widget> builedItemList({required List<Subject> subjectList}) {
    List<Widget> itemList = [];
    for (var subject in subjectList) {
      itemList.add(
        BlocProvider(
          create: (context) => SubProgCubit(),
          child: SubProgCardItem(
            subject: subject,
          ),
        ),
      );
    }
    return itemList;
  }
}
