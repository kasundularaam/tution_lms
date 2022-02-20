import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../core/constants/my_colors.dart';
import '../../core/screen_arguments/module_screen_args.dart';
import '../../core/screen_arguments/subject_screen_args.dart';
import '../../data/models/module_model.dart';
import '../../logic/cubit/module_card_cubit/module_card_cubit.dart';
import '../../logic/cubit/subject_screen_cubit/subject_screen_cubit.dart';
import '../templates/inner_scrn_tmpl.dart';
import 'widgets/module_card.dart';
import 'widgets/my_text_field.dart';

class SubjectScreen extends StatefulWidget {
  final SubjectScreenArgs args;
  const SubjectScreen({
    Key? key,
    required this.args,
  }) : super(key: key);

  @override
  _SubjectScreenState createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SubjectScreenCubit>(context)
        .loadModules(subjectId: widget.args.subjectId);
  }

  @override
  Widget build(BuildContext context) {
    return InnerScrnTmpl(
      title: widget.args.subjectName,
      content: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        children: [
          SizedBox(
            height: 3.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: MyTextField(
              onChanged: (text) => BlocProvider.of<SubjectScreenCubit>(context)
                  .loadSearchList(searchTxt: text),
              onSubmitted: (text) {},
              textInputAction: TextInputAction.search,
              isPassword: false,
              hintText: "Search Modules...",
              textColor: MyColors.textColorDark,
              bgColor: MyColors.white.withOpacity(0.7),
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          BlocConsumer<SubjectScreenCubit, SubjectScreenState>(
            listener: (context, state) {
              if (state is SubjectScreenNoResult) {
                SnackBar snackBar = SnackBar(content: Text(state.message));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else if (state is SubjectScreenFailed) {
                SnackBar snackBar = SnackBar(content: Text(state.errorMsg));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            builder: (context, state) {
              if (state is SubjectScreenLoading) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: MyColors.progressColor,
                ));
              } else if (state is SubjectScreenLoaded) {
                return ListView.builder(
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: state.moduleList.length,
                  itemBuilder: (BuildContext context, int index) {
                    Module module = state.moduleList[index];
                    return BlocProvider(
                      create: (context) => ModuleCardCubit(),
                      child: ModuleCard(
                        args: ModuleScreenArgs(
                          moduleId: module.id,
                          moduleName: module.moduleName,
                          subjectId: widget.args.subjectId,
                          subjectName: widget.args.subjectName,
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }
}
