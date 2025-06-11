import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:sight_mate/app/injection.dart';
import 'package:sight_mate/modules/shared/i18n/i18n.dart';
import 'package:sight_mate/modules/shared/tts/domain/tts_domain.dart';
import 'package:sight_mate/modules/shared/widgets/shared_widgets.dart';
import 'package:sight_mate/modules/vqa/domain/vqa_domain.dart';
import 'package:sight_mate/modules/vqa/presentation/vqa_presentation.dart';

// a screen to display a captured image with caption and interaction options
class VqaCaptureScreen extends StatefulWidget {
  final List<int> imageBytes;
  final ui.Image image;

  const VqaCaptureScreen({
    super.key,
    required this.imageBytes,
    required this.image,
  });

  @override
  State<VqaCaptureScreen> createState() => _VqaCaptureScreenState();
}

class _VqaCaptureScreenState extends State<VqaCaptureScreen>
    with SingleTickerProviderStateMixin {
  final _vqaUsecase = VqaUsecase();
  final _ttsProvider = DI.get<TtsProvider>();

  late String _lastSpokenText;
  late TabController _tabController;
  final _numberOfTabs = 2;
  late Future<void> readyFuture;

  late List<VqaHistoryItem> _historyItems;

  @override
  void initState() {
    super.initState();

    // Initialize tabs and begin captioning task
    _tabController = TabController(length: _numberOfTabs, vsync: this);
    readyFuture = _vqaUsecase.captionImageBytes(widget.imageBytes).then((
      value,
    ) {
      if (mounted) {
        setState(() {
          _lastSpokenText = value;
          _ttsProvider.speak(_lastSpokenText);
          _historyItems = _vqaUsecase.historyItems;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> onQuestion(String question) async {
    await _ttsProvider.stop();
    await _ttsProvider.speak(L10n.current.pleaseWait);
    await _vqaUsecase
        .answerQuestionFromImageBytees(widget.imageBytes, question)
        .then((value) async {
          await _ttsProvider.stop();
          if (mounted) {
            setState(() {
              _lastSpokenText = value;
              _ttsProvider.speak(_lastSpokenText);
              _historyItems = _vqaUsecase.historyItems;
            });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: readyFuture,
      builder: (context, snapshot) {
        final isDone = snapshot.connectionState == ConnectionState.done;

        return WidgetScaffold(
          title: L10n.current.imageMode,
          withDrawer: false,
          appBarBottom: VqaCaptureScreenTabBar(tabController: _tabController),
          body: Stack(
            children: [
              // Main content split between preview and history tabs
              TabBarView(
                controller: _tabController,
                children: [
                  VqaPreviewWidget(
                    key: widget.key,
                    isCaptionReady: isDone,
                    image: widget.image,
                  ),
                  isDone
                      ? Padding(
                          padding: const EdgeInsets.only(
                            bottom: kFabSize + kFabMargin * 2,
                          ),
                          child: VqaHistoryWidget(historyItems: _historyItems),
                        )
                      : const Center(child: CircularProgressIndicator()),
                ],
              ),

              // Replay FAB
              if (isDone)
                Positioned(
                  bottom: kFabMargin,
                  left: kFabMargin,
                  child: Semantics(
                    label: L10n.current.replay,
                    button: true,
                    child: SizedBox(
                      height: kFabSize,
                      width: kFabSize,
                      child: FloatingActionButton(
                        heroTag: 'replay_fab',
                        tooltip: L10n.current.replay,
                        onPressed: () async {
                          await _ttsProvider.stop();
                          _ttsProvider.speak(_lastSpokenText);
                        },
                        child: Icon(
                          Icons.replay,
                          size: kReplayIconSize,
                          semanticLabel: L10n.current.replay,
                        ),
                      ),
                    ),
                  ),
                ),

              // Ask FAB
              if (isDone)
                Positioned(
                  bottom: kFabMargin,
                  right: kFabMargin,
                  child: Semantics(
                    label: L10n.current.askQuestion,
                    button: true,
                    child: SizedBox(
                      height: kFabSize,
                      width: kFabSize,
                      child: FloatingActionButton(
                        heroTag: 'ask_fab',
                        tooltip: L10n.current.askQuestion,
                        onPressed: () async {
                          _ttsProvider.stop();
                          showDialog(
                            context: context,
                            builder: (context) {
                              return VqaQuestionDialog(
                                handleSubmit: onQuestion,
                              );
                            },
                          );
                        },
                        child: Icon(
                          Icons.question_answer,
                          size: kAskIconSize,
                          semanticLabel: L10n.current.askQuestion,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
