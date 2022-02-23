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
          color: MyColors.textColorLight,
          borderRadius: BorderRadius.circular(2.w)),
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
      subList.add(buildSubject(subjectName: sub.name));
    });
    return subList;
  }

  Widget buildSubject({required String subjectName}) {
    return Column(
      children: [
        Container(
          width: 100.w,
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: MyColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(1.w),
          ),
          child: Text(
            subjectName,
            style: TextStyle(
              fontSize: 14.sp,
              color: MyColors.darkElv1,
            ),
          ),
        ),
        SizedBox(
          height: 2.h,
        ),
      ],
    );
  }
}
