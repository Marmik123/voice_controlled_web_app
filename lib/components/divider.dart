import 'package:flutter/material.dart';
import 'package:voicewebapp/utils/app_colors.dart';

Divider buildDivider({
  double? leftIndent = 0,
  double? rightIndent = 0,
}) {
  return Divider(
    color: AppColors.kC4C4C4,
    indent: leftIndent!,
    thickness: 1.5,
    endIndent: rightIndent!,
    // endIndent: 2,
  );
}
