import 'package:flutter/material.dart';

class Alarm {
  int? id;
  String title;
  String? description; // Optional description
  DateTime time;
  bool isOn;
  List<Color> gradientColors;
  static const List<Color> deaultGradientColors = [Colors.purple, Colors.red];

  Alarm({
    this.id,
    required this.title,
    this.description,
    required this.time,
    required this.isOn,
    this.gradientColors = deaultGradientColors,
  });

  factory Alarm.fromJson(Map<String, dynamic> json) => Alarm(
        id: json['id'],
        title: json['title'] ?? '',
        description: json['description'], // No change here
        time: json['time'] != null
            ? DateTime.parse(json['time'])
            : DateTime(1970),
        isOn: json['isOn'] == 1,
        gradientColors: json['color1'] != null && json['color2'] != null
            ? [
                Color(json['color1']),
                Color(json['color2']),
              ]
            : deaultGradientColors,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description, // No change here
        'time': time.toIso8601String(),
        'isOn': isOn ? 1 : 0,
        'color1': gradientColors[0].value,
        'color2': gradientColors[1].value,
      };
}
