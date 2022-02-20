import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/my_colors.dart';
import '../../../data/models/subject_model.dart';
import '../../../logic/cubit/h_t_c_Item_cubit/h_t_c_item_cubit.dart';
import 'blur_bg.dart';
import 'home_top_card_item.dart';

class HomeTopCard extends StatelessWidget {
  final List<Subject> subjectList;
  const HomeTopCard({
    Key? key,
    required this.subjectList,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(5.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.w),
            color: MyColors.lightElv3,
            boxShadow: [
              BoxShadow(
                color: MyColors.darkElv1.withOpacity(0.05),
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
                "Subjects",
                style: TextStyle(
                    color: MyColors.textColorDark,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 1.h,
              ),
              Column(
                children: builedItemList(subjectList: subjectList),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 3.h,
        )
      ],
    );
  }

  List<Widget> builedItemList({required List<Subject> subjectList}) {
    List<Widget> itemList = [];
    for (var subject in subjectList) {
      itemList.add(
        BlocProvider(
          create: (context) => HTCItemCubit(),
          child: HomeTopCardItem(
            subject: subject,
          ),
        ),
      );
    }
    return itemList;
  }
}
