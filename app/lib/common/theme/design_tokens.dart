import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';

/// 设计令牌 —— 全站唯一的视觉来源。
///
/// 系统只有一套固定浅色主题：[MPBrightness] 恒为 light，
/// 不允许出现 dark 变体，也不从任何用户配置读取配色。
abstract final class MPColor {
  // 主色 7 级：500 用于主按钮/FAB/选中/进度，600 悬停按下，700 深压与深底文字，
  // 100 图标底/选中行/导航选中，50 多选行/极轻分区，200-300 仅描边分割。
  static const primary50 = Color(0xFFF2F6FF);
  static const primary100 = Color(0xFFEAF0FF);
  static const primary200 = Color(0xFFD8E4FF);
  static const primary300 = Color(0xFFB9CCF5);
  static const primary = Color(0xFF4C6FFF);
  static const primary600 = Color(0xFF3A57E0);
  static const primary700 = Color(0xFF2D45C4);

  // 语义色
  static const ok = Color(0xFF12B886);
  static const warn = Color(0xFFF59E0B);
  static const danger = Color(0xFFE5484D);

  // 中性
  static const bg = Color(0xFFF4F7FA);
  static const surface = Color(0xFFFFFFFF);
  static const surface2 = Color(0xFFF8FAFC);
  static const border = Color(0xFFE7ECF2);
  static const line2 = Color(0xFFD9E2EC);

  // 文字三级
  static const ink = Color(0xFF16202C);
  static const ink2 = Color(0xFF5C6B7A);
  static const ink3 = Color(0xFF93A0AF);
}

/// 圆角五档，不得新增第六档；缺档取最近档。
abstract final class MPRadius {
  static const r8 = BorderRadius.all(Radius.circular(8));
  static const r10 = BorderRadius.all(Radius.circular(10));
  static const r12 = BorderRadius.all(Radius.circular(12));
  static const r14 = BorderRadius.all(Radius.circular(14));
  static const r18 = BorderRadius.all(Radius.circular(18));

  static const double s8 = 8;
  static const double s10 = 10;
  static const double s12 = 12;
  static const double s14 = 14;
  static const double s18 = 18;
  static const double pill = 999;
}

/// 4pt 栅格。
abstract final class MPSpace {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 10;
  static const double lg = 12;
  static const double xl = 16;
  static const double xxl = 20;
  static const double xxxl = 24;

  static const EdgeInsets page = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets card = EdgeInsets.all(16);
  static const EdgeInsets row = EdgeInsets.symmetric(horizontal: 14, vertical: 12);
}

/// 阴影只承担层级，不做装饰；同一屏幕最多两层。
abstract final class MPShadow {
  /// E1：卡片默认
  static const card = [
    BoxShadow(color: Color(0x0F101828), offset: Offset(0, 1), blurRadius: 2),
  ];

  /// 浮起：底部胶囊、FAB
  static const float = [
    BoxShadow(color: Color(0x1A101828), offset: Offset(0, 6), blurRadius: 18),
    BoxShadow(color: Color(0x0F101828), offset: Offset(0, 1), blurRadius: 2),
  ];

  /// 弹层：底部 sheet
  static const sheet = [
    BoxShadow(color: Color(0x1F101828), offset: Offset(0, -8), blurRadius: 28),
  ];
}

/// 字阶六级。颜色不写死，跟随 onSurface / ink2 令牌。
abstract final class MPType {
  static const pageTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const sectionTitle = TextStyle(
    fontSize: 15.5,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.2,
    height: 1.3,
  );

  static const itemTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.1,
    height: 1.35,
  );

  static const meta = TextStyle(
    fontSize: 12.5,
    fontWeight: FontWeight.w600,
    height: 1.35,
  );

  static const label = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.7,
    height: 1.35,
  );

  static const number = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    height: 1.3,
    fontFeatures: [FontFeature.tabularFigures()],
  );
}
