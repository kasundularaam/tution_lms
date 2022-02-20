import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/my_colors.dart';
import '../../../data/models/quiz_check_model.dart';

class CheckQuizCard extends StatelessWidget {
  final QuizCheck quizCheck;

  const CheckQuizCard({
    Key? key,
    required this.quizCheck,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool correct = false;
    if (quizCheck.checkedAnswer == quizCheck.correctAnswer) {
      correct = true;
    }
    return Column(
      children: [
        Container(
          width: 100.w,
          padding: EdgeInsets.all(5.w),
          decoration: BoxDecoration(
            color: correct ? MyColors.cAnsBgClr : MyColors.wAnsBgClr,
            border: Border.all(
                width: 0.5.w,
                color: correct ? MyColors.cAnsFgClr : MyColors.wAnsFgClr),
            borderRadius: BorderRadius.circular(5.w),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                correct ? "Correct" : "Wrong",
                style: TextStyle(
                    color: correct ? MyColors.cAnsFgClr : MyColors.wAnsFgClr,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                "${quizCheck.index.toString().padLeft(2, "0")}. "
                "${quizCheck.question}",
                style:
                    TextStyle(color: MyColors.textColorDark, fontSize: 16.sp),
              ),
              SizedBox(
                height: 2.h,
              ),
              correct
                  ? SizedBox()
                  : Column(
                      children: [
                        Text(
                          "Given Answer: ${quizCheck.checkedAnswer}",
                          style: TextStyle(
                              color: correct
                                  ? MyColors.cAnsFgClr
                                  : MyColors.wAnsFgClr,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                      ],
                    ),
              Text(
                "Correct Answer: ${quizCheck.correctAnswer}",
                style: TextStyle(
                    color: MyColors.darkColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 2.h,
        ),
      ],
    );
  }
}
