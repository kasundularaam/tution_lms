import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../core/constants/my_colors.dart';
import '../../core/screen_arguments/add_eve_to_mod_scrn_args.dart';
import '../../data/models/add_mod_eve_cal_cu_model.dart';
import '../../logic/cubit/add_mod_eve_cal_cubit/add_mod_eve_cal_cubit.dart';
import '../../logic/cubit/pick_date_cubit/pick_date_cubit.dart';
import '../../logic/cubit/pick_time_cubit/pick_time_cubit.dart';
import '../templates/inner_scrn_tmpl.dart';
import 'widgets/date_picker.dart';
import 'widgets/reguler_btn.dart';
import 'widgets/time_picker.dart';

class AddEventToModScreen extends StatefulWidget {
  final AddEveToModScrnArgs args;
  const AddEventToModScreen({
    Key? key,
    required this.args,
  }) : super(key: key);
  @override
  _AddEventToModScreenState createState() => _AddEventToModScreenState();
}

class _AddEventToModScreenState extends State<AddEventToModScreen> {
  DateTime? pickedDate;
  TimeOfDay? pickedTime;
  String title = "";
  int weekCount = 1;
  bool switchValue = false;

  @override
  Widget build(BuildContext context) {
    title = "${widget.args.subjectName} > ${widget.args.moduleName}";
    return InnerScrnTmpl(
      title: "Set Reminder",
      content: ListView(
        padding: EdgeInsets.all(5.w),
        physics: const BouncingScrollPhysics(),
        children: [
          Text("Module",
              style: TextStyle(color: MyColors.darkElv0, fontSize: 16.sp)),
          SizedBox(
            height: 2.h,
          ),
          Container(
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              color: MyColors.lightElv3,
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Text(
              title,
              style: TextStyle(color: MyColors.darkElv1, fontSize: 14.sp),
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            "Date",
            style: TextStyle(color: MyColors.darkElv0, fontSize: 16.sp),
          ),
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
            height: 2.h,
          ),
          Text("Repeat",
              style: TextStyle(color: MyColors.darkElv0, fontSize: 16.sp)),
          SizedBox(
            height: 2.h,
          ),
          Container(
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              color: MyColors.lightElv3,
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Remind Me Weekly",
                      style:
                          TextStyle(color: MyColors.darkElv1, fontSize: 14.sp),
                    ),
                    Switch(
                        activeColor: MyColors.primaryColor,
                        value: switchValue,
                        onChanged: (value) {
                          setState(() {
                            switchValue = value;
                            if (value) {
                              weekCount = 2;
                            } else {
                              weekCount = 1;
                            }
                            print("Here The Week Count $weekCount");
                          });
                        }),
                  ],
                ),
                switchValue
                    ? Column(
                        children: [
                          SizedBox(
                            height: 2.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "For $weekCount Weeks",
                                style: TextStyle(
                                    color: MyColors.darkElv1, fontSize: 14.sp),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (weekCount > 2) {
                                          weekCount--;
                                        }
                                      });
                                      print("Here The Week Count $weekCount");
                                    },
                                    child: Container(
                                        padding: EdgeInsets.all(2.w),
                                        decoration: const BoxDecoration(
                                            color: MyColors.darkElv1,
                                            shape: BoxShape.circle),
                                        child: const Icon(
                                          Icons.remove,
                                          color: MyColors.lightElv3,
                                        )),
                                  ),
                                  Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 1.w),
                                      padding: EdgeInsets.all(5.w),
                                      decoration: const BoxDecoration(
                                          color: MyColors.primaryDarkColor,
                                          shape: BoxShape.circle),
                                      child: Text(
                                        "$weekCount",
                                        style: TextStyle(
                                            color: MyColors.lightColor,
                                            fontSize: 14.sp),
                                      )),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        weekCount++;
                                      });
                                      print("Here The Week Count $weekCount");
                                    },
                                    child: Container(
                                        padding: EdgeInsets.all(2.w),
                                        decoration: const BoxDecoration(
                                            color: MyColors.darkElv1,
                                            shape: BoxShape.circle),
                                        child: const Icon(
                                          Icons.add,
                                          color: MyColors.lightElv3,
                                        )),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          BlocConsumer<AddModEveCalCubit, AddModEveCalState>(
            listener: (context, state) {
              if (state is AddModEveCalFailed) {
                SnackBar snackBar = SnackBar(content: Text(state.errorMsg));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else if (state is AddModEveCalSucceed) {
                SnackBar snackBar = const SnackBar(content: Text("event set!"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.pop(context);
              }
            },
            builder: (context, state) {
              if (state is AddModEveCalLoading) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Center(
                  child: RegulerBtn(
                      btnText: "Add",
                      onPressed: () {
                        if (pickedDate != null && pickedTime != null) {
                          BlocProvider.of<AddModEveCalCubit>(context)
                              .addModEveToCal(
                                  addModEveCalCuMod: AddModEveCalCuMod(
                                      date: pickedDate!,
                                      time: pickedTime!,
                                      subjectId: widget.args.subjectId,
                                      subjectName: widget.args.subjectName,
                                      moduleId: widget.args.moduleId,
                                      moduleName: widget.args.moduleName),
                                  count: weekCount);
                        } else {
                          print("date or time not picked");
                        }
                      },
                      bgColor: MyColors.primaryDarkColor,
                      txtColor: MyColors.lightColor),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
