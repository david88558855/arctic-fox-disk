import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'design_tokens.dart';

/// 全站唯一主题亮度。系统深色模式下也返回浅色，不做任何切换。
const Brightness kMPBrightness = Brightness.light;

/// 主题构建器。
///
/// 刻意不使用 `FlexThemeData`：配色必须只由 [MPColor] 决定，
/// 不能存在任何"换一套 scheme 就换一套界面色"的入口。
/// `flex_color_scheme` 依赖仅保留给「文件图标颜色」功能使用。
abstract final class MPTheme {
  static ThemeData light({String? fontFamily}) {
    final scheme = ColorScheme.fromSeed(
      seedColor: MPColor.primary,
      brightness: kMPBrightness,
    ).copyWith(
      primary: MPColor.primary,
      onPrimary: Colors.white,
      primaryContainer: MPColor.primary100,
      onPrimaryContainer: MPColor.primary700,
      secondary: MPColor.primary600,
      onSecondary: Colors.white,
      error: MPColor.danger,
      onError: Colors.white,
      surface: MPColor.surface,
      onSurface: MPColor.ink,
      onSurfaceVariant: MPColor.ink2,
      outline: MPColor.line2,
      outlineVariant: MPColor.border,
      surfaceContainerLowest: MPColor.surface,
      surfaceContainerLow: MPColor.surface2,
      surfaceContainer: MPColor.surface2,
      surfaceContainerHigh: MPColor.surface,
    );

    const baseText = TextTheme(
      headlineSmall: MPType.pageTitle,
      titleLarge: MPType.sectionTitle,
      titleMedium: MPType.sectionTitle,
      titleSmall: MPType.itemTitle,
      bodyLarge: MPType.itemTitle,
      bodyMedium: MPType.itemTitle,
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: MPColor.ink2,
      ),
      labelLarge: MPType.itemTitle,
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: MPColor.ink2,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.7,
        color: MPColor.ink3,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: kMPBrightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: MPColor.bg,
      canvasColor: MPColor.bg,
      fontFamily: fontFamily,
      textTheme: fontFamily == null ? baseText : baseText.apply(fontFamily: fontFamily),
      // 固定浅色后必须显式声明状态栏为深色字，否则系统深色模式下白字压浅底不可见
      appBarTheme: const AppBarTheme(
        backgroundColor: MPColor.bg,
        surfaceTintColor: Colors.transparent,
        foregroundColor: MPColor.ink,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: MPColor.bg,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        titleTextStyle: MPType.sectionTitle,
        iconTheme: IconThemeData(color: MPColor.ink, size: 22),
      ),
      iconTheme: const IconThemeData(color: MPColor.ink2, size: 22),
      dividerTheme: const DividerThemeData(
        color: MPColor.border,
        thickness: 1,
        space: 1,
        indent: 20,
      ),
      listTileTheme: const ListTileThemeData(minTileHeight: 48),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: MPColor.surface2,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        hintStyle: const TextStyle(color: MPColor.ink3, fontSize: 14),
        border: const OutlineInputBorder(
          borderRadius: MPRadius.r12,
          borderSide: BorderSide(color: MPColor.border),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: MPRadius.r12,
          borderSide: BorderSide(color: MPColor.border),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: MPRadius.r12,
          borderSide: BorderSide(color: MPColor.primary, width: 1.6),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: MPColor.surface,
        modalBackgroundColor: MPColor.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
      ),
    );
  }

  /// 深色主题：固定主题下不存在深色界面，直接返回同一套浅色主题，
  /// 避免系统深色模式走到 Material 默认深色。
  static ThemeData dark({String? fontFamily}) => light(fontFamily: fontFamily);

  /// Cupertino 侧由 Material 主题推导，保证两套平台风格同源。
  static CupertinoThemeData cupertino(ThemeData material) {
    return MaterialBasedCupertinoThemeData(materialTheme: material);
  }
}
