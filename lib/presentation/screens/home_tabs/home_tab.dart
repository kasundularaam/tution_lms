import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/my_colors.dart';
import '../../../data/models/subject_model.dart';
import '../../../logic/cubit/home_tab_cubit/home_tab_cubit.dart';
import '../../../logic/cubit/subject_card_cubit/subject_card_cubit.dart';
import '../../templates/home_tabs_tmpl.dart';
import '../widgets/error_msg_box.dart';
import '../widgets/home_top_card.dart';
import '../widgets/subject_card.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeTabCubit>(context).loadSubjects();
  }

  @override
  Widget build(BuildContext context) {
    return HomeTabsTmpl(
      title: "Home",
      content: BlocBuilder<HomeTabCubit, HomeTabState>(
        builder: (context, state) {
          if (state is HomeTabInitial) {
            return const Center(child: Text("Initial State"));
          } else if (state is HomeTabLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: MyColors.primaryColor,
              ),
            );
          } else if (state is HomeTabLoaded) {
            return ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              children: [
                SizedBox(
                  height: 10.h,
                ),
                HomeTopCard(
                  subjectList: state.subjectList,
                ),
                ListView.builder(
                    padding: const EdgeInsets.all(0),
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: state.subjectList.length,
                    itemBuilder: (context, index) {
                      Subject subject = state.subjectList[index];
                      Color color = MyColors.subjectColors[index];
                      return BlocProvider(
                        create: (context) => SubjectCardCubit(),
                        child: SubjectCard(
                          subject: subject,
                          color: color,
                        ),
                      );
                    })
              ],
            );
          } else if (state is HomeTabFailed) {
            return ListView(
              children: [
                Center(
                  child: Column(
                    children: [
                      ErrorMsgBox(errorMsg: state.errorMsg),
                      SizedBox(
                        height: 5.h,
                      ),
                      TextButton(
                        onPressed: () => BlocProvider.of<HomeTabCubit>(context)
                            .loadSubjects(),
                        child: Text(
                          "Try Again",
                          style: TextStyle(
                            color: MyColors.darkElv1,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text("unhandled state executed!"));
          }
        },
      ),
    );
  }
}
