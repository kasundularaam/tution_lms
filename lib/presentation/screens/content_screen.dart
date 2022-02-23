import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../core/constants/my_colors.dart';
import '../../core/screen_arguments/add_eve_to_con_scrn_args.dart';
import '../../core/screen_arguments/content_screen_args.dart';
import '../../logic/cubit/download_pdf_cubit/download_pdf_cubit.dart';
import '../router/app_router.dart';
import '../templates/inner_scrn_tmpl.dart';
import 'widgets/big_btn.dart';
import 'widgets/small_btn.dart';

class ContentScreen extends StatefulWidget {
  final ContentScreenArgs args;
  const ContentScreen({
    Key? key,
    required this.args,
  }) : super(key: key);

  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  @override
  Widget build(BuildContext context) {
    return InnerScrnTmpl(
      title: widget.args.contentName,
      content: ListView(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        physics: const BouncingScrollPhysics(),
        children: [
          SizedBox(
            height: 2.h,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                    text: "Subject: ",
                    style: TextStyle(
                        color: MyColors.darkElv0,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600),
                    children: [
                      TextSpan(
                        text: widget.args.subjectName,
                        style: TextStyle(
                          color: MyColors.primaryDarkColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ]),
              ),
              SizedBox(
                height: 2.h,
              ),
              RichText(
                text: TextSpan(
                    text: "Module: ",
                    style: TextStyle(
                        color: MyColors.darkElv0,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600),
                    children: [
                      TextSpan(
                        text: widget.args.moduleName,
                        style: TextStyle(
                          color: MyColors.primaryDarkColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ]),
              ),
            ],
          ),
          SizedBox(
            height: 2.h,
          ),
          Divider(
            color: MyColors.darkElv1,
            thickness: 0.2.w,
          ),
          SizedBox(
            height: 2.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Download content",
                style: TextStyle(
                  color: MyColors.darkElv1,
                  fontSize: 14.sp,
                ),
              ),
              BlocConsumer<DownloadPdfCubit, DownloadPdfState>(
                listener: (context, state) {
                  if (state is DownloadPdfFailed) {
                    SnackBar snackBar = SnackBar(content: Text(state.errorMsg));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                builder: (context, state) {
                  if (state is DownloadPdfLoading) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: MyColors.primaryColor,
                    ));
                  } else {
                    return SmallBtn(
                      btnText: "Download",
                      onPressed: () =>
                          BlocProvider.of<DownloadPdfCubit>(context)
                              .downloadPdf(
                                  moduleId: widget.args.moduleId,
                                  contentId: widget.args.contentId),
                      bgColor: MyColors.primaryDarkColor,
                      txtColor: MyColors.lightColor,
                    );
                  }
                },
              ),
            ],
          ),
          SizedBox(
            height: 3.h,
          ),
          Divider(
            color: MyColors.darkElv1,
            thickness: 0.2.w,
          ),
          SizedBox(
            height: 3.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Add schedule to work later",
                style: TextStyle(
                  color: MyColors.darkElv1,
                  fontSize: 14.sp,
                ),
              ),
              SmallBtn(
                  btnText: "Add",
                  onPressed: () => Navigator.pushNamed(
                        context,
                        AppRouter.addEventToConScreen,
                        arguments: AddEveToConScrnArgs(
                            subjectId: widget.args.subjectId,
                            subjectName: widget.args.subjectName,
                            moduleId: widget.args.moduleId,
                            moduleName: widget.args.moduleName,
                            contentId: widget.args.contentId,
                            contentName: widget.args.contentName),
                      ),
                  bgColor: MyColors.primaryDarkColor,
                  txtColor: MyColors.lightColor),
            ],
          ),
          SizedBox(
            height: 3.h,
          ),
          Divider(
            color: MyColors.darkElv1,
            thickness: 0.2.w,
          ),
          SizedBox(
            height: 3.h,
          ),
          Text(
            "Start working right now",
            style: TextStyle(
              color: MyColors.darkElv1,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          BigBtn(
              btnText: "Let's Go",
              onPressed: () => Navigator.pushNamed(
                    context,
                    AppRouter.workingScreen,
                    arguments: widget.args,
                  ),
              bgColor: MyColors.primaryColor,
              txtColor: MyColors.primaryDarkColor),
        ],
      ),
    );
  }
}
