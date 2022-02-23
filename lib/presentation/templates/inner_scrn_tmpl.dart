import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/constants/my_colors.dart';
import '../../core/constants/my_styles.dart';

class InnerScrnTmpl extends StatefulWidget {
  final String title;
  final String? subtitle;
  final Widget content;
  final Widget? action;
  const InnerScrnTmpl({
    Key? key,
    required this.title,
    this.subtitle,
    required this.content,
    this.action,
  }) : super(key: key);

  @override
  _InnerScrnTmplState createState() => _InnerScrnTmplState();
}

class _InnerScrnTmplState extends State<InnerScrnTmpl> {
  @override
  Widget build(BuildContext context) {
    double actionWidgetSize = 20.sp + 5.w + 5.w;
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      body: SafeArea(
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: EdgeInsets.all(5.w),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: MyColors.lightElv3,
                          size: 20.sp,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 2.h,
                          ),
                          FittedBox(
                            child: Text(
                              widget.title,
                              style: MyStyles.screenTitles,
                            ),
                          ),
                          widget.subtitle != null
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    FittedBox(
                                      child: Text(
                                        widget.subtitle!,
                                        style: MyStyles.screenSubtitles,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                  ],
                                )
                              : SizedBox(
                                  height: 2.h,
                                ),
                        ],
                      ),
                    ),
                    widget.action ??
                        SizedBox(
                          width: actionWidgetSize,
                          height: actionWidgetSize,
                        ),
                  ],
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.w),
                      topRight: Radius.circular(8.w),
                    ),
                    child: Container(
                      color: MyColors.lightElv2,
                      child: widget.content,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
