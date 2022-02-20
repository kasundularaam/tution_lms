import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/my_colors.dart';
import '../../../logic/cubit/logout_cubit/logout_cubit.dart';
import '../../../logic/cubit/quiz_summary_cubit/quiz_summary_card_cubit.dart';
import '../../../logic/cubit/sub_prog_card_cubit/sub_prog_card_cubit.dart';
import '../../../logic/cubit/today_worls_cubit/today_works_cubit.dart';
import '../../../logic/cubit/work_card_list_cubit/work_card_list_cubit.dart';
import '../../router/app_router.dart';
import '../../templates/home_tabs_tmpl.dart';
import '../widgets/profile_top_card.dart';
import '../widgets/quiz_stats_card.dart';
import '../widgets/sub_prog_card.dart';
import '../widgets/today_worked_details.dart';
import '../widgets/work_card_list.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    return HomeTabsTmpl(
      title: "Profile",
      content: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          children: [
            SizedBox(height: 10.h),
            BlocProvider.value(
              value: AppRouter.profileTopCardCubit,
              child: const ProfileTopCard(),
            ),
            SizedBox(height: 2.h),
            BlocProvider(
              create: (context) => TodayWorksCubit(),
              child: const TodayWorkedDetails(),
            ),
            SizedBox(height: 2.h),
            BlocProvider(
              create: (context) => SubProgCardCubit(),
              child: const SubProgCard(),
            ),
            SizedBox(
              height: 3.h,
            ),
            BlocProvider(
              create: (context) => QuizSummaryCardCubit(),
              child: const QuizStatsCard(),
            ),
            SizedBox(height: 2.h),
            Text(
              "Your activities",
              style: TextStyle(
                color: MyColors.darkElv0,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            BlocProvider(
              create: (context) => WorkCardListCubit(),
              child: const WorkCardList(),
            ),
          ]),
      action: BlocConsumer<LogoutCubit, LogoutState>(
        listener: (context, state) {
          if (state is LogoutSucceed) {
            Navigator.pushNamedAndRemoveUntil(
                context, AppRouter.authScreen, (Route<dynamic> route) => false);
          } else if (state is LogoutFailed) {
            SnackBar snackBar = SnackBar(content: Text(state.errorMsg));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        builder: (context, state) {
          if (state is LogoutLoading) {
            return const CircularProgressIndicator(
              color: MyColors.primaryColor,
            );
          } else if (state is LogoutSucceed) {
            return Icon(
              Icons.check_rounded,
              size: 14.sp,
              color: MyColors.darkElv1,
            );
          } else {
            return GestureDetector(
              onTap: () => BlocProvider.of<LogoutCubit>(context).logOut(),
              child: Text(
                "SIGN OUT",
                style: TextStyle(
                  color: MyColors.primaryDarkColor,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
