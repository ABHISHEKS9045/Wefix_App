import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:service/Auth/LoginModelPage.dart';
import 'package:service/BottamNavigation/dashboard/dashboardModelPage.dart';
import 'package:service/common/const.dart';
import 'package:service/splashpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BottamNavigation/PDF/pdfModelPage.dart';
import 'BottamNavigation/Serach/invoicModelPage.dart';
import 'BottamNavigation/Serach/submitInvoicepage.dart';
import 'BottamNavigation/bottom_navigationmodelpage.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

String deviceToken = "";

void main(List<String> args) {
  String TAG = "main";
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('isLoggedIn');
    isLoggedIn ??= false;

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: ((context) => LoginModelPage())),
          ChangeNotifierProvider(create: ((context) => BottomnavbarModelPage())),
          ChangeNotifierProvider(create: ((context) => DashboardModelPage())),
          ChangeNotifierProvider(create: ((context) => PDFModelPage())),
          ChangeNotifierProvider(create: ((context) => invoicModelPage())),
        ],
        child: MyApp(
          isLoggedIn: isLoggedIn,
        ),
      ),
    );
  }, (error, stack) {
    debugPrint("$TAG error =============> $error");
    debugPrint("$TAG stack trace =============> $stack");
  });
}

class MyApp extends StatefulWidget {
  bool isLoggedIn = false;

  MyApp({
    required this.isLoggedIn,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "Main Navigator");

  String TAG = "_MyAppState";
  void checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(
        msg: "No internet connection",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
    } else {
      Fluttertoast.cancel();
    }
  }

  Future<void> setupInteractedMessage(BuildContext context) async {
    initialize(context);
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('$TAG Message also contained a notification =======> ${initialMessage.notification!.body}');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('$TAG Got a message whilst in the foreground!');
      debugPrint('$TAG Message data =======> ${message.data}');

      if (message.notification != null) {

        debugPrint('$TAG Message data 1 =======> ${message.data}');
        display(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

      debugPrint('$TAG On message opened app');
      debugPrint('$TAG Message data =======> ${message.data}');

      if (message.notification != null) {
        display(message);
      }
    });

    FirebaseMessaging.instance.getToken().then((String? value) {
      if(value != null) {
        debugPrint("$TAG device token =======> $value");
        deviceToken = value;
      }
    });
  }

  Future<void> initialize(BuildContext context) async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'WeFix', // id
      'High Importance Notifications', // title
      importance: Importance.high,
    );

    await FlutterLocalNotificationsPlugin().resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  }

  void display(RemoteMessage message) async {
    print(message.notification!.title);
    print(message.notification!.body);
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "WeFix",
          "High Importance Notifications",
          importance: Importance.max,
          icon: '@mipmap/ic_launcher',
          priority: Priority.high,
          color: Color.fromARGB(255, 90, 37, 248),
          channelShowBadge: true,
          enableLights: true,
          enableVibration: true,
        ),
      );

      await FlutterLocalNotificationsPlugin().show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: jsonEncode(message.data),
      );
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    setupInteractedMessage(context);

    checkInternetConnectivity();

    // Register a listener to check for connectivity changes
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        Fluttertoast.showToast(
          msg: "No internet connection",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      } else {
        Fluttertoast.cancel();
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'services',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Color.fromARGB(255, 90, 37, 248)),
          ),
        ),

        scaffoldBackgroundColor: colorWhite,

        primaryTextTheme: const TextTheme(
          displayMedium: TextStyle(
            color: Colors.black,
          ),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Colors.black,
            fontSize: 28,
            letterSpacing: 0.5,
          ),
          displayMedium: TextStyle(
            color: Colors.black,
            fontSize: 25,
            letterSpacing: 0.5,
          ),
          displaySmall: TextStyle(
            color: Colors.black,
            fontSize: 22,
            letterSpacing: 0.5,
            overflow: TextOverflow.ellipsis,
          ),
          titleLarge: TextStyle(
            color: Colors.black,
            fontSize: 17,
            letterSpacing: 0.5,
          ),
          titleMedium: TextStyle(
            color: Colors.black,
            letterSpacing: 0.5,
            fontSize: 15,
          ),
          titleSmall: TextStyle(
            color: Colors.grey,
            letterSpacing: 0.5,
            fontSize: 14,
          ),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black, size: 27),
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(),
        // '/': (context) =>   DynamicRowsWithTextFieldsAndButton(),
      },
    );
  }
}
