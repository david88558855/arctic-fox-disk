import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

import 'setting.dart';

part 'setting_appearance.freezed.dart';
part 'setting_appearance.g.dart';

/// 「文件图标颜色」的兜底配色。
///
/// 注意：这**不是**外观主题。界面配色固定由 design_tokens 的 MPColor 决定，
/// 系统不存在主题切换；该常量只用于 FileSetting.iconColor 为空或匹配失败时兜底。
const defaultFlexScheme = FlexScheme.material;

extension FlexSchemeExtension on FlexScheme {
  /// 固定按浅色取色：系统处于深色模式时也不会切到 dark 变体，
  /// 以免文件图标颜色与固定浅色界面不一致。
  Color primaryColor(BuildContext context) {
    return colors(Brightness.light).primary;
  }
}

@freezed
class AppearanceSetting with _$AppearanceSetting {
  const AppearanceSetting._();

  const factory AppearanceSetting({
    @Default("zh") @JsonKey(name: 'locale') String locale,
  }) = _AppearanceSetting;

  factory AppearanceSetting.fromJson(Map<String, Object?> json) =>
      _$AppearanceSettingFromJson(json);
}

final appearanceProvider = newSettingNotifier(
  "app.appearance",
  const AppearanceSetting(),
  AppearanceSetting.fromJson,
);
