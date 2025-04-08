import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../constants/images_constants.dart';
import '../../viewmodel/providers/hadith_provider.dart';
import '../../viewmodel/providers/user_data_provider.dart';
import '../../viewmodel/providers/wallpaper_data_provider.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  late GeolocatorPlatform _geolocator;
  late LocationPermission _permission;

  _getLocationPermission() async {
    _permission = await _geolocator.checkPermission();
    if (_permission == LocationPermission.denied) {
      _permission = await _geolocator.requestPermission();
      if (_permission != LocationPermission.whileInUse &&
          _permission != LocationPermission.always) {
        _permission = await _geolocator.requestPermission();
      }
    }
    if (_permission == LocationPermission.deniedForever) {
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _geolocator = GeolocatorPlatform.instance;
    _getLocationPermission();
    //Method for getting location and update prayer time
    //Provider.of<LocationProvider>(context, listen: false).getLocation();
    Provider.of<HadithProvider>(context, listen: false).fetchAllHadithData();
    Provider.of<HadithProvider>(context, listen: false).fetchAllDuaData();
    Provider.of<UserDataProvider>(context, listen: false).fetchAllCurrencyData();
    Provider.of<WallpaperDataProvider>(context, listen: false).fetchAllWallpapers();
    Provider.of<HadithProvider>(context, listen: false).getLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppImages.splashBackgroundPNG,
      fit: BoxFit.cover,
    );
  }
}
