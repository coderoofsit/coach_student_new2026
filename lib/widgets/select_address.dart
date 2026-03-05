import 'package:coach_student/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import '../services/api/configurl.dart';

class SelectAddress extends ConsumerWidget {
  const SelectAddress(
      {required this.textEditingController,
      this.alignment,
      this.width,
      this.controller,
      this.textStyle,
      this.obscureText = false,
      this.textInputAction = TextInputAction.next,
      this.textInputType = TextInputType.text,
      this.maxLines,
      this.hintText,
      this.hintStyle,
      this.prefix,
      this.prefixConstraints,
      this.suffix,
      this.suffixConstraints,
      this.contentPadding,
      this.borderDecoration,
      this.fillColor,
      this.filled = false,
      this.validator,
      this.readOnly = false,
      this.onTapOutside,
      this.onTap,
      this.onChanged,
      super.key});

  final TextEditingController textEditingController;
  final Alignment? alignment;

  final double? width;
  final bool readOnly;
  final TextEditingController? controller;

  final TextStyle? textStyle;

  final bool? obscureText;

  final TextInputAction? textInputAction;

  final TextInputType? textInputType;

  final int? maxLines;

  final String? hintText;

  final TextStyle? hintStyle;

  final Widget? prefix;

  final BoxConstraints? prefixConstraints;

  final Widget? suffix;

  final BoxConstraints? suffixConstraints;

  final EdgeInsets? contentPadding;

  final InputBorder? borderDecoration;

  final Color? fillColor;

  final bool? filled;
  final VoidCallback? onTap;
  final void Function(String)? onChanged;

  final FormFieldValidator<String>? validator;
  final void Function(PointerDownEvent)? onTapOutside;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GooglePlaceAutoCompleteTextField(
      textEditingController: textEditingController,
      googleAPIKey: ConfigUrl.mapApiKey,
      inputDecoration: decoration,
      debounceTime: 800,
      countries: const ["us"],
      isLatLngRequired: true,
      getPlaceDetailWithLatLng: (prediction) {
        print("Coordinates: (${prediction.lat}, ${prediction.lng})");
      },
      itemClick: (prediction) {
        textEditingController.text = prediction.description ?? '';
        textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: prediction.description?.length ?? 0),
        );
      },
      itemBuilder: (context, index, Prediction prediction) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              const Icon(Icons.location_on),
              const SizedBox(width: 7),
              Expanded(
                child: Text(prediction.description ?? ""),
              )
            ],
          ),
        );
      },
      seperatedBuilder: const Divider(),
      isCrossBtnShown: true,
    );
  }

  InputDecoration get decoration => InputDecoration(
        hintText: hintText ?? "",
        hintStyle: hintStyle ?? theme.textTheme.titleMedium,
        prefixIcon: prefix,
        prefixIconConstraints: prefixConstraints,
        suffixIcon: suffix,
        suffixIconConstraints: suffixConstraints,
        isDense: true,
        contentPadding: contentPadding ?? EdgeInsets.all(14.h),
        fillColor: fillColor,
        filled: filled,
        border: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.h),
              borderSide: BorderSide(
                color: appTheme.black900.withOpacity(0.2),
                width: 1,
              ),
            ),
        enabledBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.h),
              borderSide: BorderSide(
                color: appTheme.black900.withOpacity(0.2),
                width: 1,
              ),
            ),
        focusedBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.h),
              borderSide: BorderSide(
                color: appTheme.black900.withOpacity(0.2),
                width: 1,
              ),
            ),
      );
}
