import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../core/constants/my_colors.dart';
import '../../core/screen_arguments/add_countdown_scrn_args.dart';
import '../../logic/cubit/countdown_tab_cubit/countdown_tab_cubit.dart';
import '../../logic/cubit/pick_date_cubit/pick_date_cubit.dart';
import '../../logic/cubit/pick_time_cubit/pick_time_cubit.dart';
import '../../logic/cubit/set_countdown_cubit/set_countdown_cubit.dart';
import '../templates/inner_scrn_tmpl.dart';
import 'widgets/date_picker.dart';
import 'widgets/my_text_field.dart';
import 'widgets/reguler_btn.dart';
import 'widgets/time_picker.dart';

class AddCountdownScreen extends StatefulWidget {
  final AddCountdownScrnArgs args;
  const AddCountdownScreen({
    Key? key,
    required this.args,
  }) : super(key: key);

  @override
  _AddCountdownScreenState createState() => _AddCountdownScreenState();
}

class _AddCountdownScreenState extends State<AddCountdownScreen> {
  DateTime? pickedDate;
  TimeOfDay? pickedTime;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.args.add ? "" : widget.args.countdown!.examTitle;
  }

  @override
  Widget build(BuildContext context) {
    return InnerScrnTmpl(
      title: widget.args.add ? "New Countdown" : "Edit Countdown",
      content: ListView(
        padding: EdgeInsets.all(5.w),
        physics: const BouncingScrollPhysics(),
        children: [
          Text(
            "Exam Title",
            style: TextStyle(
              color: MyColors.darkElv0,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          MyTextField(
            controller: controller,
            onChanged: (text) {},
            onSubmitted: (text) {},
            textInputAction: TextInputAction.done,
            isPassword: false,
            hintText: "Title...",
            textColor: MyColors.darkElv1,
            bgColor: MyColors.lightElv3,
          ),
          SizedBox(
            height: 2.h,
          ),
          Text("Date",
              style: TextStyle(color: MyColors.darkElv0, fontSize: 16.sp)),
          SizedBox(
            height: 2.h,
          ),
          BlocProvider(
            create: (context) => PickDateCubit(),
            child: MDatePicker(
              onSelectDate: (date) => pickedDate = date,
              bgColor: MyColors.lightElv3,
              txtColor: MyColors.darkElv1,
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Text("Time",
              style: TextStyle(color: MyColors.darkElv0, fontSize: 16.sp)),
          SizedBox(
            height: 2.h,
          ),
          BlocProvider(
            create: (context) => PickTimeCubit(),
            child: MTimePicker(
              onPickedTime: (time) => pickedTime = time,
              bgColor: MyColors.lightElv3,
              txtColor: MyColors.darkElv1,
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          Center(
            child: BlocConsumer<SetCountdownCubit, SetCountdownState>(
                builder: (context, state) {
              if (state is SetCountdownLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: MyColors.primaryColor,
                  ),
                );
              } else {
                return RegulerBtn(
                  btnText: widget.args.add ? "Add" : "Update",
                  onPressed: () =>
                      BlocProvider.of<SetCountdownCubit>(context).setCountdown(
                    countdownIdEdit: widget.args.add
                        ? null
                        : widget.args.countdown!.countdownId,
                    examTitle: controller.text,
                    exmTime: pickedTime!,
                    exmDate: pickedDate!,
                  ),
                  bgColor: MyColors.primaryDarkColor,
                  txtColor: MyColors.lightElv3,
                );
              }
            }, listener: (context, state) {
              if (state is SetCountdownFaild) {
                SnackBar snackBar = SnackBar(content: Text(state.errorMsg));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else if (state is SetCountdownSucceed) {
                SnackBar snackBar = const SnackBar(
                    content: Text("COUNTDOWN ADDED SUCCESSFULLY!"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                BlocProvider.of<CountdownTabCubit>(context).loadCountdowns();
                Navigator.pop(context);
              }
            }),
          ),
        ],
      ),
    );
  }
}
