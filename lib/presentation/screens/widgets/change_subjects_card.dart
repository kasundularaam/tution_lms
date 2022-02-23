import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/my_colors.dart';
import '../../../core/screen_arguments/change_sub_args.dart';
import '../../../data/models/subject_model.dart';
import '../../router/app_router.dart';

class ChangeSubjectsCard extends StatefulWidget {
  final List<Subject> fireSubjects;
  final List<Subject> subjects;
  final BuildContext screenContext;
  const ChangeSubjectsCard({
    Key? key,
    required this.fireSubjects,
    required this.subjects,
    required this.screenContext,
  }) : super(key: key);

  @override
  _ChangeSubjectsCardState createState() => _ChangeSubjectsCardState();
}

class _ChangeSubjectsCardState extends State<ChangeSubjectsCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
          color: MyColors.lightElv3, borderRadius: BorderRadius.circular(2.w)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Subjects",
            style: TextStyle(
              color: MyColors.darkElv0,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Column(
            children: buildSubjectList(),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () => Navigator.pushNamed(
                  context, AppRouter.changeSubjectsScreen,
                  arguments: ChangeSubScrnArgs(
                      fireSubjects: widget.fireSubjects,
                      subjects: widget.subjects)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Text(
                  "CHANGE",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: MyColors.primaryDarkColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildSubjectList() {
    List<Widget> subList = [];
    widget.fireSubjects.forEach((sub) {
      subList.add(buildSubject(subject: sub));
    });
    return subList;
  }

  Widget buildSubject({required Subject subject}) {
    return Column(
      children: [
        Container(
          width: 100.w,
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: MyColors.primaryDarkColor,
            borderRadius: BorderRadius.circular(2.w),
          ),
          child: Text(
            "${subject.userName} (${subject.name})",
            style: TextStyle(
                fontSize: 14.sp,
                color: MyColors.lightElv3,
                overflow: TextOverflow.ellipsis),
          ),
        ),
        SizedBox(
          height: 2.h,
        ),
      ],
    );
  }
}
