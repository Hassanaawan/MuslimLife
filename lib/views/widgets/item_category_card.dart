import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/colors_constants.dart';
import '../../constants/fonts_weights.dart';


class ItemCategoryCard extends StatelessWidget {
  const ItemCategoryCard({
    super.key,
    required this.iconImagePath,
    required this.title,
  });

  final String iconImagePath;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: AppColors.colorWhiteHighEmp,
          width: 1,
        ),
      ),
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(iconImagePath),
            SizedBox(
              width: 12.w,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: AppColors.colorWhiteMidEmp,
                  fontSize: 16.sp,
                  fontWeight: FontWeights.semiBold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
