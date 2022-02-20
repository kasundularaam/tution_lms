import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/my_colors.dart';
import '../../../data/models/fire_content.dart';
import '../../../logic/cubit/work_card_list_cubit/work_card_list_cubit.dart';
import 'work_card.dart';

class WorkCardList extends StatelessWidget {
  const WorkCardList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<WorkCardListCubit>(context).loadFireContentList();
    return BlocBuilder<WorkCardListCubit, WorkCardListState>(
      builder: (context, state) {
        if (state is WorkCardListLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: MyColors.primaryColor,
            ),
          );
        } else if (state is WorkCardListLoaded) {
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: state.fireContents.length,
            itemBuilder: (BuildContext context, int index) {
              FireContent fireContent = state.fireContents[index];
              return WorkCard(
                fireContent: fireContent,
                profileImage: state.profileImage,
              );
            },
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
