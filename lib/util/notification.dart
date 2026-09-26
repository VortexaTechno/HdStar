import 'package:ahlachat/view/Screans/MainScreans/MessageScrean/MessageScrean.dart';
import 'package:ahlachat/viewmodels/InboxRooms_Viewmodel/InboxRoomsViewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../main.dart';

class LocalNotificationService {
  LocalNotificationService();

  final FlutterLocalNotificationsPlugin _localNotificationService =
  FlutterLocalNotificationsPlugin();

  final BehaviorSubject<String?> onNotificationClick =
  BehaviorSubject<String?>();

  // ============================================================
  // INITIALIZE
  // ============================================================

  Future<void> intialize() async {
    // Initialize timezone database
    tz.initializeTimeZones();

    // Android initialization
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@drawable/background');

    // Initialization settings
    const InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
    );

    // Initialize notifications
    await _localNotificationService.initialize(
     settings:  settings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    // Android 13+ notification permission
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
    _localNotificationService
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();
  }

  // ============================================================
  // NOTIFICATION CLICK
  // ============================================================

  Future<void> _onDidReceiveNotificationResponse(
      NotificationResponse response,
      ) async {
    final String? payload = response.payload;

    print('======================================');
    print('Notification clicked');
    print('Payload: $payload');
    print('======================================');

    if (payload != null) {
      onNotificationClick.add(payload);
    }

    await _handleNotificationPayload(payload);
  }

  // ============================================================
  // HANDLE PAYLOAD
  // ============================================================

  Future<void> _handleNotificationPayload(String? payload) async {
    if (payload == null || payload.isEmpty) {
      return;
    }

    final BuildContext? context =
        NavigationService.navigatorKey.currentContext;

    if (context == null) {
      print('Navigation context is null');
      return;
    }

    // ==========================================================
    // PAYLOAD = 1
    // Open Inbox / Messages
    // ==========================================================

    if (payload == '1') {
      final InboxroomViewModel inboxRoomViewModel =
      Provider.of<InboxroomViewModel>(
        context,
        listen: false,
      );

      await inboxRoomViewModel.GetInboxroom(
        context: context,
      );

      if (!context.mounted) {
        return;
      }

      await showModalBottomSheet(
        backgroundColor: Colors.white,
        isScrollControlled: false,
        barrierColor: Colors.black.withAlpha(1),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (context) {
          return MessageScrean();
        },
      );
    }

    // ==========================================================
    // PAYLOAD = 2
    // ==========================================================

    else if (payload == '2') {
      print('Notification payload = 2');
    }
  }

  // ============================================================
  // NOTIFICATION DETAILS
  // ============================================================

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'description',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
    );

    return const NotificationDetails(
      android: androidNotificationDetails,
    );
  }

  // ============================================================
  // SHOW NOTIFICATION
  // ============================================================

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final NotificationDetails details = await _notificationDetails();

    await _localNotificationService.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
      payload: id.toString(),
    );
  }

  // ============================================================
  // SCHEDULE NOTIFICATION
  // ============================================================

  Future<void> showScheduledNotification({
    required int id,
    required String title,
    required String body,
    required int seconds,
  }) async {
    final NotificationDetails details = await _notificationDetails();

    final tz.TZDateTime scheduledDate =
    tz.TZDateTime.now(tz.local).add(
      Duration(seconds: seconds),
    );

    await _localNotificationService.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: details,
      androidScheduleMode:
      AndroidScheduleMode.exactAllowWhileIdle,
      payload: id.toString(),
    );
  }

  // ============================================================
  // SHOW NOTIFICATION WITH CUSTOM PAYLOAD
  // ============================================================

  Future<void> showNotificationWithPayload({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    final NotificationDetails details = await _notificationDetails();

    await _localNotificationService.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }

  // ============================================================
  // OLD iOS CALLBACK
  // ============================================================

  void onDidReceiveLocalNotification(
      int id,
      String? title,
      String? body,
      String? payload,
      ) {
    print('Local notification received');
    print('id: $id');
    print('title: $title');
    print('body: $body');
    print('payload: $payload');
  }

  // ============================================================
  // CANCEL ONE NOTIFICATION
  // ============================================================

  Future<void> cancelNotification(int id) async {
    await _localNotificationService.cancel(id: id);
  }

  // ============================================================
  // CANCEL ALL NOTIFICATIONS
  // ============================================================

  Future<void> cancelAllNotifications() async {
    await _localNotificationService.cancelAll();
  }

  // ============================================================
  // GET ACTIVE NOTIFICATIONS
  // ============================================================

  Future<List<ActiveNotification>> getActiveNotifications() async {
    return await _localNotificationService.getActiveNotifications();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  void dispose() {
    onNotificationClick.close();
  }
}