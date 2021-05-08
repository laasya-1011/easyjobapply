import 'dart:async';

import 'package:admin_app/splash.dart';
import 'package:admin_app/src/providers/auth_provider.dart';
import 'package:admin_app/src/providers/fcm_provider.dart';
import 'package:admin_app/src/providers/job_provider.dart';
import 'package:admin_app/src/providers/profile_provider.dart';
import 'package:admin_app/src/utils/firebase_constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  initFc() async {
    NotificationSettings settings = await fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    //  print('User granted permission: ${settings.authorizationStatus}'); // restart system//ok sir

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        print(message);
        /* Navigator.pushNamed(context, '/message',
            arguments: MessageArguments(message, true)); */
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      print(message);
      if (notification != null && android != null) {
        /* flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));*/
      }
    });

    /* navigatorKey.currentState.push(MaterialPageRoute(builder: (context) => YourClassName())); */

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('A new onMessageOpenedApp event was published!');
    });
  }

  @override
  void initState() {
    initFc();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FcmProvider>(create: (_) => FcmProvider()),
        ChangeNotifierProvider<JobProvider>(create: (_) => JobProvider()),
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<ProfileProvider>(
            create: (_) => ProfileProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'admin ',
        theme: ThemeData(
          fontFamily: 'Montserrat',
          primarySwatch: Colors.blue,
        ),
        home: Splash(),
      ),
    );
  }
}
