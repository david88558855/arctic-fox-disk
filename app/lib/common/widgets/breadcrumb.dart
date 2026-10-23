import 'package:flutter/material.dart';

import 'package:maple_file/common/theme/design_tokens.dart';

class BreadcrumbItem extends StatelessWidget {
  final Widget child;
  final GestureTapCallback? onTap;

  const BreadcrumbItem({
    super.key,
    this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // 可点项做胶囊底，最后一级（不可点）保持透明
    final content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: onTap != null ? MPColor.surface : Colors.transparent,
        borderRadius: BorderRadius.circular(MPRadius.pill),
      ),
      child: DefaultTextStyle.merge(
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: MPColor.ink2,
        ),
        child: child,
      ),
    );
    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }
    return content;
  }
}

class Breadcrumb extends StatelessWidget {
  final Widget divider;
  final List<Widget> children;

  const Breadcrumb({
    super.key,
    this.divider = const Icon(Icons.chevron_right,
        size: 14, color: MPColor.ink3),
    required this.children,
  });

  Breadcrumb.builder({
    super.key,
    this.divider = const Icon(Icons.chevron_right,
        size: 14, color: MPColor.ink3),
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
  }) : children = List<Widget>.generate(
          itemCount,
          (i) => Builder(builder: (context) => itemBuilder(context, i)),
        );

  @override
  Widget build(BuildContext context) {
    List<Widget> items = <Widget>[];

    for (final (index, child) in children.indexed) {
      items.add(child);
      if (index < children.length - 1) {
        items.add(divider);
      }
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items,
      ),
    );
  }
}
