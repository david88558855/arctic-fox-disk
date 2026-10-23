import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'app/app.dart';
import 'app/grpc.dart';
import 'app/i18n.dart';

import 'common/theme/mp_theme.dart';
import 'common/utils/util.dart';

import 'api/file/route.dart' as file;
import 'api/home/route.dart' as home;
import 'api/task/route.dart' as task;
import 'api/setting/route.dart' as setting;
import 'api/file/providers/repo.dart';
import 'api/setting/providers/setting_appearance.dart';

Future<void> init() async {
  await App.instance.init();

  await home.init(App.router);
  await file.init(App.router);
  await task.init(App.router);
  await setting.init(App.router);
}

Future<void> initContainer(ProviderContainer container) async {
  loadBookmarks(container);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 启动期兜底：把"静默闪退"变成可见的错误页，
  // 否则 Android 上一个未捕获异常就表现为打开即退出，拿不到任何线索。
  WidgetsBinding.instance.platformDispatcher.onError = (error, stack) {
    // ignore: avoid_print
    print('uncaught async error: $error\n$stack');
    return true;
  };
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    // ignore: avoid_print
    print('flutter error: ${details.exception}\n${details.stack}');
  };

  final container = ProviderContainer();

  try {
    await init();
    await initContainer(container);
  } catch (error, stack) {
    // 这里不能用 App.logger：logger 本身可能就是失败的那一步
    // ignore: avoid_print
    print('bootstrap failed: $error\n$stack');
    runApp(BootstrapFailureApp(error: error, stack: stack));
    return;
  }

  runApp(UncontrolledProviderScope(
    container: container,
    child: MyApp(),
  ));
}

/// 启动失败时的最小界面：不依赖任何 provider / 主题 / gRPC。
class BootstrapFailureApp extends StatelessWidget {
  const BootstrapFailureApp({
    super.key,
    required this.error,
    this.stack,
  });

  final Object error;
  final StackTrace? stack;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFF4F7FA),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  '启动失败 / Startup failed',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF16202C),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '应用初始化时抛出异常。请把下面这段信息反馈给开发者。',
                  style: TextStyle(fontSize: 13, color: Color(0xFF5C6B7A)),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE7ECF2)),
                  ),
                  child: SelectableText(
                    '$error\n\n${stack ?? ''}',
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: Color(0xFF16202C),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      // 切换到后台或锁屏
      case AppLifecycleState.paused:
        break;
      // 切换到前台
      case AppLifecycleState.resumed:
        Grpc.instance.checkAlive();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appearance = ref.watch(appearanceProvider);

    final locale = Locale(appearance.locale);

    // 固定单一浅色主题：light / dark 返回同一套，系统深色模式也不切换。
    final lightTheme = MPTheme.light(fontFamily: Util.fontFamily);
    final darkTheme = lightTheme;

    final cupertinoLightTheme = MPTheme.cupertino(lightTheme);
    final cupertinoDarkTheme = MPTheme.cupertino(darkTheme);
    return PlatformProvider(
      // initialPlatform: TargetPlatform.android,
      settings: PlatformSettingsData(
        iosUsesMaterialWidgets: true,
        // legacyIosUsesMaterialWidgets: true,
        platformStyle: PlatformStyleData(
          ios: PlatformStyle.Cupertino,
          android: PlatformStyle.Cupertino,
        ),
      ),
      builder: (context) {
        final lightTextTheme = cupertinoLightTheme.textTheme;
        final darkTextTheme = cupertinoDarkTheme.textTheme;
        return PlatformTheme(
          themeMode: ThemeMode.light,
          materialLightTheme: lightTheme,
          materialDarkTheme: darkTheme,
          cupertinoLightTheme: cupertinoLightTheme.copyWith(
            barBackgroundColor: cupertinoLightTheme.scaffoldBackgroundColor,
            textTheme: lightTextTheme.copyWith(
              textStyle: lightTextTheme.textStyle.copyWith(
                fontSize: 16,
                color: lightTheme.colorScheme.onSurface,
              ),
              tabLabelTextStyle: lightTextTheme.tabLabelTextStyle.copyWith(
                fontSize: 12,
              ),
            ),
          ),
          cupertinoDarkTheme: cupertinoDarkTheme.copyWith(
            barBackgroundColor: cupertinoDarkTheme.scaffoldBackgroundColor,
            textTheme: darkTextTheme.copyWith(
              textStyle: darkTextTheme.textStyle.copyWith(
                fontSize: 16,
                color: darkTheme.colorScheme.onSurface,
              ),
              tabLabelTextStyle: darkTextTheme.tabLabelTextStyle.copyWith(
                fontSize: 12,
              ),
            ),
          ),
          builder: (context) => PlatformApp(
            navigatorKey: App.navigatorKey,
            title: '白狐云盘'.tr(),
            locale: I18n.delegate.isSupported(locale) ? locale : null,
            localizationsDelegates: I18n.localizationsDelegates,
            supportedLocales: I18n.supportedLocales,
            initialRoute: App.initialRoute,
            onGenerateRoute: App.router.onGenerateRoute(context),
            debugShowCheckedModeBanner: false,
            scrollBehavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {
                PointerDeviceKind.mouse,
                PointerDeviceKind.touch,
                PointerDeviceKind.stylus,
                PointerDeviceKind.unknown
              },
            ),
            builder: FlutterSmartDialog.init(),
          ),
        );
      },
    );
  }
}
