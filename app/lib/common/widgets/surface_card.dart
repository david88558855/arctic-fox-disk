import 'package:flutter/material.dart';

import 'package:arctic_fox_disk/common/theme/design_tokens.dart';

/// 统一卡片外壳：圆角 14 + 白底 + 1px 描边 + E1 阴影。
///
/// 刻意不用 Material 的 [Card]：CardTheme 的字段名在 Flutter 小版本间改过
/// （CardTheme -> CardThemeData），这里直接用 BoxDecoration 更稳。
class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.radius = MPRadius.r14,
    this.color,
    this.showBorder = true,
    this.showShadow = true,
    this.onTap,
    this.onLongPress,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius radius;
  final Color? color;
  final bool showBorder;
  final bool showShadow;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: color ?? MPColor.surface,
      borderRadius: radius,
      border: showBorder ? Border.all(color: MPColor.border) : null,
      boxShadow: showShadow ? MPShadow.card : null,
    );

    final content = Container(
      padding: padding,
      decoration: decoration,
      child: child,
    );

    if (onTap == null && onLongPress == null) {
      return margin == null ? content : Padding(padding: margin!, child: content);
    }
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          onLongPress: onLongPress,
          child: content,
        ),
      ),
    );
  }
}
