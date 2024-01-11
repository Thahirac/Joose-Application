/*
import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:joosecustomer/pages/dash_board.dart';
import 'package:joosecustomer/pages/notification_list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Fcmnotification extends StatefulWidget {
  String? title, body, pid, quantity, size, color;
  int? price;
  bool? single;

  Fcmnotification(
      {this.title,
        this.body,
        this.pid,
        this.color,
        this.single,
        this.size,
        this.price,
        this.quantity,
     });

  @override
  _FcmnotificationState createState() => _FcmnotificationState();
}

class _FcmnotificationState extends State<Fcmnotification>
    with WidgetsBindingObserver {

  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String? tokens;
  //File images;
  int? type;
  ScrollController _scrollController = ScrollController();
  ScrollController _scrollController1 = ScrollController();
  SharedPreferences? sharedPreferences;
  var img;
  String? pusnot;
  String? msg;
  int? cutOffPrice = 0, initialPrice = 0;
  bool isLoading = true;
  String? token = '';
  TextEditingController messageTextEditController = TextEditingController();
  TextEditingController makenoffercontroller = TextEditingController();
  String? groupid;



  AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      // description
      importance: Importance.high,
      playSound: true);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    print('A bg message just showed up :  ${message.messageId}');
  }

  Future<void> notf() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    await FirebaseMessaging.instance.getToken().then((token) {
      tokens = token;

      // Print the Token in Console
    });
  }

  @override
  void initState() {
    super.initState();
    notf();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Message data...chat...: ${message.data}');
      groupid = message.data['group'];
      print("groupidremote.....$groupid");
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      AppleNotification? notificationDetails = message.notification?.apple;
      if (notification != null &&
          (android != null || notificationDetails != null)) {

        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  color: Colors.blue,
                  playSound: true,
                  icon: '@mipmap/ic_launcher',
                ),
                iOS: IOSNotificationDetails()));

        pusnot = notification.body!;

      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      AppleNotification? notificationDetails = message.notification?.apple;
      if (notification != null &&
          (android != null || notificationDetails != null)) {
       Navigator.push(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      }
    });


  }



  @override
  Widget build(BuildContext context) {

    return Container();
  }

}
*/
