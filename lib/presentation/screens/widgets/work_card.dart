import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../core/constants/my_colors.dart';
import '../../../data/models/fire_content.dart';

class WorkCard extends StatelessWidget {
  final FireContent fireContent;
  final String profileImage;
  const WorkCard({
    Key? key,
    required this.fireContent,
    required this.profileImage,
  }) : super(key: key);

  String workedTimeStr({required int counter}) {
    String hoursStr =
        ((counter / (60 * 60)) % 60).floor().toString().padLeft(2, '0');
    String minutesStr =
        ((counter / 60) % 60).floor().toString().padLeft(2, '0');
    String secondsStr = (counter % 60).floor().toString().padLeft(2, '0');
    String timeString = "$hoursStr" ":" "$minutesStr" ":" "$secondsStr";
    return timeString;
  }

  @override
  Widget build(BuildContext context) {
    String workedTime = workedTimeStr(counter: fireContent.counter);

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(3.w),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipOval(
                    child: profileImage != "null"
                        ? FadeInImage(
                            placeholder: const AssetImage(
                              "assets/images/boy.jpg",
                            ),
                            image: NetworkImage(profileImage),
                            width: 8.w,
                            height: 8.w,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            "assets/images/boy.jpg",
                            width: 8.w,
                            height: 8.w,
                            fit: BoxFit.cover,
                          ),
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Text(
                    "You",
                    style: TextStyle(
                      color: MyColors.primaryDarkColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    fireContent.isCompleted
                        ? " completed a content on"
                        : " worked on",
                    style: TextStyle(
                      color: MyColors.darkElv0,
                      fontSize: 14.sp,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              Container(
                width: 100.w,
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: MyColors.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(1.w),
                ),
                child: Text(
                  "${fireContent.subjectName} > ${fireContent.moduleName} > ${fireContent.contentName}",
                  style: TextStyle(
                      color: MyColors.darkElv1,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                "Worked time: $workedTime",
                style: TextStyle(
                  color: MyColors.darkElv1,
                  fontSize: 12.sp,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  timeago.format(
                    DateTime.fromMillisecondsSinceEpoch(
                      fireContent.startTimestamp,
                    ),
                  ),
                  style: TextStyle(
                    color: MyColors.darkElv1,
                    fontSize: 12.sp,
                  ),
                ),
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
}
