import 'package:flutter/material.dart';
import 'package:sight_mate/modules/shared/authentication/presentation/providers/authentication_notifier.dart';
import 'package:sight_mate/modules/shared/home/home_page.dart';
import 'package:sight_mate/modules/shared/i18n/data/l10n/l10n.dart';

class WelcomeUserWidget extends StatelessWidget {
  const WelcomeUserWidget({
    super.key,
    required this.authentication,
    required this.welcomeStyle,
  });

  final AuthenticationNotifier authentication;
  final TextStyle? welcomeStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        L10n.current.helloUser(authentication.profile.firstName),
        textAlign: kTextAlign,
        style: welcomeStyle,
      ),
    );
  }
}
