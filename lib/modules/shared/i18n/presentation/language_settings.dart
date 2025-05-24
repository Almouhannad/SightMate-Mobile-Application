import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sight_mate/modules/shared/i18n/i18n.dart';

/// Widget to select language/locale
class LanguageSettings extends StatelessWidget {
  const LanguageSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<I18nNotifier>();
    return Scaffold(
      appBar: AppBar(title: Text(L10n.current.languageSettings)),
      body:
          notifier.initialized
              ? ListView(
                children:
                    notifier.supportedLocales.map((locale) {
                      return RadioListTile<Locale>(
                        title: Text(_localeLabel(locale)),
                        value: locale,
                        groupValue: notifier.locale,
                        onChanged: (newLocale) {
                          if (newLocale != null) {
                            notifier.updateLocale(newLocale);
                          }
                        },
                      );
                    }).toList(),
              )
              : const Center(child: CircularProgressIndicator()),
    );
  }

  String _localeLabel(Locale locale) {
    // You can expand this for more locales or use a localization map
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      default:
        return locale.toString();
    }
  }
}
