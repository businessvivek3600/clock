import 'package:alarm_app/data/dummyData.dart';
import 'package:alarm_app/providers/alarm_provider.dart';
import 'package:alarm_app/providers/clock_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'deep_link_servoce.dart';
import 'home_page.dart';
import 'pages/page1.dart';
import 'pages/page2.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await UniLinksService.init();

  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {});
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse? res) async {
    if (res?.payload != null) {
      debugPrint('notification payload: ${res!.payload}');
    }
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ClockProvider()),
        ChangeNotifierProvider(create: (context) => AlarmProvider()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
        ),
        navigatorKey: ContextUtility.navigatorKey,
        getPages: [
          GetPage(name: '/', page: () => const HomePage()),
          GetPage(name: '/page1', page: () => const Page1()),
          GetPage(name: '/page2', page: () => const Page2()),
        ],
        // routes: {
        //   '/': (_) => const HomePage(),
        //   '/page1': (_) => const Page1(),
        //   '/page2': (_) => const Page2(),
        // },
      ),
    );
  }
}
