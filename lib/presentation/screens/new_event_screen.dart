import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../core/constants/my_colors.dart';
import '../../logic/cubit/new_event_cubit/new_event_cubit.dart';
import '../../logic/cubit/pick_date_cubit/pick_date_cubit.dart';
import '../../logic/cubit/pick_time_cubit/pick_time_cubit.dart';
import '../../logic/cubit/show_cal_events_cubit/show_cal_events_cubit.dart';
import '../templates/inner_scrn_tmpl.dart';
import 'widgets/date_picker.dart';
import 'widgets/reguler_btn.dart';
import 'widgets/time_picker.dart';

class NewEventScreen extends StatefulWidget {
  const NewEventScreen({Key? key}) : super(key: key);

  @override
  _NewEventScreenState createState() => _NewEventScreenState();
}

class _NewEventScreenState extends State<NewEventScreen> {
  DateTime? pickedDate;
  TimeOfDay? pickedTime;
  String title = "Untitled";

  @override
  Widget build(BuildContext context) {
    return InnerScrnTmpl(
      title: "Set Reminder",
      content: ListView(
        padding: EdgeInsets.all(5.w),
        physics: const BouncingScrollPhysics(),
        children: [
          SizedBox(
            height: 2.h,
          ),
          Text("Date",
              style: TextStyle(color: MyColors.darkColor, fontSize: 16.sp)),
          SizedBox(
            height: 2.h,
          ),
          BlocProvider(
            create: (context) => PickDateCubit(),
            child: MDatePicker(
              onSelectDate: (date) => pickedDate = date,
              bgColor: MyColors.lightColor,
              txtColor: MyColors.darkColor,
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Text("Time",
              style: TextStyle(color: MyColors.darkColor, fontSize: 16.sp)),
          SizedBox(
            height: 2.h,
          ),
          BlocProvider(
            create: (context) => PickTimeCubit(),
            child: MTimePicker(
              onPickedTime: (time) => pickedTime = time,
              bgColor: MyColors.lightColor,
              txtColor: MyColors.darkColor,
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          Text("Description",
              style: TextStyle(color: MyColors.darkColor, fontSize: 16.sp)),
          SizedBox(
            height: 2.h,
          ),
          Container(
            decoration: BoxDecoration(
              color: MyColors.white,
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: TextField(
              obscureText: false,
              onChanged: (text) => title = text,
              autofocus: false,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: TextStyle(color: MyColors.textColorDark, fontSize: 14.sp),
              decoration: InputDecoration(
                hintText: "Your Reminder Description...",
                contentPadding:
                    EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          BlocConsumer<NewEventCubit, NewEventState>(
            listener: (context, state) {
              if (state is NewEventSucceed) {
                SnackBar snackBar =
                    const SnackBar(content: Text("EVENT ADDED SUCCESSFULLY!"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                BlocProvider.of<ShowCalEventsCubit>(context).loadEvents();
                Navigator.pop(context);
              } else if (state is NewEventFailed) {
                SnackBar snackBar = SnackBar(content: Text(state.errorMsg));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            builder: (context, state) {
              if (state is NewEventLoading) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: MyColors.progressColor,
                ));
              } else {
                return Center(
                  child: RegulerBtn(
                    btnText: "Add",
                    onPressed: () {
                      if (pickedDate != null && pickedTime != null) {
                        BlocProvider.of<NewEventCubit>(context).addNewEvent(
                            date: pickedDate!, time: pickedTime!, title: title);
                      } else {
                        BlocProvider.of<NewEventCubit>(context).emit(
                            NewEventFailed(
                                errorMsg: "Please pick date and time!"));
                      }
                    },
                    bgColor: MyColors.secondaryColor,
                    txtColor: MyColors.lightColor,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
