import 'package:arctic_fox_disk/app/router.dart';

import "pages/setting.dart";
import "pages/setting_backup.dart";
import "pages/setting_locale.dart";

Future<void> init(CustomRouter router) async {
  router.registerMany({
    '/setting': (context) {
      return const SettingScreen();
    },
    '/setting/locale': (context) {
      return const SettingLocaleScreen();
    },
    '/setting/backup': (context) {
      return const SettingBackupScreen();
    },
  });
}
