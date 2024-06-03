import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'clock_view.dart';

ValueNotifier<DateTime> timeNotifier = ValueNotifier<DateTime>(DateTime.now());

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DateTime>(
        valueListenable: timeNotifier,
        builder: (c, time, _) {
          var zoneString = time.timeZoneOffset.toString().split('.').first;
          var offsetSign = zoneString[0] == '-' ? '−' : '+';
          return Scaffold(
            backgroundColor: const Color(0xFF2D2F41),
            body: SafeArea(
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Container(
                      constraints: const BoxConstraints(maxWidth: 70),
                      // child: Image.asset('assets/clock.png'),
                    ),
                    VerticalDivider(
                      color: Colors.white.withOpacity(0.5),
                      thickness: 1.5,
                      width: 32,
                      endIndent: 32,
                      indent: 32,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('HH:mm:ss').format(time).toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
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
                                const Icon(Icons.language,
                                    color: Colors.white, size: 20),
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
