import 'package:alarm_app/models/alarm_model.dart';

List<Alarm> dummyAlarms = [
  Alarm(
      id: 1,
      title: 'Alarm 1',
      time: DateTime.now().add(const Duration(hours: 3)),
      isOn: true),
  Alarm(
      id: 2,
      title: 'Alarm 2',
      time: DateTime.now().add(const Duration(hours: 4)),
      isOn: false),
  Alarm(
      id: 3,
      title: 'Alarm 3',
      time: DateTime.now().add(const Duration(hours: 5)),
      isOn: true),
  Alarm(
      id: 4,
      title: 'Alarm 4',
      time: DateTime.now().add(const Duration(hours: 6)),
      isOn: false),
];
