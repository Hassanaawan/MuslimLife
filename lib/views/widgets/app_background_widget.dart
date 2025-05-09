 import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBackgroundWidget extends StatelessWidget {
  const AppBackgroundWidget({
    super.key,
    required this.bgImagePath,
  });

  final String bgImagePath;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: SvgPicture.asset(
        bgImagePath,
        fit: BoxFit.cover,
      ),
    );
  }
}
