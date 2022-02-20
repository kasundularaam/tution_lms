import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/my_colors.dart';
import '../../core/my_enums.dart';
import '../../logic/cubit/home_nav_cubit/home_nav_cubit.dart';
import '../../logic/cubit/home_tab_cubit/home_tab_cubit.dart';
import '../../logic/cubit/logout_cubit/logout_cubit.dart';
import '../router/app_router.dart';
import 'home_tabs/countdown_tab.dart';
import 'home_tabs/events_tab.dart';
import 'home_tabs/home_tab.dart';
import 'home_tabs/profile_tab.dart';
import 'widgets/bottom_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeTabCubit _homeTabCubit = HomeTabCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeNavCubit(),
      child: Scaffold(
        backgroundColor: MyColors.primaryColor,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: (constraints.maxHeight * 90) / 100,
                    child: BlocBuilder<HomeNavCubit, HomeNavState>(
                        builder: (context, state) {
                      if (state is HomeNavInitial) {
                        return BlocProvider.value(
                          value: _homeTabCubit,
                          child: const HomeTab(),
                        );
                      } else if (state is HomeScreenNavigate) {
                        if (state.homeNav == HomeNav.toHome) {
                          return BlocProvider.value(
                            value: _homeTabCubit,
                            child: const HomeTab(),
                          );
                        } else if (state.homeNav == HomeNav.toProfile) {
                          return BlocProvider(
                            create: (context) => LogoutCubit(),
                            child: const ProfileTab(),
                          );
                        } else if (state.homeNav == HomeNav.toEvents) {
                          return BlocProvider.value(
                            value: AppRouter.showCalEventsCubit,
                            child: const EventsTab(),
                          );
                        } else if (state.homeNav == HomeNav.toCountDown) {
                          return BlocProvider.value(
                            value: AppRouter.countdownTabCubit,
                            child: CountDownTab(),
                          );
                        } else {
                          return BlocProvider.value(
                            value: _homeTabCubit,
                            child: const HomeTab(),
                          );
                        }
                      } else {
                        return BlocProvider.value(
                          value: _homeTabCubit,
                          child: const HomeTab(),
                        );
                      }
                    }),
                  ),
                  BottomTab(
                    height: (constraints.maxHeight * 9) / 100,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
