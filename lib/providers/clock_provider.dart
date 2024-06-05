import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

ClockProvider clockProvider(BuildContext context) =>
    context.watch<ClockProvider>();

String getSelectedLabel(BuildContext context) =>
    clockProvider(context).navItems[clockProvider(context).selectedIndex].label;

class ClockProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  void updateIndex(int index) {
    _selectedIndex = index;
    navItems[_selectedIndex].isSelected = true;
    notifyListeners();
  }

  /// nav
  List<NavItem> navItems = [
    NavItem(
      label: 'Clock',
      iconPath: 'assets/icons8-clock-480.png',
      type: NavType.clock,
    ),
    NavItem(
      label: 'Alarm',
      iconPath: 'assets/icons8-alarm-100.png',
      iconSize: 50,
      type: NavType.alarm,
    ),
    NavItem(
      label: 'Timer',
      iconPath: 'assets/icons8-sand-watch-80.png',
      type: NavType.timer,
    ),
    NavItem(
      label: 'Stopwatch',
      iconPath: 'assets/icons8-stopwatch-80.png',
      type: NavType.stopwatch,
    ),
  ];

  DateTime _time = DateTime.now();

  DateTime get time => _time;

  void updateTime() {
    _time = DateTime.now();
    notifyListeners();
  }

  String get timeZoneString => _time.timeZoneOffset.toString().split('.').first;

  String get offsetSign => timeZoneString[0] == '-' ? '−' : '+';

  Color get backgroundColor => const Color(0xFF2D2F41);

  Color get dividerColor => Colors.white.withOpacity(0.5);

  Color get secHandColor => const Color(0xFFFF5C5C);

  List<Color> get minHandColors => const [Color(0xFF748EF6), Color(0xFF77DDFF)];

  List<Color> get hourHandColors =>
      const [Color(0xFFEA74AB), Color(0xFFC279FB)];

  Color get shadowColor => const Color(0xFFDADFF0);

  Color get clockBgColor => const Color(0xFF444974);

  Color get clockOutlineColor => const Color(0xFFEAECFF);

  Color get clockCenterColor => const Color(0xFFEAECFF);

  Color get clockNumberColor => const Color(0xFFD9DBF3);

  Color get clockHandColor => const Color(0xFFEA74AB);

  TextStyle get clockTextStyle =>
      const TextStyle(color: Color(0xFFD9DBF3), fontSize: 20);

  TextStyle get timeZoneTextStyle =>
      const TextStyle(color: Color(0xFFD9DBF3), fontSize: 16);

  TextStyle get timeZoneLabelTextStyle =>
      const TextStyle(color: Color(0xFFA1A4B2), fontSize: 16);

  TextStyle get navTextStyle =>
      const TextStyle(color: Color(0xFFE1E3F7), fontSize: 20);

  TextStyle get navSelectedTextStyle =>
      const TextStyle(color: Color(0xFF748EF6), fontSize: 20);

  TextStyle get navUnselectedTextStyle =>
      const TextStyle(color: Color(0xFFA1A4B2), fontSize: 20);
}

class NavItem {
  final String label;
  final String iconPath;
  final double iconSize;
  bool isSelected;
  final NavType type;

  NavItem({
    required this.type,
    required this.label,
    required this.iconPath,
    this.iconSize = 35,
    this.isSelected = false,
  });
}

enum NavType { clock, alarm, timer, stopwatch }
