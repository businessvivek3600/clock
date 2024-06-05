import 'package:alarm_app/data/alarm_helper.dart';
import 'package:alarm_app/models/alarm_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

AlarmProvider alarmProvider(BuildContext context) =>
    context.watch<AlarmProvider>();

class AlarmProvider extends ChangeNotifier {
  final AlarmHelper _alarmHelper = AlarmHelper();
  AlarmProvider() {
    _alarmHelper.database.then((value) {
      _alarmHelper.getAlarms().then((value) {
        addAlarm(value);
      });
    });
  }
  AlarmHelper get alarmHelper => _alarmHelper;
  List<Alarm> _alarms = [];

  List<Alarm> get alarms => _alarms;

  void addAlarm(dynamic alarm) {
    if (alarm is List<Alarm>) {
      _alarms = alarm;
    } else if (alarm is Alarm) {
      _alarms.add(alarm);
    }
    notifyListeners();
  }

  void removeAlarm(Alarm alarm) {
    _alarms.remove(alarm);
    notifyListeners();
  }

  void updateAlarm(Alarm oldAlarm, Alarm newAlarm) {
    final index = _alarms.indexOf(oldAlarm);
    _alarms[index] = newAlarm;
    notifyListeners();
  }

  void toggleAlarm(Alarm alarm) {
    final index = _alarms.indexOf(alarm);
    _alarms[index].isOn = !_alarms[index].isOn;
    notifyListeners();
  }

  Future<void> refreshAlarms() async {
    final alarms = await _alarmHelper.getAlarms();
    addAlarm(alarms);
  }
}
