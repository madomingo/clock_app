import 'package:clock_app/working_month_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/messages_all.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (BuildContext context) => ClockAppLocalizations.of(context).title,
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        const ClockAppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'), // English
        const Locale('es', 'ES'), // Spanish
        // ... other locales the app supports
      ],
      title: 'Clock In & Out app',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: ClockApp()
    );
  }
}

class ClockApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(ClockAppLocalizations.of(context).title),
        ),
        body: Center(
          child: WorkingMonthPage(), // ... this highlighted text
        ),
      );
  }
}

class ClockAppLocalizations {
  static Future<ClockAppLocalizations> load(Locale locale) {
    final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return ClockAppLocalizations();
    });
  }

  static ClockAppLocalizations of(BuildContext context) {
    return Localizations.of<ClockAppLocalizations>(context, ClockAppLocalizations);
  }

  String get title {
    return Intl.message(
      'Clock In & Out',
      name: 'title',
      desc: 'Title for the Demo application',
    );
  }
}

class ClockAppLocalizationsDelegate extends LocalizationsDelegate<ClockAppLocalizations> {
  const ClockAppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode);

  @override
  Future<ClockAppLocalizations> load(Locale locale) => ClockAppLocalizations.load(locale);

  @override
  bool shouldReload(ClockAppLocalizationsDelegate old) => false;
}

