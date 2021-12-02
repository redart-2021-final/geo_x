import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_x/forms/login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/static_variable.dart';

void main() => runApp(MyApp());

class FallbackCupertinoLocalisationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Проверка чеков',
      supportedLocales: [
        const Locale('en', ''),
        const Locale('ru', ''),
      ],
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        FallbackCupertinoLocalisationsDelegate()
      ],
      theme: ThemeData(
        primarySwatch: MaterialColor(
          0xFF7fd0fd,
          <int, Color>{
            50: Color(0xFFdbf2fe),
            100: Color(0xFFceedfe),
            200: Color(0xFFc5eafe),
            300: Color(0xFFbfe8fe),
            400: Color(0xFFb9e5fe),
            500: Color(0xFFaee1fe),
            600: Color(0xFFa5defe),
            700: Color(0xFF94d8fd),
            800: Color(0xFF87d3fd),
            900: Color(0xFF7fd0fd),
          },
        ),
      ),
      home: LoginPage(),
    );
  }
}
