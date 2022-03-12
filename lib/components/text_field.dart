import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:voicewebapp/utils/app_colors.dart';

Widget textField({
  required BuildContext context,
  required double height,
  required double width,
  String? initialValue,
  bool? enableInitialValue = false,
  bool? readOnly = false,
  required String prefixText,
  required String hintText,
  // required String prefixImageName,
  required VoidCallback onTap,
  VoidCallback? onSubmit,
  required EdgeInsetsGeometry contentPadding,
  required TextStyle textStyle,
  required TextStyle hintStyle,
  required TextInputType keyBoardType,
  TextEditingController? controller,
  GlobalKey<FormState>? formKey,
  bool autofocus = false,
  TextInputAction textAction = TextInputAction.done,
  Widget? suffixIcon,
  ValueChanged<String>? onChanged,
  ValueChanged<String>? onFieldSubmitted,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(50.r),
    child: Container(
      height: height, //170.h,
      width: width, //1005.w,
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(50.r),
        color: AppColors.kffffff,
        border: Border.all(
          color: AppColors.kE2E2E2,
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.k00474E.withOpacity(0.04),
            offset: const Offset(0, 20),
            blurRadius: 50.r,
          ),
        ],
      ),

      child: Container(
        width: 825.w,
        height: 125.h,
        alignment: Alignment.centerLeft,
        child: Form(
          key: formKey,
          child: TextFormField(
            onChanged: onChanged,
            textAlignVertical: TextAlignVertical.center,
            controller: enableInitialValue! ? null : controller,
            enabled: true,
            readOnly: readOnly!,
            initialValue: enableInitialValue ? initialValue : null,
            autofocus: autofocus,
            textInputAction: textAction,
            validator: (value) {
              if (GetUtils.isNull(value)) {
                return 'Please enter a value';
              }
            },
            onFieldSubmitted: onFieldSubmitted,
            onEditingComplete: () {
              var currentFocus = FocusScope.of(context);
              currentFocus.unfocus();
            },
            textAlign: TextAlign.center,
            cursorColor: AppColors.k033660,
            style: textStyle,
            keyboardType: keyBoardType,
            decoration: InputDecoration(
              fillColor: AppColors.kffffff,
              contentPadding: contentPadding,
              suffixIcon: suffixIcon,
              filled: true,
              hintText: hintText,
              enabled: true,
              prefixIcon: const FittedBox(
                fit: BoxFit.scaleDown,
                child: Icon(
                  Icons.search,
                ),
              ),
              hintStyle: hintStyle,
              //prefixText: prefixText,
              prefixStyle: TextStyle(
                color: AppColors.k13A89E,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                fontFamily: 'Gilroy',
                fontSize: 65.sp,
              ),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              isDense: true,
            ),
          ),
        ),
      ),
    ),
  );
}
