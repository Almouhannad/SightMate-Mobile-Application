import 'package:flutter/material.dart';
import 'package:sight_mate/app/injection.dart';
import 'package:sight_mate/modules/shared/authentication/presentation/authentication_presentation.dart';
import 'package:sight_mate/modules/shared/i18n/i18n.dart';
import 'package:sight_mate/modules/shared/tts/domain/tts_domain.dart';

class LogoutListTile extends StatefulWidget {
  const LogoutListTile({
    super.key,
    required this.textStyle,
    required this.authenticationNotifier,
  });

  final TextStyle textStyle;
  final AuthenticationNotifier authenticationNotifier;

  @override
  State<LogoutListTile> createState() => _LogoutListTileState();
}

class _LogoutListTileState extends State<LogoutListTile> {
  final _ttsProvider = DI.get<TtsProvider>();

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;
    return ListTile(
      leading: Icon(Icons.logout, color: errorColor),
      title: Text(
        L10n.current.logout,
        style: widget.textStyle.copyWith(color: errorColor),
      ),
      onTap: () async {
        // Ask for confirmation
        final shouldLogout = await showDialog<bool>(
          context: context,
          builder: (_) => LogoutWarningDialog(),
        );

        // Guard against using context after async gap
        if (!context.mounted) return;

        if (shouldLogout == true) {
          Navigator.of(context).pop(); // close drawer
          await widget.authenticationNotifier.logout();
          _ttsProvider.stopAndSpeak(
            L10n.current.actionDoneSuccessfully(L10n.current.logout),
          );
        }
      },
    );
  }
}

class LogoutWarningDialog extends StatefulWidget {
  const LogoutWarningDialog({super.key});

  @override
  State<LogoutWarningDialog> createState() => _LogoutWarningDialogState();
}

class _LogoutWarningDialogState extends State<LogoutWarningDialog> {
  final _ttsProvider = DI.get<TtsProvider>();
  @override
  void initState() {
    super.initState();
    _ttsProvider.stopAndSpeak(L10n.current.areYouSure(L10n.current.logout));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(
        L10n.current.confirmAction(L10n.current.logout),
        style: theme.textTheme.titleLarge!.copyWith(
          color: theme.colorScheme.error,
          fontWeight: FontWeight.bold,
          fontSize: 32,
        ),
      ),
      content: Text(
        L10n.current.areYouSure(L10n.current.logout),
        style: theme.textTheme.bodyLarge!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 26,
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        Semantics(
          label: L10n.current.cancel,
          button: true,
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              L10n.current.cancel,
              style: theme.textTheme.titleLarge!.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Semantics(
          label: L10n.current.confirmAction(L10n.current.logout),
          button: true,
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              L10n.current.logout,
              style: theme.textTheme.titleLarge!.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
