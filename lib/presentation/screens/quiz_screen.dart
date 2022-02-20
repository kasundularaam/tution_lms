import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/screen_arguments/quiz_screen_args.dart';
import '../../logic/cubit/quiz_check_cubit/quiz_check_cubit.dart';
import '../../logic/cubit/quiz_nav_cubit/quiz_nav_cubit.dart';
import '../../logic/cubit/quiz_screen_cubit/quiz_screen_cubit.dart';
import 'widgets/attempt_quiz_page.dart';
import 'widgets/quiz_check_page.dart';

class QuizScreen extends StatelessWidget {
  final QuizScreenArgs args;
  const QuizScreen({
    Key? key,
    required this.args,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizNavCubit, QuizNavState>(
      builder: (context, state) {
        if (state is QuizNavCheck) {
          return BlocProvider(
            create: (context) => QuizCheckCubit(),
            child: QuizCheckPage(
              quizChecks: state.quizChecks,
              args: args,
            ),
          );
        } else {
          return BlocProvider(
              create: (context) => QuizScreenCubit(),
              child: AttemptQuizPage(
                args: args,
              ));
        }
      },
    );
  }
}
