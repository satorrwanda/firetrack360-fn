import 'package:flutter/cupertino.dart';

class KinyarwandaCupertinoLocalizations extends DefaultCupertinoLocalizations {
  const KinyarwandaCupertinoLocalizations();

  static const LocalizationsDelegate<CupertinoLocalizations> delegate =
      _KinyarwandaCupertinoLocalizationsDelegate();
}

class _KinyarwandaCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _KinyarwandaCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return locale.languageCode == 'rw';
  }

  @override
  Future<CupertinoLocalizations> load(Locale locale) async {
    return const KinyarwandaCupertinoLocalizations();
  }

  @override
  bool shouldReload(_KinyarwandaCupertinoLocalizationsDelegate old) => false;
}
