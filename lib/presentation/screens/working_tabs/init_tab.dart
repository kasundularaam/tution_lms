import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/my_colors.dart';
import '../../../core/constants/shared_prefs_keys.dart';
import '../../../core/screen_arguments/content_screen_args.dart';
import '../../../logic/cubit/timer_cubit/timer_cubit.dart';
import '../../../logic/cubit/working_cubit/working_cubit.dart';
import '../../templates/inner_scrn_tmpl.dart';
import '../widgets/big_btn.dart';

class InitTab extends StatefulWidget {
  final ContentScreenArgs args;
  const InitTab({
    Key? key,
    required this.args,
  }) : super(key: key);

  @override
  _InitTabState createState() => _InitTabState();
}

class _InitTabState extends State<InitTab> {
  Future<void> checkSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isOnWorking = prefs.getBool(SharedPrefsKeys.isOnWorkingKey);
    if (isOnWorking != null) {
      if (isOnWorking) {
        int startTimeStampSp =
            prefs.getInt(SharedPrefsKeys.startTimeStampKey) ?? 0;
        BlocProvider.of<TimerCubit>(context)
            .backToWork(startTimeStampSp: startTimeStampSp);
      } else {
        BlocProvider.of<TimerCubit>(context)
            .emit(TimerInitial(initCounter: "00.00.00"));
      }
    } else {
      BlocProvider.of<TimerCubit>(context)
          .emit(TimerInitial(initCounter: "00.00.00"));
    }
  }

  @override
  void initState() {
    super.initState();
    checkSP();
  }

  @override
  void dispose() {
    BlocProvider.of<TimerCubit>(context).cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InnerScrnTmpl(
      title: "Let's Work",
      content: ListView(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        physics: const BouncingScrollPhysics(),
        children: [
          SizedBox(
            height: 3.h,
          ),
          Center(
            child: BlocBuilder<TimerCubit, TimerState>(
              builder: (context, state) {
                if (state is TimerStarted) {
                  return Container(
                    padding: EdgeInsets.all(5.w),
                    decoration: BoxDecoration(
                      color: MyColors.primaryColor,
                      borderRadius: BorderRadius.circular(5.w),
                    ),
                    child: Text(
                      state.startedCounter,
                      style: TextStyle(
                          color: MyColors.primaryDarkColor,
                          fontSize: 50.sp,
                          fontWeight: FontWeight.w600),
                    ),
                  );
                } else if (state is TimerRunning) {
                  return Container(
                    padding: EdgeInsets.all(5.w),
                    decoration: BoxDecoration(
                      color: MyColors.primaryColor,
                      borderRadius: BorderRadius.circular(5.w),
                    ),
                    child: Text(
                      state.timeCounter,
                      style: TextStyle(
                          color: MyColors.primaryDarkColor,
                          fontSize: 50.sp,
                          fontWeight: FontWeight.w600),
                    ),
                  );
                } else if (state is TimerEnded) {
                  return Container(
                    padding: EdgeInsets.all(5.w),
                    decoration: BoxDecoration(
                      color: MyColors.lightElv3,
                      borderRadius: BorderRadius.circular(5.w),
                    ),
                    child: Text(
                      state.args.clockValue,
                      style: TextStyle(
                        color: MyColors.darkElv0,
                        fontSize: 50.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                } else {
                  return Container(
                    padding: EdgeInsets.all(5.w),
                    decoration: BoxDecoration(
                      color: MyColors.lightElv3,
                      borderRadius: BorderRadius.circular(5.w),
                    ),
                    child: Text(
                      "00:00:00",
                      style: TextStyle(
                        color: MyColors.darkElv0,
                        fontSize: 50.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          Container(
            width: 100.w,
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              color: MyColors.lightElv3,
              borderRadius: BorderRadius.circular(5.w),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Subject: ${widget.args.subjectName}",
                  style: TextStyle(
                    color: MyColors.darkElv1,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  "Module: ${widget.args.moduleName}",
                  style: TextStyle(
                    color: MyColors.darkElv1,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  "Content: ${widget.args.contentName}",
                  style: TextStyle(
                    color: MyColors.darkElv1,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          BlocConsumer<TimerCubit, TimerState>(
            listener: (context, state) {
              if (state is TimerEnded) {
                BlocProvider.of<WorkingCubit>(context).emit(
                  WorkingEnded(
                    args: state.args,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is TimerInitial) {
                return BigBtn(
                    btnText: "Start",
                    onPressed: () => BlocProvider.of<TimerCubit>(context)
                        .startTimer(
                            notifMsg: widget.args.contentName,
                            args: widget.args),
                    bgColor: MyColors.primaryDarkColor,
                    txtColor: MyColors.lightElv3);
              } else {
                return BigBtn(
                    btnText: "End",
                    onPressed: () => BlocProvider.of<TimerCubit>(context)
                        .endTimer(contentScreenArgs: widget.args),
                    bgColor: MyColors.lightColor,
                    txtColor: MyColors.red);
              }
            },
          ),
        ],
      ),
    );
  }
}
