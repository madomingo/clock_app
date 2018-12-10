import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'l10n/messages_all.dart';

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
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
    );
  }
  String get working_time {
    return Intl.message(
      'Hours:mins',
      name: 'working_time',
      desc: '',
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