import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../utils/exports.dart';
import 'firebase_options.dart';

Future<void> firebasemessagingBackgroundhandler(RemoteMessage message) async {
  if (kDebugMode) {
    print(message.messageId);
  }
}

// ignore: non_constant_identifier_names
Future Backgroundmessage(RemoteMessage message) async {
  print("${message.notification?.body}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(firebasemessagingBackgroundhandler);

  //instance of shared preference
  SharedPreferences pref = await SharedPreferences.getInstance();
  bool? isDark = pref.getBool("isDark") ?? false;

  runApp(MyApp(
    isDark: isDark,
  ));
}

void requespermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User Granted pormission');
  }
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print(
        'title : ${message.notification?.title}| Body: ${message.notification?.body}');
  });
}

@override
void initState() {
  requespermission();
}

class MyApp extends StatelessWidget {
  final bool isDark;
  const MyApp({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(isDark),
        ),
        ChangeNotifierProvider(
          create: (context) => SpeechProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MessageProvider(),
        ),
      ],
      child: ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(isDark),
          builder: (context, provider) {
            return MaterialApp(
              title: 'كتكوت',
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: context.watch<ThemeProvider>().currentTheme,
              home: const HomePage(),
            );
          }),
    );
  }
}
