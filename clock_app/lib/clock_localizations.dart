import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'l10n/messages_all.dart';

class ClockAppLocalizations {
  static Future<ClockAppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return ClockAppLocalizations();
    });
  }

  static ClockAppLocalizations of(BuildContext context) {
    return Localizations.of<ClockAppLocalizations>(
        context, ClockAppLocalizations);
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

  String get workingTime {
    return Intl.message(
      'Working Time',
      name: 'working_time',
      desc: '',
    );
  }

  String get noRecords {
    return Intl.message(
      'No records',
      name: 'no_records',
      desc: '',
    );
  }

  String get inOut {
    return Intl.message(
      'In - Out',
      name: 'in_out',
      desc: '',
    );
  }

  String get totalHours {
    return Intl.message(
      'Total Hours',
      name: 'total_hours',
      desc: '',
    );
  }

  String get excessHours {
    return Intl.message(
      'Excess Hours',
      name: 'excess_hours',
      desc: '',
    );
  }

  String get refresh {
    return Intl.message(
      'Refresh',
      name: 'refresh',
      desc: '',
    );
  }

  String get signOut {
    return Intl.message(
      'Sign Out',
      name: 'sign_out',
      desc: '',
    );
  }

  String get signIn {
    return Intl.message(
      'Sign In',
      name: 'sign_in',
      desc: '',
    );
  }

  String get reports {
    return Intl.message(
      'Reports',
      name: 'reports',
      desc: '',
    );
  }

  String get authenticationError {
    return Intl.message(
      'There was an authentication error!!',
      name: 'authentication_error',
      desc: '',
    );
  }

  String get authenticatingUser {
    return Intl.message(
      'Authenticating user...',
      name: 'authenticating_user',
      desc: '',
    );
  }
}

class ClockAppLocalizationsDelegate
    extends LocalizationsDelegate<ClockAppLocalizations> {
  const ClockAppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode);

  @override
  Future<ClockAppLocalizations> load(Locale locale) =>
      ClockAppLocalizations.load(locale);

  @override
  bool shouldReload(ClockAppLocalizationsDelegate old) => false;
}
