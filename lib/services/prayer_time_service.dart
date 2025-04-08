import 'dart:async';

import 'package:intl/intl.dart';
import '../viewmodel/Providers/location_data_provider.dart';

class PrayerTimeService {
  static PrayerTimeService? _instance;
  Timer? _timer;

  static PrayerTimeService get instance {
    _instance ??= PrayerTimeService._internal();
    return _instance!;
  }

  PrayerTimeService._internal();

  DateTime? currentPrayerTime;
  DateTime? nextPrayerTime;
  String? currentPrayerName;

  /// Function to determine which prayer is the current one
  void determineCurrentPrayerTime(LocationDataProvider locationProvider) {
    DateTime now = DateTime.now();
    final todayPrayerTimes = locationProvider.prayerTimes![0]; // Assuming first entry is today's times

    if (now.isAfter(todayPrayerTimes.fajr) && now.isBefore(todayPrayerTimes.sunrise)) {
      currentPrayerTime = todayPrayerTimes.fajr;
      nextPrayerTime = todayPrayerTimes.sunrise;
      currentPrayerName = 'Fajr';
    } else if (now.isAfter(todayPrayerTimes.sunrise) && now.isBefore(todayPrayerTimes.dhuhr)) {
      currentPrayerTime = todayPrayerTimes.sunrise;
      nextPrayerTime = todayPrayerTimes.dhuhr;
      currentPrayerName = 'No obligatory prayer';
    } else if (now.isAfter(todayPrayerTimes.dhuhr) && now.isBefore(todayPrayerTimes.asr)) {
      currentPrayerTime = todayPrayerTimes.dhuhr;
      nextPrayerTime = todayPrayerTimes.asr;
      currentPrayerName = "Duh'r";
    } else if (now.isAfter(todayPrayerTimes.asr) && now.isBefore(todayPrayerTimes.maghrib)) {
      currentPrayerTime = todayPrayerTimes.asr;
      nextPrayerTime = todayPrayerTimes.maghrib;
      currentPrayerName = 'Asr';
    } else if (now.isAfter(todayPrayerTimes.maghrib) && now.isBefore(todayPrayerTimes.isha)) {
      currentPrayerTime = todayPrayerTimes.maghrib;
      nextPrayerTime = todayPrayerTimes.isha;
      currentPrayerName = 'Magrib';
    } else if (now.isAfter(todayPrayerTimes.isha) || now.isBefore(todayPrayerTimes.fajr)) {
      currentPrayerTime = todayPrayerTimes.isha;
      nextPrayerTime = todayPrayerTimes.fajr;
      currentPrayerName = "Isha'a";
    }
  }

  bool isCurrentTime(String prayerName) {
    return currentPrayerName == prayerName;
  }

  String getRemainingTime() {
    if (currentPrayerTime != null && nextPrayerTime != null) {
      final totalTime = nextPrayerTime!.difference(currentPrayerTime!).inMinutes;
      final elapsedTime = DateTime.now().difference(currentPrayerTime!).inMinutes;
      final remainingTime = totalTime - elapsedTime;

      /// Calculate the remaining duration with minutes and seconds
      final remainingDuration = Duration(minutes: remainingTime);
      final now = DateTime.now();
      final remainingWithSeconds = Duration(
        hours: remainingDuration.inHours,
        minutes: remainingDuration.inMinutes % 60,
        seconds: 60 - now.second,
      );

      return DateFormat('HH:mm:ss').format(DateTime(0).add(remainingWithSeconds));
    }
    return '';
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      print(getRemainingTime());
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }
}
