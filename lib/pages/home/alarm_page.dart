import 'package:alarm_app/main.dart';
import 'package:alarm_app/providers/alarm_provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../data/constants.dart';
import '../../models/alarm_model.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  DateTime? _alarmTime;
  late String _alarmTimeString;
  bool _isRepeatSelected = false;

  @override
  void initState() {
    _alarmTime = DateTime.now();
    //alarmProvider(context). alarmHelper.deleteTable().then((value) {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) => loadAlarms());
    super.initState();
  }

  void loadAlarms() {
    Provider.of<AlarmProvider>(context, listen: false).refreshAlarms();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AlarmProvider>(
      builder: (_, alarmProvider, c) {
        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          children: [
            ...alarmProvider.alarms
                .map((alarm) => alarmItem(alarm, alarmProvider))
                .followedBy(
              [
                DottedBorder(
                  strokeWidth: 3,
                  color: CustomColors.clockOutline,
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(24),
                  child: Container(
                    padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 32, vertical: 16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: CustomColors.clockBG,
                    ),
                    child: TextButton(
                      child: Column(
                        children: [
                          Image.asset('assets/icons8-add-button-96.png',
                              scale: 2),
                          const SizedBox(height: 16),
                          Text(
                            'Add Alarm',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        _alarmTimeString =
                            DateFormat('HH:mm').format(DateTime.now());
                        showModalBottomSheet(
                          useRootNavigator: true,
                          context: context,
                          clipBehavior: Clip.antiAlias,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(24)),
                          ),
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setModalState) {
                                return Container(
                                  padding: const EdgeInsets.all(32),
                                  child: Column(
                                    children: [
                                      TextButton(
                                        onPressed: () async {
                                          var selectedTime =
                                              await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          );
                                          if (selectedTime != null) {
                                            final now = DateTime.now();
                                            var selectedDateTime = DateTime(
                                                now.year,
                                                now.month,
                                                now.day,
                                                selectedTime.hour,
                                                selectedTime.minute);
                                            _alarmTime = selectedDateTime;
                                            setModalState(() {
                                              _alarmTimeString =
                                                  DateFormat('HH:mm')
                                                      .format(selectedDateTime);
                                            });
                                          }
                                        },
                                        child: Text(
                                          _alarmTimeString,
                                          style: const TextStyle(fontSize: 32),
                                        ),
                                      ),
                                      ListTile(
                                        title: const Text('Repeat'),
                                        trailing: Switch(
                                          onChanged: (value) {
                                            setModalState(() {
                                              _isRepeatSelected = value;
                                            });
                                          },
                                          value: _isRepeatSelected,
                                        ),
                                      ),
                                      const ListTile(
                                        title: Text('Sound'),
                                        trailing: Icon(Icons.arrow_forward_ios),
                                      ),
                                      const ListTile(
                                        title: Text('Title'),
                                        trailing: Icon(Icons.arrow_forward_ios),
                                      ),
                                      FloatingActionButton.extended(
                                        onPressed: () {
                                          onSaveAlarm(
                                              alarmProvider, _isRepeatSelected);
                                        },
                                        icon: const Icon(Icons.alarm),
                                        label: const Text('Save'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget alarmItem(Alarm alarm, AlarmProvider alarmProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: alarm.gradientColors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: alarm.gradientColors.last.withOpacity(0.4),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Row(
                children: [
                  const Icon(Icons.label, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    alarm.title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const Spacer(),
              Switch(
                value: alarm.isOn,
                onChanged: (value) {
                  Provider.of<AlarmProvider>(context, listen: false)
                      .toggleAlarm(alarm);
                },
              ),
            ],
          ),

          ///
          const SizedBox(height: 8),
          Text(
            'Mon-Fri',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('hh:mm a').format(alarm.time),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
              ),
              IconButton(
                onPressed: () {
                  deleteAlarm(alarmProvider, alarm.id);
                },
                icon: const Icon(Icons.delete, color: Colors.white),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_drop_down, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  void scheduleAlarm(DateTime scheduledNotificationDateTime, Alarm alarm,
      {required bool isRepeating}) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      channelDescription: 'Scheduled Alarm Notification',
      icon: '@mipmap/ic_launcher',
      sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    );

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails(
      sound: 'a_long_cold_sting.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    if (isRepeating) {
      await flutterLocalNotificationsPlugin.periodicallyShow(
        0,
        alarm.title,
        alarm.description,
        RepeatInterval.daily,
        // notification
        // Time(
        //   scheduledNotificationDateTime.hour,
        //   scheduledNotificationDateTime.minute,
        //   scheduledNotificationDateTime.second,
        // ),
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exact,
      );
    } else {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Office',
        alarm.title,
        tz.TZDateTime.from(scheduledNotificationDateTime, tz.local),
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exact,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  void onSaveAlarm(AlarmProvider alarmProvider, bool isRepeating) {
    DateTime? scheduleAlarmDateTime;
    if (_alarmTime!.isAfter(DateTime.now())) {
      scheduleAlarmDateTime = _alarmTime;
    } else {
      scheduleAlarmDateTime = _alarmTime!.add(const Duration(days: 1));
    }

    var alarm = Alarm(
      // id: Provider.of<AlarmProvider>(context, listen: false).alarms.length + 1,
      time: scheduleAlarmDateTime!,
      gradientColors: [Colors.purple, Colors.red],
      title: "Alarm ${alarmProvider.alarms.length + 1}",
      description: 'Office',
      isOn: true,
    );
    alarmProvider.alarmHelper.insertAlarm(alarm);
    scheduleAlarm(scheduleAlarmDateTime, alarm, isRepeating: isRepeating);
    loadAlarms();
  }

  void deleteAlarm(AlarmProvider alarmProvider, int? id) {
    alarmProvider.alarmHelper.delete(id);
    loadAlarms();
  }
}
