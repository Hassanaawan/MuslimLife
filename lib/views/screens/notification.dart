import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/notification_service.dart';

class Notification extends StatefulWidget {
  const Notification({super.key});

  @override
  State<Notification> createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  NotificationServices notificationServices = NotificationServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  notificationServices.sendNotification(
                      'this_is_a_tittle'.tr, 'this_is_a_body'.tr);
                },
                child: const Text('Send Notification')),
            ElevatedButton(
                onPressed: () async {
                  debugPrint(
                      'Notification Scheduled for ${DateTime.now().add(const Duration(minutes: 1))}');
                  await NotificationServices().zonedScheduleNotification(
                      title: 'scheduled_notification'.tr,
                      body: '${DateTime.now().add(const Duration(minutes: 1))}',
                      scheduledNotificationDateTime:
                          DateTime.now().add(const Duration(minutes: 1)));
                },
                child: Text('scheduled_notification'.tr)),
            ElevatedButton(
                onPressed: () {
                  notificationServices.stopNotifications(0);
                },
                child: Text('stop_notification'.tr)),
          ],
        ),
      ),
    );
  }
}
