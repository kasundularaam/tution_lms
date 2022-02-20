import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/my_colors.dart';
import '../../../logic/cubit/today_worls_cubit/today_works_cubit.dart';
import 'blur_bg.dart';
import 'indicators_widget.dart';
import 'pie_chart_sections.dart';

class TodayWorkedDetails extends StatelessWidget {
  const TodayWorkedDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<TodayWorksCubit>(context).loadTodayWorkCardData();
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(5.w),
          decoration: BoxDecoration(
            color: MyColors.lightElv3,
            borderRadius: BorderRadius.circular(5.w),
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
              Text(
                "Today Progress",
                style: TextStyle(
                  color: MyColors.darkElv0,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              BlocBuilder<TodayWorksCubit, TodayWorksState>(
                builder: (context, state) {
                  if (state is TodayWorksLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: <Widget>[
                            SizedBox(
                              width: 100.w,
                              height: 25.h,
                              child: PieChart(
                                PieChartData(
                                  borderData: FlBorderData(show: false),
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 5.w,
                                  sections: getSections(
                                      pieDataList: state.pieDataList),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IndicatorsWidget(
                                    pieDataList: state.pieDataList),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Divider(
                          color: MyColors.primaryColor,
                          thickness: 0.2.w,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Text(
                                "${state.workedTime}",
                                style: TextStyle(
                                  color: MyColors.darkElv0,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "Time Worked Today",
                                style: TextStyle(
                                  color: MyColors.darkElv1,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else if (state is TodayWorksNoWork) {
                    return Center(
                      child: Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: MyColors.darkElv1,
                          fontSize: 12.sp,
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(
                        "Loading...",
                        style: TextStyle(
                          color: MyColors.darkElv1,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
