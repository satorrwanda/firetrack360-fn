import 'package:flutter/material.dart';
class MaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const MaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<MaterialLocalizations> load(Locale locale) {
    return DefaultMaterialLocalizations.load(locale);
  }

  @override
  bool shouldReload(MaterialLocalizationsDelegate old) => false;
}
