import 'package:flutter/material.dart';
import 'package:sight_mate/modules/shared/authentication/presentation/authentication_presentation.dart';
import 'package:sight_mate/modules/shared/home/home_page.dart';
import 'package:sight_mate/modules/shared/i18n/data/l10n/l10n.dart';

class LoginMessageWidget extends StatelessWidget {
  const LoginMessageWidget({
    super.key,
    required this.commandStyle,
    required this.primaryColor,
    required this.authentication,
    required this.onPrimaryColor,
  });

  final TextStyle? commandStyle;
  final Color primaryColor;
  final AuthenticationNotifier authentication;
  final Color onPrimaryColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 32.0,
        right: 32.0,
      ), // margin from edges
      child: Column(
        mainAxisAlignment: kMainAxisAlignment,
        children: [
          Semantics(
            label: L10n.current.loginMessage,
            button: true,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                ),
                onPressed: () async {
                  Navigator.of(context).pushNamed(LoginPageRoute().link);
                },
                icon: Icon(Icons.login, color: onPrimaryColor, size: kIconSize),
                label: Text(
                  L10n.current.login,
                  style: commandStyle?.copyWith(
                    color: onPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
