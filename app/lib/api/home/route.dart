import 'package:arctic_fox_disk/app/router.dart';
import 'package:arctic_fox_disk/common/widgets/responsive.dart';

import "pages/index.dart";
import "pages/not_found.dart";

Future<void> init(CustomRouter router) async {
  router.registerMany({
    "/": (context) {
      if (Breakpoint.isSmall(context)) {
        return const IndexScreen();
      }
      return const DesktopIndexScreen();
    },
    '/404': (context) {
      return const NotFoundScreen();
    },
  });
}
