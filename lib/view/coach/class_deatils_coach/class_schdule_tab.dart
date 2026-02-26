import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/coach_model/CoachClassDetails_model.dart';
import '../../../provider/coach/class_coach_details_provider.dart';
import 'my_classes_page/my_classes_upcomming_page.dart';
import 'my_classes_page/my_past_class_coach.dart';

class ClassscheduleCoachView extends ConsumerStatefulWidget {
  const ClassscheduleCoachView({super.key});

  @override
  ConsumerState<ClassscheduleCoachView> createState() =>
      _ClassscheduleCoachViewConsumerState();
}

class _ClassscheduleCoachViewConsumerState
    extends ConsumerState<ClassscheduleCoachView>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late TabController tabviewController;
  TabBar get _tabBar => TabBar(
        controller: tabviewController,
        isScrollable: true,
        // padding: EdgeInsets.only(left: 10.h, right: 10.h),
        tabs: [
          Tab(
            // icon: Icon(Icons.directions_car),
            child: Text(
              "Upcoming classes",
              style: TextStyle(
                fontSize: 14.fSize,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Tab(
            // icon: Icon(Icons.directions_car),
            child: Text(
              "Pending classes",
              style: TextStyle(
                fontSize: 14.fSize,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Tab(
            child: Text(
              "Past classes",
              style: TextStyle(
                fontSize: 14.fSize,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        ],
      );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    tabviewController = TabController(length: 3, vsync: this);
    // Add listener to refresh when tab changes
    tabviewController.addListener(() {
      if (tabviewController.indexIsChanging) {
        // Refresh data when switching tabs
        ref.read(classDetailsCoachNotifier).fetchClassDeatilsProvider(context);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(classDetailsCoachNotifier).fetchClassDeatilsProvider(context);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Refresh data when app comes back to foreground
    if (state == AppLifecycleState.resumed) {
      ref.read(classDetailsCoachNotifier).fetchClassDeatilsProvider(context);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    tabviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ClassDetailsCoachModel classDetailsData = ref.watch(
        classDetailsCoachNotifier
            .select((value) => value.classDetailsCoachModel));
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
            ),
          ),
          title: Text(
            'Classes',
            style: TextStyle(
              color: const Color(0xFF171327),
              fontSize: 20.fSize,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w600,
              height: 0.05,
            ),
          ),
          backgroundColor: const Color(0x0c3d6df5),
          bottom: PreferredSize(
            preferredSize: _tabBar.preferredSize,
            child: _tabBar,
          ),
        ),
        body: ref.watch(classDetailsCoachNotifier).isLoadingClassDetails
            ? Utils.progressIndicator
            : TabBarView(
                controller: tabviewController,
                children: [
                  MyClassUpcoming(
                    upcomingSchedules: classDetailsData.upcomingSchedules,
                    upcommingClassStatus: 1,
                  ),
                  MyClassUpcoming(
                    upcomingSchedules: classDetailsData.pendingSchedules,
                    upcommingClassStatus: 2,
                  ),
                  MyPastClassCoach(
                    pastSchedules: classDetailsData.pastSchedules,
                  ),
                ],
              ),
      ),
    );
  }
}
