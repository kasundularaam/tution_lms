import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/my_colors.dart';
import '../../../data/models/subject_model.dart';

class SelectSubjectCard extends StatefulWidget {
  final Subject subject;
  final Function(Subject) onSelected;
  final bool isSelected;
  const SelectSubjectCard({
    Key? key,
    required this.subject,
    required this.onSelected,
    required this.isSelected,
  }) : super(key: key);
  @override
  _SelectSubjectCardState createState() => _SelectSubjectCardState();
}

class _SelectSubjectCardState extends State<SelectSubjectCard> {
  bool selected = false;
  @override
  void initState() {
    super.initState();
    selected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (selected) {
              widget.onSelected(widget.subject);
              setState(() {
                selected = false;
              });
            } else {
              widget.onSelected(widget.subject);
              setState(() {
                selected = true;
              });
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: selected
                  ? MyColors.primaryColor
                  : MyColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Center(
              child: Text(
                widget.subject.name,
                style: TextStyle(
                  color: selected ? MyColors.lightElv3 : MyColors.darkElv1,
                  fontSize: 16.sp,
                ),
              ),
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
