import 'package:flutter/material.dart';
import 'package:sight_mate/app/injection.dart';
import 'package:sight_mate/modules/shared/asr/domain/asr_domin.dart';
import 'package:sight_mate/modules/shared/home/navigation_cmomands_handler.dart';
import 'package:sight_mate/modules/shared/i18n/data/l10n/l10n.dart';
import 'package:sight_mate/modules/shared/tts/domain/tts_domain.dart';
import 'package:sight_mate/modules/vqa/domain/models/providers/vqa_connectivity_provider.dart';
import 'package:sight_mate/modules/vqa/presentation/vqa_presentation.dart';

// UI constants
const kTextAlign = TextAlign.center;
const kIconSize = 45.0;
const kIconPadding = EdgeInsets.all(16);
const kTextHorizontalPadding = EdgeInsets.symmetric(horizontal: 24);
const kTopSpacing = SizedBox(height: 100);
const kBetweenSpacing = SizedBox(height: 24);
const kMainAxisAlignment = MainAxisAlignment.center;

class HelloWorldWidget extends StatefulWidget {
  const HelloWorldWidget({super.key});

  @override
  State<HelloWorldWidget> createState() => _HelloWorldWidgetState();
}

class _HelloWorldWidgetState extends State<HelloWorldWidget> {
  final _asrProvider = DI.get<AsrProvider>();
  final _ttsProvider = DI.get<TtsProvider>();
  final _vqaConnectivityProvider = DI.get<VqaConnectivityProvider>();
  final _commandsHandler = NavigationCommandsHandler();

  bool _isVqaAvailable = false;

  @override
  void initState() {
    super.initState();
    // Check VQA server connectivity status once at start
    _vqaConnectivityProvider.isConnected.then((value) {
      _isVqaAvailable = value;
    });
  }

  void _onRecord() {
    // Start ASR and handle the spoken command
    _asrProvider.listen((asrResult) {
      if (asrResult.isFinal) {
        final selectedMode = _commandsHandler.handleCommand(asrResult.text);

        //Handle unrecognized voice input
        if (selectedMode == null) {
          _ttsProvider.speak(L10n.current.unrecognizedMode);
          return;
        }

        // Block access to online-only mode if unavailable
        if (selectedMode.link == VqaHomeScreenRoute().link &&
            !_isVqaAvailable) {
          _ttsProvider.speak(L10n.current.unavailableMode);
          return;
        }

        // Confirm and nagivate to selected mode
        _ttsProvider.speak(L10n.current.activated(selectedMode.name));
        Navigator.of(context).pushNamed(selectedMode.link);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Larger and bold for welcome heading
    final welcomeStyle = theme.textTheme.displaySmall?.copyWith(
      fontWeight: FontWeight.bold,
    );

    // Slightly smaller for the command instruction
    final commandStyle = theme.textTheme.displaySmall?.copyWith(
      fontWeight: FontWeight.w600,
      fontSize: 30,
    );

    final primaryColor = theme.colorScheme.primary;
    final onPrimaryColor = theme.colorScheme.onPrimary;

    return Column(
      children: [
        kTopSpacing,
        Padding(
          padding: kTextHorizontalPadding,
          child: Text(
            L10n.current.helloWorld,
            textAlign: kTextAlign,
            style: welcomeStyle,
          ),
        ),
        const Spacer(),
        Column(
          mainAxisAlignment: kMainAxisAlignment,
          children: [
            Padding(
              padding: kTextHorizontalPadding,
              child: Text(
                L10n.current.selectMode,
                textAlign: kTextAlign,
                style: commandStyle,
              ),
            ),
            kBetweenSpacing,
            // Accessible mic button with semantic label
            Semantics(
              label: L10n.current.record,
              button: true,
              child: Material(
                color: primaryColor,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: _onRecord,
                  child: Padding(
                    padding: kIconPadding,
                    child: Icon(
                      Icons.mic,
                      size: kIconSize,
                      color: onPrimaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }
}
