import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/my_colors.dart';

class LoadingContainer extends StatelessWidget {
  final double width;
  final double height;
  const LoadingContainer({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: MyColors.lightElv3,
          borderRadius: BorderRadius.circular(1.w),
        ));
  }
}
