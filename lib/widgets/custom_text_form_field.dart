import 'package:coach_student/core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import '../theme/theme_helper.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {Key? key,
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
      this.onChanged
      , 
      this.textCapitalization ,
        this.maxLength
      }
      
      )
      : super(
          key: key,
        );

  final Alignment? alignment;

  final double? width;

  final bool readOnly;

  final int? maxLength;
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
 final TextCapitalization? textCapitalization ;
  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: textFormFieldWidget,
          )
        : textFormFieldWidget;
  }

  Widget get textFormFieldWidget => SizedBox(
        width: width ?? double.maxFinite,
        child: TextFormField(
          // onTapOutside: (PointerDownEvent event) {
          //   FocusManager.instance.primaryFocus?.unfocus();
          // },
          // textCapitalization: o TextCapitalization.sentences,
          maxLength: maxLength ,
          onTapOutside: onTapOutside ?? (PointerDownEvent event) {
        FocusManager.instance.primaryFocus?.unfocus();
        },
          textCapitalization:textCapitalization ?? TextCapitalization.sentences ,
          controller: controller,
          onTap: onTap,
          readOnly: readOnly,
        onChanged: onChanged,
          // focusNode: focusNode ?? FocusNode(),
          // style: textStyle ?? theme.textTheme.titleMedium,
          obscureText: obscureText!,
          textInputAction: textInputAction,
          style: const TextStyle(color: Colors.black),
          keyboardType: textInputType,
          maxLines: maxLines ?? 1,
          decoration: decoration,
          validator: validator,
        ),
      );
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

/// Extension on [CustomTextFormField] to facilitate inclusion of all types of border style etc
extension TextFormFieldStyleHelper on CustomTextFormField {
  static UnderlineInputBorder get underLineBlack => UnderlineInputBorder(
        borderSide: BorderSide(
          color: appTheme.black900.withOpacity(0.1),
        ),
      );
  static OutlineInputBorder get outlineBlackTL5 => OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.h),
        borderSide: BorderSide(
          color: appTheme.black900.withOpacity(0.2),
          width: 1,
        ),
      );
  static OutlineInputBorder get fillGray => OutlineInputBorder(
        borderRadius: BorderRadius.circular(3.h),
        borderSide: BorderSide.none,
      );
}
