// import 'package:get/get.dart';
// import 'dart:async';
//
// class PrayerTimeController extends GetxController {
//   Timer? _timer;
//   int remainingTime = 0;
//   String formattedTime = '';
//
//   @override
//   void onClose() {
//     _timer?.cancel();
//     super.onClose();
//   }
//
//   // Method to start the countdown timer
//   void startTimer(DateTime currentPrayerTime, DateTime nextPrayerTime) {
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       int totalTime = nextPrayerTime.difference(currentPrayerTime).inMinutes;
//       int elapsedTime = DateTime.now().difference(currentPrayerTime).inMinutes;
//       remainingTime = totalTime - elapsedTime;
//
//       // Format the time
//       final remainingDuration = Duration(minutes: remainingTime);
//       formattedTime = formatDuration(remainingDuration);
//
//       // Notify listeners to rebuild UI
//       update();
//     });
//   }
//
//   // Method to format the duration into HH:MM:SS
//   String formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final hours = twoDigits(duration.inHours);
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     return "$hours:$minutes:$seconds";
//   }
// }
