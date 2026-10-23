import 'package:convert/convert.dart';
import 'package:flutter/material.dart';

import 'package:arctic_fox_disk/common/theme/design_tokens.dart';

class ColorUtil {
  static Color backgroundColorWithString(String value) {
    final strHex =
        hex.encode('${value}color'.codeUnits.map((e) => e % 256).toList());
    String colorStr = '';
    const hexLength = 6;
    final spacing = strHex.length ~/ hexLength;
    for (int i = 0; i < hexLength; i++) {
      colorStr += String.fromCharCode(strHex.codeUnitAt(i * spacing + 1));
    }
    return Color(int.parse('ff$colorStr', radix: 16));
  }

  static Color foregroundColorWithString(String value) {
    final bgColor = backgroundColorWithString(value);
    return bgColor.red * 0.299 + bgColor.green * 0.587 + bgColor.blue * 0.114 >
            186
        ? Colors.black
        : Colors.white;
  }

  /// 页面底色。固定主题：直接取令牌，不随系统深色模式变化。
  static Color scaffoldBackgroundColor(BuildContext context) {
    return MPColor.bg;
  }

  /// 卡片/分组底。固定主题：直接取令牌。
  static Color backgroundColor(BuildContext context) {
    return MPColor.surface;
  }

  /// 次级背景。固定主题：与卡片底一致。
  static Color secondaryBackgroundColor(BuildContext context) {
    return MPColor.surface;
  }
}
