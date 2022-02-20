import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/constants/my_colors.dart';

class HomeTabsTmpl extends StatefulWidget {
  final String title;
  final Widget content;

  final Widget? action;
  const HomeTabsTmpl({
    Key? key,
    required this.title,
    required this.content,
    this.action,
  }) : super(key: key);

  @override
  _HomeTabsTmplState createState() => _HomeTabsTmplState();
}

class _HomeTabsTmplState extends State<HomeTabsTmpl> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(10.w),
        bottomRight: Radius.circular(10.w),
      ),
      child: Container(
        color: MyColors.lightElv2,
        child: Stack(
          children: [
            widget.content,
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: MyColors.darkElv1.withOpacity(0.05),
                    offset: const Offset(0, 1),
                    blurRadius: 4,
                    spreadRadius: 4,
                  )
                ],
                color: MyColors.lightElv3,
              ),
              width: 100.w,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                          color: MyColors.primaryColor,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600),
                    ),
                    widget.action ?? const SizedBox(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
