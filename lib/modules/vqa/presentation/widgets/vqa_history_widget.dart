import 'package:flutter/material.dart';
import 'package:sight_mate/modules/vqa/domain/vqa_domain.dart';
import 'package:sight_mate/modules/vqa/presentation/vqa_presentation.dart';

class VqaHistoryWidget extends StatelessWidget {
  final List<VqaHistoryItem> _historyItems;

  const VqaHistoryWidget({
    super.key,
    required List<VqaHistoryItem> historyItems,
  }) : _historyItems = historyItems;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _historyItems.length,
      itemBuilder: (context, index) {
        return VqaHistoryItemWidget(item: _historyItems[index]);
      },
    );
  }
}
