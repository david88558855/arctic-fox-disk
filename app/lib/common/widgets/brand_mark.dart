import 'package:flutter/material.dart';

import 'package:maple_file/common/theme/design_tokens.dart';

/// 品牌标识：狐狸剪影。
///
/// 一条闭合路径、纯色填充、无描边、无第二种颜色、无眼睛。
/// 96 段三次贝塞尔，坐标系 64x64（四周留白 2.8，即画布宽的 4.4%）。
/// 数据由 maple-fox-mark.svg 生成，与定稿图轮廓 IoU 0.975。
/// 不要手工改单个控制点；要改就回到 SVG 重新导出。
class BrandMark extends StatelessWidget {
  const BrandMark({
    super.key,
    this.size = 24,
    this.color,
  });

  /// 边长（正方形）。
  final double size;

  /// 缺省取 IconTheme，再退品牌蓝。
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final value = color ?? IconTheme.of(context).color ?? MPColor.primary;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: BrandMarkPainter(color: value),
        isComplex: false,
        willChange: false,
      ),
    );
  }
}

/// 带底色的方形标识（AppBar / Rail / 应用图标位）。
class BrandMarkTile extends StatelessWidget {
  const BrandMarkTile({
    super.key,
    this.size = 26,
    this.radius = 8,
    this.background,
    this.foxColor = Colors.white,
  });

  final double size;
  final double radius;
  final Color? background;
  final Color foxColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background ?? MPColor.primary,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      alignment: Alignment.center,
      child: BrandMark(size: size * 0.72, color: foxColor),
    );
  }
}

class BrandMarkPainter extends CustomPainter {
  const BrandMarkPainter({required this.color});

  final Color color;

  /// 路径只构建一次，全局复用。
  static final Path _path = _buildFoxPath();

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / 64.0;
    final paint = Paint()
      ..color = color
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
    canvas.save();
    canvas.scale(scale, scale);
    canvas.drawPath(_path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(BrandMarkPainter oldDelegate) => oldDelegate.color != color;
}

// ---- 以下为生成代码（maple-fox-mark.svg），96 段，勿手改 ----

Path _buildFoxPath() {
  return Path()
    ..moveTo(15.32, 3.02)
    ..cubicTo(14.76, 3.05, 14.49, 4.47, 14.32, 5.40)
    ..cubicTo(14.15, 6.33, 14.33, 7.40, 14.31, 8.58)
    ..cubicTo(14.29, 9.76, 14.48, 11.46, 14.18, 12.50)
    ..cubicTo(13.89, 13.55, 13.07, 14.05, 12.52, 14.84)
    ..cubicTo(11.96, 15.63, 11.40, 16.28, 10.84, 17.22)
    ..cubicTo(10.27, 18.16, 9.79, 19.61, 9.12, 20.47)
    ..cubicTo(8.46, 21.34, 7.61, 21.71, 6.85, 22.41)
    ..cubicTo(6.10, 23.12, 4.72, 23.91, 4.59, 24.69)
    ..cubicTo(4.45, 25.47, 5.37, 26.46, 6.05, 27.08)
    ..cubicTo(6.72, 27.70, 7.59, 28.16, 8.66, 28.39)
    ..cubicTo(9.73, 28.61, 11.31, 28.45, 12.45, 28.44)
    ..cubicTo(13.59, 28.44, 14.54, 28.19, 15.49, 28.35)
    ..cubicTo(16.45, 28.52, 17.43, 28.73, 18.19, 29.42)
    ..cubicTo(18.95, 30.12, 19.77, 31.51, 20.04, 32.53)
    ..cubicTo(20.31, 33.55, 20.12, 34.47, 19.83, 35.52)
    ..cubicTo(19.54, 36.57, 18.80, 37.87, 18.30, 38.85)
    ..cubicTo(17.81, 39.84, 17.31, 40.55, 16.88, 41.42)
    ..cubicTo(16.44, 42.30, 16.02, 43.06, 15.69, 44.11)
    ..cubicTo(15.36, 45.17, 15.01, 46.65, 14.90, 47.77)
    ..cubicTo(14.78, 48.89, 14.84, 49.85, 14.99, 50.84)
    ..cubicTo(15.14, 51.83, 15.34, 52.69, 15.79, 53.70)
    ..cubicTo(16.24, 54.70, 17.00, 56.02, 17.71, 56.88)
    ..cubicTo(18.42, 57.75, 19.08, 58.30, 20.02, 58.90)
    ..cubicTo(20.96, 59.50, 22.31, 60.11, 23.36, 60.47)
    ..cubicTo(24.40, 60.82, 25.29, 60.93, 26.30, 61.05)
    ..cubicTo(27.31, 61.17, 28.25, 61.21, 29.42, 61.20)
    ..cubicTo(30.59, 61.19, 32.16, 61.08, 33.31, 60.97)
    ..cubicTo(34.46, 60.86, 35.33, 60.73, 36.32, 60.55)
    ..cubicTo(37.31, 60.38, 38.17, 60.20, 39.24, 59.90)
    ..cubicTo(40.31, 59.61, 41.71, 59.15, 42.75, 58.77)
    ..cubicTo(43.78, 58.38, 44.47, 58.11, 45.45, 57.61)
    ..cubicTo(46.44, 57.11, 47.73, 56.37, 48.67, 55.76)
    ..cubicTo(49.61, 55.16, 50.33, 54.62, 51.11, 53.97)
    ..cubicTo(51.88, 53.31, 52.57, 52.67, 53.32, 51.81)
    ..cubicTo(54.07, 50.94, 54.99, 49.71, 55.61, 48.78)
    ..cubicTo(56.23, 47.84, 56.62, 47.07, 57.03, 46.18)
    ..cubicTo(57.44, 45.29, 57.78, 44.50, 58.10, 43.43)
    ..cubicTo(58.42, 42.37, 58.76, 40.92, 58.95, 39.80)
    ..cubicTo(59.14, 38.69, 59.22, 37.90, 59.23, 36.74)
    ..cubicTo(59.24, 35.58, 59.16, 33.98, 59.02, 32.85)
    ..cubicTo(58.87, 31.72, 58.64, 30.88, 58.37, 29.93)
    ..cubicTo(58.09, 28.99, 57.78, 28.18, 57.37, 27.16)
    ..cubicTo(56.95, 26.14, 56.28, 24.82, 55.87, 23.80)
    ..cubicTo(55.46, 22.77, 55.16, 21.97, 54.90, 21.01)
    ..cubicTo(54.65, 20.06, 54.43, 19.21, 54.33, 18.06)
    ..cubicTo(54.24, 16.92, 54.23, 15.31, 54.34, 14.17)
    ..cubicTo(54.45, 13.04, 54.63, 12.30, 54.99, 11.25)
    ..cubicTo(55.36, 10.21, 55.98, 8.88, 56.53, 7.91)
    ..cubicTo(57.07, 6.94, 57.79, 6.22, 58.26, 5.45)
    ..cubicTo(58.73, 4.67, 59.71, 3.64, 59.33, 3.24)
    ..cubicTo(58.95, 2.84, 57.02, 2.94, 55.99, 3.04)
    ..cubicTo(54.95, 3.14, 54.05, 3.50, 53.13, 3.82)
    ..cubicTo(52.20, 4.15, 51.40, 4.46, 50.42, 4.99)
    ..cubicTo(49.45, 5.53, 48.19, 6.34, 47.29, 7.03)
    ..cubicTo(46.39, 7.72, 45.80, 8.29, 45.03, 9.14)
    ..cubicTo(44.27, 9.98, 43.33, 11.17, 42.70, 12.09)
    ..cubicTo(42.08, 13.01, 41.69, 13.77, 41.28, 14.66)
    ..cubicTo(40.88, 15.54, 40.55, 16.34, 40.26, 17.42)
    ..cubicTo(39.97, 18.49, 39.66, 19.97, 39.54, 21.10)
    ..cubicTo(39.42, 22.23, 39.46, 23.18, 39.54, 24.19)
    ..cubicTo(39.62, 25.20, 39.75, 26.09, 40.02, 27.17)
    ..cubicTo(40.29, 28.26, 40.78, 29.65, 41.16, 30.69)
    ..cubicTo(41.54, 31.72, 41.88, 32.38, 42.29, 33.40)
    ..cubicTo(42.70, 34.43, 43.28, 35.78, 43.63, 36.83)
    ..cubicTo(43.98, 37.88, 44.21, 38.71, 44.40, 39.70)
    ..cubicTo(44.59, 40.68, 44.74, 41.58, 44.78, 42.73)
    ..cubicTo(44.82, 43.87, 44.77, 45.45, 44.63, 46.58)
    ..cubicTo(44.50, 47.71, 44.29, 48.56, 43.99, 49.50)
    ..cubicTo(43.69, 50.44, 43.41, 51.26, 42.84, 52.21)
    ..cubicTo(42.27, 53.16, 41.34, 54.42, 40.55, 55.22)
    ..cubicTo(39.77, 56.02, 38.66, 56.83, 38.12, 57.01)
    ..cubicTo(37.58, 57.20, 37.15, 56.85, 37.31, 56.34)
    ..cubicTo(37.47, 55.82, 38.57, 54.77, 39.08, 53.92)
    ..cubicTo(39.60, 53.08, 40.02, 52.32, 40.40, 51.28)
    ..cubicTo(40.78, 50.25, 41.15, 48.81, 41.36, 47.70)
    ..cubicTo(41.57, 46.59, 41.62, 45.66, 41.65, 44.64)
    ..cubicTo(41.69, 43.61, 41.69, 42.67, 41.56, 41.54)
    ..cubicTo(41.43, 40.40, 41.13, 38.93, 40.86, 37.84)
    ..cubicTo(40.59, 36.76, 40.34, 36.07, 39.94, 35.04)
    ..cubicTo(39.55, 34.01, 38.97, 32.66, 38.50, 31.65)
    ..cubicTo(38.03, 30.65, 37.61, 29.90, 37.13, 29.04)
    ..cubicTo(36.65, 28.17, 36.21, 27.43, 35.62, 26.48)
    ..cubicTo(35.03, 25.53, 34.21, 24.27, 33.59, 23.33)
    ..cubicTo(32.96, 22.40, 32.44, 21.68, 31.85, 20.87)
    ..cubicTo(31.26, 20.06, 30.58, 19.42, 30.02, 18.47)
    ..cubicTo(29.46, 17.51, 28.75, 16.22, 28.49, 15.13)
    ..cubicTo(28.23, 14.05, 28.48, 13.15, 28.47, 11.95)
    ..cubicTo(28.47, 10.76, 28.48, 9.16, 28.47, 7.97)
    ..cubicTo(28.47, 6.78, 28.68, 5.62, 28.44, 4.80)
    ..cubicTo(28.21, 3.98, 27.66, 2.91, 27.04, 3.06)
    ..cubicTo(26.43, 3.21, 25.41, 4.85, 24.77, 5.70)
    ..cubicTo(24.14, 6.54, 23.77, 7.40, 23.23, 8.14)
    ..cubicTo(22.69, 8.88, 22.18, 10.21, 21.53, 10.14)
    ..cubicTo(20.88, 10.08, 19.96, 8.55, 19.33, 7.73)
    ..cubicTo(18.69, 6.91, 18.38, 6.00, 17.72, 5.22)
    ..cubicTo(17.05, 4.43, 15.89, 2.99, 15.32, 3.02)
    ..close();
}
