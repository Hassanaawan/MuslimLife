import 'package:Muslimlife/views/screens/wallpapers/set_background.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../constants/colors_constants.dart';
import '../../../constants/images_constants.dart';
import '../../../viewmodel/providers/wallpaper_data_provider.dart';
import '../../widgets/app_background_widget.dart';
import '../../widgets/app_bar_widget.dart';

class AllWallpapersView extends StatefulWidget {
  const AllWallpapersView({super.key});

  @override
  State<AllWallpapersView> createState() => _AllWallpapersViewState();
}

class _AllWallpapersViewState extends State<AllWallpapersView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: AppColors.colorError ,
        body: Stack(
      children: [
        AppBackgroundWidget(bgImagePath: AppImages.backgroundSolidColorSVG),
        Column(
          children: [
            AppBarWidget(
              screenTitle: "wallpaper".tr,
            ),
            Expanded(
              child: Consumer<WallpaperDataProvider>(
                builder: (context, provider, child) {
                  return GridView.builder(
                    padding: EdgeInsets.all(16.w),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of items horizontally
                      crossAxisSpacing:
                          12.0, // Spacing between items horizontally
                      mainAxisSpacing: 12.0, // Spacing between items vertically
                      childAspectRatio: 0.8,
                    ),
                    itemCount: provider.allWallpapers?.length ?? 0,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SetBackground(
                                index: index,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.colorPrimaryLight,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                provider.allWallpapers![index].thumbnailUrl,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        )
      ],
    ));
  }
}
