import 'dart:developer';

import 'package:alarm_app/pages/home/alarm_page.dart';
import 'package:alarm_app/pages/home/stop_watch_page.dart';
import 'package:alarm_app/pages/home/timer_page.dart';
import 'package:alarm_app/pages/page1.dart';
import 'package:alarm_app/pages/page2.dart';
import 'package:alarm_app/providers/clock_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

import 'pages/home/clock_view.dart';

ValueNotifier<DateTime> timeNotifier = ValueNotifier<DateTime>(DateTime.now());

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Widget getNavIcon(String iconPath, {double size = 35}) =>
      Image.asset(iconPath, width: size, height: size);

  Widget getNavLabel(String label) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          label,
          textAlign: TextAlign.center,
          overflow: TextOverflow.clip,
          maxLines: 1,
        ),
      );
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DateTime>(
        valueListenable: timeNotifier,
        builder: (c, time, _) {
          var zoneString = time.timeZoneOffset.toString().split('.').first;
          var offsetSign = zoneString[0] == '-' ? '−' : '+';
          return Consumer<ClockProvider>(builder: (_, clockProvider, c) {
            return Scaffold(
              backgroundColor: const Color(0xFF2D2F41),
              body: Row(
                children: [
                  nav(context),
                  VerticalDivider(
                      color: Colors.white.withOpacity(0.5), thickness: 1.5),
                  Expanded(
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            getSelectedLabel(context),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                              child: clockProvider.selectedIndex == 0
                                  ? clockUi(
                                      time, context, offsetSign, zoneString)
                                  : clockProvider.selectedIndex == 1
                                      ? const AlarmPage()
                                      : clockProvider.selectedIndex == 2
                                          ? const TimerPage()
                                          : const StopWatchPage()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  Widget nav(BuildContext context) {
    return NavigationRailTheme(
      data: NavigationRailThemeData(
        useIndicator: false,
        indicatorColor: Colors.white10,
        backgroundColor: Colors.transparent,
        unselectedLabelTextStyle: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: Colors.white70),
        selectedLabelTextStyle: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        unselectedIconTheme: const IconThemeData(color: Colors.white),
        selectedIconTheme: const IconThemeData(color: Colors.purple),
      ),
      child: NavigationRail(
        selectedIndex: clockProvider(context).selectedIndex,
        minWidth: 56,
        groupAlignment: 0.0,
        onDestinationSelected: clockProvider(context).updateIndex,
        labelType: NavigationRailLabelType.all,
        destinations: clockProvider(context)
            .navItems
            .map((e) => NavigationRailDestination(
                  icon: getNavIcon(e.iconPath, size: e.iconSize),
                  selectedIcon: getNavIcon(e.iconPath, size: e.iconSize),
                  label: getNavLabel(e.label),
                ))
            .toList(),
      ),
    );
  }

  Widget clockUi(DateTime time, BuildContext context, String offsetSign,
      String zoneString) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('HH:mm:ss').format(time).toString(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            DateFormat('EEE, d MMM').format(time),
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 32),

          /// Clock
          const FittedBox(child: ClockView()),

          /// Timezone
          const SizedBox(height: 32),
          Text(
            'Timezone',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.language, color: Colors.white, size: 20),
              const SizedBox(width: 16),
              Text(
                'UTC$offsetSign$zoneString',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

