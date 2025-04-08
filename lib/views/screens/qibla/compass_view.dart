
import 'package:Muslimlife/views/screens/qibla/qibla_qirection_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../constants/images_constants.dart';

class CompassView extends StatefulWidget {
  const CompassView({Key? key}) : super(key: key);

  @override
  State<CompassView> createState() => _CompassViewState();
}

class _CompassViewState extends State<CompassView> {
  bool hasPermission = false;
  bool cancel = false;

  Future getPermission() async {
    if (await Permission.location.serviceStatus.isEnabled) {
      var status = await Permission.location.status;
      if (status.isGranted) {
        hasPermission = true;
      } else {
        Permission.location.request().then((value) {
          setState(() {
            hasPermission = (value == PermissionStatus.granted);
          });
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppImages.backgroundImage),
                      fit: BoxFit.fill,
                    )),
                child: const QiblaDirectionScreen()
            ),
          ],
        )
    );
  }
}