import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/colors_constants.dart';

class LoadingDialogWidget extends StatelessWidget {
  const LoadingDialogWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 90.w,
        width: 90.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.colorBlack.withOpacity(0.2),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: AppColors.colorWhiteHighEmp,
          ),
        ),
      ),
    );
  }
}
