import 'dart:developer';

import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/core/utils/utils.dart';
import 'package:coach_student/models/coach_model/StudentListClientModel.dart';
import 'package:coach_student/provider/coach/class_coach_details_provider.dart';
import 'package:coach_student/view/coach/CoachClassSchedule/new_class.dart';
import 'package:coach_student/view/coach/CoachClassSchedule/provider/coach_schedule_provider.dart';
import 'package:coach_student/widgets/custom_app_bar_student.dart';
import 'package:coach_student/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class ClientSelectionPage extends ConsumerStatefulWidget {
  final DateTime slotDate;
  final DateTime? startTime;
  final String typeOfClass;
  final String classFeesAmount;
  final DateTime? endTime;
  final TimeZoneWithLocal selectedTimeZone;
  final String classDescription;
  final String locationAddress;
  final String latitude;
  final String longitude;

  const ClientSelectionPage({
    required this.startTime,
    required this.endTime,
    required this.slotDate,
    required this.typeOfClass,
    required this.classFeesAmount,
    super.key,
    required this.selectedTimeZone,
    required this.classDescription,
    required this.locationAddress,
    required this.latitude,
    required this.longitude,
  });

  @override
  ConsumerState<ClientSelectionPage> createState() =>
      _ClientSelectionPageConsumerState();
}

class _ClientSelectionPageConsumerState
    extends ConsumerState<ClientSelectionPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = ref.read(classDetailsCoachNotifier);
      // Reset all client selections before fetching
      for (var client in provider.studentListClientModel.clients) {
        client.isSelected = false;
      }
      provider.fetchMyStudent(context);
    });
  }

  void _toggleClientSelection(int index) {
    final provider = ref.read(classDetailsCoachNotifier);
    final currentValue = provider.studentListClientModel.clients[index].isSelected;
    provider.updateStudentListIsSelected(value: !currentValue, index: index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    initMediaQueary(context);
    final StudentListClientModel studentListClientModel = ref.watch(
      classDetailsCoachNotifier.select((value) => value.studentListClientModel),
    );
    final bool isLoading = ref.watch(
      classDetailsCoachNotifier.select((value) => value.isLoadingStudentList),
    );

    final int selectedCount = studentListClientModel.clients
        .where((client) => client.isSelected)
        .length;

    final bool areAllSelected = ref.watch(
      classDetailsCoachNotifier.select((value) => value.areAllStudentsInListSelected),
    );

    final bool isCreatingSchedule = ref.watch(
      coachSheduleProvider.select((value) => value.isLoadingClassShedule),
    );

    return Scaffold(
      appBar: const CustomAppBarStudent(
        title: "Select Clients",
      ),
      body: isLoading
          ? Utils.progressIndicator
          : studentListClientModel.clients.isEmpty
              ? Center(
                  child: Text(
                    "No clients available",
                    style: CustomTextStyles.titleLargeBold,
                  ),
                )
              : Column(
                  children: [
                    // Select All checkbox
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 10.v),
                      child: Row(
                        children: [
                          Checkbox(
                            value: areAllSelected,
                            side: const BorderSide(),
                            fillColor: WidgetStateProperty.all(
                                areAllSelected
                                    ? theme.primaryColor
                                    : Colors.white),
                            checkColor: Colors.white,
                            onChanged: (val) {
                              if (val != null) {
                                ref
                                    .read(classDetailsCoachNotifier)
                                    .selectAllStudentsInList(selectAll: val);
                              }
                            },
                          ),
                          const Gap(8),
                          const Text(
                            "Select All",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Nunito Sans',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24.h, vertical: 10.v),
                        child: ListView.separated(
                          separatorBuilder: (_, index) => SizedBox(
                            height: 10.v,
                          ),
                          itemCount: studentListClientModel.clients.length,
                          itemBuilder: (context, index) {
                            final Client client =
                                studentListClientModel.clients[index];

                            return GestureDetector(
                              onTap: () {
                                _toggleClientSelection(index);
                              },
                              child: Container(
                                height: 95.v,
                                alignment: Alignment.center,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  shadows: const [
                                    BoxShadow(
                                      color: Color(0x0C000000),
                                      blurRadius: 10,
                                      offset: Offset(2, 2),
                                      spreadRadius: 0,
                                    ),
                                    BoxShadow(
                                      color: Color(0x0C000000),
                                      blurRadius: 10,
                                      offset: Offset(-2, -2),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.h, vertical: 5.v),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                    CustomImageView(
                                      imagePath: client.image?.url ??
                                          imageUrlDummyProfile,
                                      height: 50.adaptSize,
                                      width: 50.adaptSize,
                                      fit: BoxFit.cover,
                                      radius: BorderRadius.circular(
                                        25.h,
                                      ),
                                      alignment: Alignment.center,
                                    ),
                                    const Gap(10),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            client.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Nunito Sans',
                                              fontWeight: FontWeight.w700,
                                              height: 0,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 4.v),
                                          Text(
                                            '${client.gender} - ${client.age} years',
                                            style: TextStyle(
                                              color: Colors.black
                                                  .withOpacity(0.6000000238418579),
                                              fontSize: 12,
                                              fontFamily: 'Nunito Sans',
                                              fontWeight: FontWeight.w600,
                                              height: 0,
                                            ),
                                          ),
                                          SizedBox(height: 4.v),
                                          Row(
                                            children: [
                                              CustomImageView(
                                                imagePath:
                                                    ImageConstant.coinImage,
                                                height: 15.adaptSize,
                                                width: 15.adaptSize,
                                              ),
                                              SizedBox(width: 4.h),
                                              Text(
                                                "Credits: ${client.credits} | Tokens: ${client.token}",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'Nunito Sans',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 48.h,
                                      height: 48.v,
                                      child: Center(
                                        child: Checkbox(
                                          value: client.isSelected,
                                          side: const BorderSide(),
                                          fillColor: WidgetStateProperty.resolveWith((states) {
                                            if (client.isSelected) {
                                              return theme.primaryColor;
                                            }
                                            return Colors.white;
                                          }),
                                          checkColor: Colors.white,
                                          onChanged: (val) {
                                            if (val != null) {
                                              _toggleClientSelection(index);
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            );
                          },
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.h, vertical: 10.v),
                        child: Column(
                          children: [
                            if (selectedCount > 0)
                              Padding(
                                padding: EdgeInsets.only(bottom: 10.v),
                                child: Text(
                                  '$selectedCount client${selectedCount > 1 ? 's' : ''} selected',
                                  style: CustomTextStyles.titleSmallBlack900,
                                ),
                              ),
                            CustomElevatedButton(
                              text: isCreatingSchedule ? "Creating..." : "Create Schedule",
                              isDisabled: isCreatingSchedule,
                              rightIcon: isCreatingSchedule
                                  ? Padding(
                                      padding: EdgeInsets.only(left: 8.h),
                                      child: SizedBox(
                                        width: 16.h,
                                        height: 16.v,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  : null,
                              onPressed: isCreatingSchedule
                                  ? null
                                  : () {
                                      final selectedClients = studentListClientModel
                                          .clients
                                          .where((client) => client.isSelected)
                                          .toList();

                                      // Create participant objects with id, type, and parentId
                                      List<Map<String, dynamic>> participants =
                                          selectedClients.map((client) {
                                        final bool hasParent = client.parent != null && client.parent!.isNotEmpty;
                                        return {
                                          "id": client.id,
                                          "type": hasParent ? "children" : "student",
                                          "parentId": hasParent ? client.parent : null,
                                        };
                                      }).toList();

                                      log("Selected participants: $participants");

                                      ref.read(coachSheduleProvider).classShedulePost(
                                            context,
                                            selectedTimeZone: widget.selectedTimeZone,
                                            classDescription: widget.classDescription,
                                            classFeesAmount: widget.classFeesAmount,
                                            typeOfClass: widget.typeOfClass,
                                            day: widget.slotDate,
                                            startTime: widget.startTime,
                                            endTime: widget.endTime,
                                            locationAddress: widget.locationAddress,
                                            maxStudent: "0",
                                            latitude: widget.latitude,
                                            longitude: widget.longitude,
                                            participants: participants,
                                          );
                                    },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}

