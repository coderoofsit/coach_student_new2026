
import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/view/coach/CoachClassSchedule/new_class.dart';
import 'package:coach_student/view/coach/CoachClassSchedule/client_selection_page.dart';
import 'package:coach_student/widgets/custom_app_bar_student.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/utils.dart';
import '../../../provider/map_provider.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/select_address.dart';
import 'provider/coach_schedule_provider.dart';

class LocationPickupCoachSlot extends ConsumerStatefulWidget {
  final DateTime slotDate;
  final DateTime? startTime;
  final String typeOfClass;
  final String classFeesAmount;
  final DateTime? endTime;
  final TimeZoneWithLocal selectedTimeZone;
  final String classDescription;

  const LocationPickupCoachSlot({
    required this.startTime,
    required this.endTime,
    required this.slotDate,
    required this.typeOfClass,
    required this.classFeesAmount,
    super.key,
    required this.selectedTimeZone,
    required this.classDescription,
  });

  @override
  ConsumerState<LocationPickupCoachSlot> createState() =>
      _LocationPickupCoachSlotConsumerState();
}

class _LocationPickupCoachSlotConsumerState
    extends ConsumerState<LocationPickupCoachSlot> {
  TextEditingController addressPickController = TextEditingController();
  // TextEditingController numberOfStudentSlotController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    addressPickController.dispose();
    // numberOfStudentSlotController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initMediaQueary(context);
    // logger.i("day ${Utils.formatDate(widget.slotDate)}");
    return Scaffold(
      appBar: CustomAppBarStudent(
        title: DateFormat('d  MMMM', 'en_US').format(widget.slotDate),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 24.v),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add new class location',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.fSize,
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
                SizedBox(height: 4.v),
                SelectAddress(
                  textEditingController: addressPickController,
                  hintText: "Add new Class location",
                  validator: (value) =>
                      value!.isEmpty ? "Please Enter Class location" : null,
                ),

                const Gap(15),
                // Text(
                //   'Maxmum Student',
                //   style: TextStyle(
                //     color: Colors.black,
                //     fontSize: 18.fSize,
                //     fontFamily: 'Nunito Sans',
                //     fontWeight: FontWeight.w700,
                //     height: 0,
                //   ),
                // ),
                // SizedBox(height: 4.v),
                // CustomTextFormField(
                //   // onTap: (){},
                //   controller: numberOfStudentSlotController,
                //   textInputType: TextInputType.number,
                //   onTapOutside: (val) =>
                //       FocusManager.instance.primaryFocus?.unfocus(),
                //   hintText: "Eg:- 12",
                //   validator: (value) =>
                //       value!.isEmpty ? "This Field Can't be Empty" : null,
                // ),
                SizedBox(
                  height: 150.v,
                ),
                // const Spacer(),
                if (ref.watch(mapProvider).isLoadingLatLang)
                  Utils.progressIndicator
                else if (ref.watch(coachSheduleProvider).isLoadingClassShedule)
                  Utils.progressIndicator
                else
                  CustomElevatedButton(
                    text: "Next",
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Map<String, dynamic>? latLang = await ref
                            .read(mapProvider)
                            .getLatLngFromAddress(addressPickController.text);
                        logger.i(widget.slotDate);
                        
                        // Navigate to client selection page instead of creating schedule directly
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClientSelectionPage(
                              slotDate: widget.slotDate,
                              startTime: widget.startTime,
                              endTime: widget.endTime,
                              typeOfClass: widget.typeOfClass,
                              classFeesAmount: widget.classFeesAmount,
                              selectedTimeZone: widget.selectedTimeZone,
                              classDescription: widget.classDescription,
                              locationAddress: addressPickController.text,
                              latitude: latLang?["lattitude"].toString() ?? "",
                              longitude: latLang?["longitude"].toString() ?? "",
                            ),
                          ),
                        );
                      }
                    },
                  ),

                // if (textEditingController.text.isEmpty) {
                //                   Utils.showSnackbarErrror(context, 'Please select address');
                //                   return;
                //                 }
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: CustomElevatedButton(
      //   text: "Done",
      //   onPressed: () async {
      //     if (addressPickController.text.isEmpty) {
      //       Utils.showSnackbarErrror(context, 'Please select address');
      //       return;
      //     }
      //     Map<String, dynamic>? latLang = await ref
      //         .read(mapProvider)
      //         .getLatLngFromAddress(addressPickController.text);
      //   },
      // ),
    );
  }
}
