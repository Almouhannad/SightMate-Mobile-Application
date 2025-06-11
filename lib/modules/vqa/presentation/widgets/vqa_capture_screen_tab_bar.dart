import 'package:flutter/material.dart';
import 'package:sight_mate/modules/shared/i18n/i18n.dart';

class VqaCaptureScreenTabBar extends StatelessWidget {
  const VqaCaptureScreenTabBar({
    super.key,
    required TabController tabController,
  }) : _tabController = tabController;

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelColor = theme.colorScheme.onPrimary;
    final labelStyle = theme.textTheme.titleLarge!.copyWith(
      fontWeight: FontWeight.bold,
    );
    final indicatorWeight = 5.0;
    final bgColor = theme.colorScheme.primary;

    return Material(
      color: bgColor,
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        controller: _tabController,
        labelColor: labelColor,
        labelStyle: labelStyle,
        unselectedLabelColor: labelColor,
        indicatorWeight: indicatorWeight,
        tabs: [
          Tab(text: L10n.current.preview),
          Tab(text: L10n.current.history),
        ],
      ),
    );
  }
}
