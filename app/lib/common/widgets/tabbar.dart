import 'package:flutter/material.dart';

import 'package:arctic_fox_disk/common/theme/design_tokens.dart';

/// 点击回调：与旧实现（ConvexAppBar 的 GestureTapIndexCallback）签名一致，
/// 上层调用点无需改动。
typedef GestureTapIndexCallback = void Function(int index);

class CustomTab {
  final IconData icon;
  final String label;

  const CustomTab({
    required this.icon,
    required this.label,
  });
}

/// 底部浮动胶囊导航。
///
/// 自绘而不是 ConvexAppBar：胶囊与卡片语言统一，且省掉一个三方依赖的
/// 高度/凸起补偿（top: -16 那套）。对外 API 与原实现完全一致。
class CustomTabBar extends StatefulWidget {
  const CustomTabBar({
    super.key,
    this.initialIndex = 0,
    required this.items,
    this.onItemChanged,
  });

  final int initialIndex;
  final List<CustomTab> items;
  final GestureTapIndexCallback? onItemChanged;

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  late int _current = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(
        color: MPColor.surface,
        borderRadius: MPRadius.r18,
        boxShadow: MPShadow.float,
      ),
      child: Row(
        children: <Widget>[
          for (var index = 0; index < widget.items.length; index++)
            Expanded(child: _buildItem(index)),
        ],
      ),
    );
  }

  Widget _buildItem(int index) {
    final item = widget.items[index];
    final active = index == _current;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (_current == index) return;
        setState(() {
          _current = index;
        });
        widget.onItemChanged?.call(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        height: 48,
        decoration: BoxDecoration(
          color: active ? MPColor.primary100 : Colors.transparent,
          borderRadius: MPRadius.r14,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              item.icon,
              size: 22,
              color: active ? MPColor.primary : MPColor.ink3,
            ),
            const SizedBox(width: 8),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                color: active ? MPColor.primary : MPColor.ink3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
