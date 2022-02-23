import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/my_colors.dart';
import '../../../core/screen_arguments/add_countdown_scrn_args.dart';
import '../../../data/models/countdown_model.dart';
import '../../../logic/cubit/countdown_cubit/countdown_cubit.dart';
import '../../../logic/cubit/countdown_tab_cubit/countdown_tab_cubit.dart';
import '../../router/app_router.dart';
import '../../templates/home_tabs_tmpl.dart';
import '../widgets/countdown_card.dart';
import '../widgets/error_msg_box.dart';

class CountDownTab extends StatefulWidget {
  @override
  _CountDownTabState createState() => _CountDownTabState();
}

class _CountDownTabState extends State<CountDownTab> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CountdownTabCubit>(context).loadCountdowns();
  }

  @override
  Widget build(BuildContext context) {
    return HomeTabsTmpl(
      title: "Exam Countdown",
      action: GestureDetector(
        onTap: () => Navigator.pushNamed(context, AppRouter.addCountdownScreen,
            arguments: AddCountdownScrnArgs(add: true)),
        child: Icon(
          Icons.add_alarm_rounded,
          color: MyColors.darkElv1,
          size: 22.sp,
        ),
      ),
      content: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(0),
        children: [
          SizedBox(
            height: 10.h,
          ),
          BlocBuilder<CountdownTabCubit, CountdownTabState>(
              builder: (context, state) {
            if (state is CountdownTabLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: MyColors.primaryColor,
                ),
              );
            } else if (state is CountdownTabLoaded) {
              return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  itemCount: state.countdowns.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    Countdown countdown = state.countdowns[index];
                    return BlocProvider(
                      create: (context) => CountdownCubit(),
                      child: CountdownCard(
                        showOptions: () => showModalBottomSheet(
                          context: context,
                          builder: (bSContext) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 2.h,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(bSContext);
                                  Navigator.pushNamed(
                                    bSContext,
                                    AppRouter.addCountdownScreen,
                                    arguments: AddCountdownScrnArgs(
                                      add: false,
                                      countdown: countdown,
                                    ),
                                  );
                                },
                                child: Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.w, vertical: 1.2.h),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3.h),
                                      color: MyColors.primaryDarkColor
                                          .withOpacity(0.1)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.edit_rounded,
                                        color: MyColors.orange,
                                      ),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      Text(
                                        "Edit",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: MyColors.darkElv1,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(bSContext);
                                  BlocProvider.of<CountdownTabCubit>(context)
                                      .deleteCountdown(
                                          countdownId: countdown.countdownId,
                                          index: index);
                                },
                                child: Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.w, vertical: 1.2.h),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3.h),
                                      color: MyColors.primaryDarkColor
                                          .withOpacity(0.1)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.delete_rounded,
                                        color: MyColors.red,
                                      ),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      Text(
                                        "Delete",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: MyColors.darkElv1,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                            ],
                          ),
                        ),
                        countdown: countdown,
                      ),
                    );
                  });
            } else {
              return const Center(
                child: ErrorMsgBox(
                  errorMsg: "No Exams Found",
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}
