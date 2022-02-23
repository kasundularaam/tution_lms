import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/my_colors.dart';
import '../../../core/screen_arguments/quiz_screen_args.dart';
import '../../../data/models/quiz_check_model.dart';
import '../../../logic/cubit/quiz_check_cubit/quiz_check_cubit.dart';
import '../../../logic/cubit/quiz_nav_cubit/quiz_nav_cubit.dart';
import '../../templates/inner_scrn_tmpl.dart';
import 'check_quiz_card.dart';

class QuizCheckPage extends StatelessWidget {
  final List<QuizCheck> quizChecks;
  final QuizScreenArgs args;
  const QuizCheckPage({
    Key? key,
    required this.quizChecks,
    required this.args,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<QuizCheckCubit>(context).checkQuizes(
        moduleId: args.moduleId,
        subjectId: args.subjectId,
        quizChecks: quizChecks);
    return InnerScrnTmpl(
      title: "Answers",
      subtitle: args.moduleName,
      content: BlocConsumer<QuizCheckCubit, QuizCheckState>(
        listener: (context, state) {
          if (state is QuizCheckFailed) {
            SnackBar snackBar = SnackBar(content: Text(state.errorMsg));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        builder: (context, state) {
          if (state is QuizCheckLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: MyColors.primaryColor,
              ),
            );
          } else if (state is QuizCheckSucceed) {
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                    children: [
                      SizedBox(
                        height: 3.h,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 5.w),
                        padding: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                          color: state.color,
                          borderRadius: BorderRadius.circular(5.w),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.grade,
                              style: TextStyle(
                                  color: MyColors.lightElv3,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Quiz Attempted: ${state.attempted}",
                                      style: TextStyle(
                                        color: MyColors.lightElv3,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Text(
                                      "Correct: ${state.correct}",
                                      style: TextStyle(
                                        color: MyColors.lightElv3,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.all(5.w),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: MyColors.lightElv3,
                                          width: 1.w)),
                                  child: Text(
                                    "${state.precentage}%",
                                    style: TextStyle(
                                      color: MyColors.lightElv3,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      ListView.builder(
                        itemCount: quizChecks.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        itemBuilder: (context, index) {
                          QuizCheck quizCheck = quizChecks[index];
                          return CheckQuizCard(quizCheck: quizCheck);
                        },
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => BlocProvider.of<QuizNavCubit>(context)
                      .emit(QuizNavAttempt()),
                  child: Container(
                    color: MyColors.lightElv3,
                    width: 100.w,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    child: Center(
                      child: Text(
                        "Quiz",
                        style: TextStyle(
                            color: MyColors.primaryDarkColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
