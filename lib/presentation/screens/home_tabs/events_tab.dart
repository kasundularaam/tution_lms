import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/my_colors.dart';
import '../../../data/models/cal_event_modle.dart';
import '../../../logic/cubit/show_cal_events_cubit/show_cal_events_cubit.dart';
import '../../router/app_router.dart';
import '../../templates/home_tabs_tmpl.dart';
import '../widgets/error_msg_box.dart';
import '../widgets/event_card.dart';
import '../widgets/my_text_field.dart';

class EventsTab extends StatefulWidget {
  const EventsTab({Key? key}) : super(key: key);

  @override
  _EventsTabState createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ShowCalEventsCubit>(context).loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return HomeTabsTmpl(
      title: "Events",
      action: GestureDetector(
        onTap: () => Navigator.pushNamed(context, AppRouter.newEventScreen),
        child: Icon(
          Icons.add_alert_rounded,
          color: MyColors.darkElv1,
          size: 22.sp,
        ),
      ),
      content: ListView(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        physics: const BouncingScrollPhysics(),
        children: [
          SizedBox(
            height: 10.h,
          ),
          MyTextField(
            onChanged: (text) => BlocProvider.of<ShowCalEventsCubit>(context)
                .searchEvents(searchText: text),
            onSubmitted: (text) {},
            textInputAction: TextInputAction.search,
            isPassword: false,
            hintText: "Find Events",
            textColor: MyColors.darkElv0,
            bgColor: MyColors.lightElv3,
          ),
          SizedBox(
            height: 3.h,
          ),
          BlocBuilder<ShowCalEventsCubit, ShowCalEventsState>(
            builder: (context, state) {
              if (state is ShowCalEventsLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: MyColors.primaryColor,
                  ),
                );
              } else if (state is ShowCalEventsLoaded) {
                return ListView.builder(
                  padding: const EdgeInsets.all(0),
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: state.calEvents.length,
                  itemBuilder: (BuildContext context, int index) {
                    CalEvent calEvent = state.calEvents[index];
                    return EventCard(
                        onLongPress: (eventId) {
                          showModalBottomSheet(
                              context: context,
                              builder: (bottomSheetContext) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(bottomSheetContext);
                                        BlocProvider.of<ShowCalEventsCubit>(
                                                context)
                                            .deleteEvent(eventId: eventId);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10.w),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.w, vertical: 1.2.h),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3.h),
                                            color: MyColors.primaryColor
                                                .withOpacity(0.1)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.delete_rounded,
                                              color: MyColors.red,
                                            ),
                                            SizedBox(
                                              width: 2.w,
                                            ),
                                            Text(
                                              "Delete",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: MyColors.darkColor,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                  ],
                                );
                              });
                        },
                        calEvent: calEvent);
                  },
                );
              } else {
                return const Center(
                  child: ErrorMsgBox(
                    errorMsg: "No Events Found",
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
