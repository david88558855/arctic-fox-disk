import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:arctic_fox_disk/app/app.dart';
import 'package:arctic_fox_disk/app/i18n.dart';
import 'package:arctic_fox_disk/common/theme/design_tokens.dart';
import 'package:arctic_fox_disk/common/widgets/tree.dart';
import 'package:arctic_fox_disk/common/widgets/custom.dart';
import 'package:arctic_fox_disk/common/widgets/responsive.dart';
import 'package:arctic_fox_disk/generated/proto/api/base/task.pb.dart';

import '../widgets/task_action.dart';

import '../providers/task.dart';
import '../providers/service.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({super.key});

  factory TaskListScreen.fromRoute(ModalRoute? route) {
    final args = route?.settings.arguments;
    if (args == null) {
      return const TaskListScreen();
    }
    return const TaskListScreen();
  }

  @override
  ConsumerState<TaskListScreen> createState() => _TaskListState();
}

class _TaskListState extends ConsumerState<TaskListScreen>
    with TickerProviderStateMixin {
  late Timer _timer;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      ref.invalidate(taskProvider(TaskType.running));
      ref.invalidate(taskProvider(TaskType.finished));
      ref.invalidate(taskProvider(TaskType.failed));
    });
    _tabController = TabController(length: TaskType.values.length, vsync: this);
  }

  @override
  void dispose() {
    _timer.cancel();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("任务列表".tr()),
        automaticallyImplyLeading: Breakpoint.isSmall(context),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: TabBar(
                controller: _tabController,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: MPColor.primary100,
                  borderRadius: MPRadius.r14,
                ),
                indicatorPadding: const EdgeInsets.symmetric(vertical: 5),
                labelColor: MPColor.primary,
                unselectedLabelColor: MPColor.ink3,
                labelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                tabs: <Tab>[
                  for (final value in TaskType.values)
                    Tab(text: value.label(context)),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                for (final value in TaskType.values) _buildList(context, value),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildList(BuildContext context, TaskType status) {
    return CustomRefresh(
      onRefresh: () => ref.invalidate(taskProvider(status)),
      childBuilder: (context, physics) {
        return CustomScrollView(
          physics: physics,
          slivers: [
            CustomSliverAsyncValue(
              value: ref.watch(taskProvider(status)),
              builder: (items) {
                if (items.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Wrap(
                        direction: Axis.vertical,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(
                            Icons.task_outlined,
                            size: 36,
                            color: Theme.of(context).primaryColor,
                          ),
                          Text("暂无任务".tr()),
                        ],
                      ),
                    ),
                  );
                }
                return SliverList.builder(
                  itemCount: items.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return _buildListHeader(context, items, status);
                    }
                    return _buildListItem(context, items[index - 1]);
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  _buildListHeader(
    BuildContext context,
    List<Task> items,
    TaskType status,
  ) {
    return ListTile(
      leading: status == TaskType.running
          ? Text("剩余任务({length}})".tr(args: {
              "length": items.length,
            }))
          : status == TaskType.finished
              ? Text("已完成({length})".tr(args: {
                  "length": items.length,
                }))
              : Text("已失败({length})".tr(args: {
                  "length": items.length,
                })),
      trailing: Wrap(
        children: [
          TextButton.icon(
            icon: const Icon(Icons.clear, size: 16),
            label: Text("清除任务".tr()),
            onPressed: () async {
              await TaskService()
                  .removeTask(items.map((item) => item.id).toList());
            },
          ),
          if (status == TaskType.running)
            TextButton.icon(
              icon: const Icon(Icons.play_circle, size: 16),
              label: Text("全部暂停".tr()),
              onPressed: () {},
            ),
        ],
      ),
    );
  }

  _buildListItem(BuildContext context, Task item) {
    return ListTile(
      leading: Icon(
        Icons.folder,
        size: 36,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(
        item.name,
        overflow: TextOverflow.ellipsis,
      ),
      isThreeLine: true,
      subtitle: _buildProgress(context, item),
      trailing: _buildAction(context, item),
      onTap: () async {
        showTaskAction(context, item, ref: ref);
      },
    );
  }

  _buildAction(BuildContext context, Task item) {
    if (isFailed(item)) {
      return IconButton(
        icon: Icon(Icons.refresh, color: Theme.of(context).primaryColor),
        onPressed: () {},
      );
    }
    if (isFinished(item)) {
      return null;
    }
    return IconButton(
      icon: Icon(
        Icons.play_circle_outline,
        color: Theme.of(context).primaryColor,
      ),
      onPressed: () {},
    );
  }

  /// 进度条与状态文字的语义色：进行中品牌蓝 / 完成绿 / 失败红
  Color _progressColor(Task item) {
    switch (item.state) {
      case TaskState.TASK_STATE_SUCCEEDED:
        return MPColor.ok;
      case TaskState.TASK_STATE_FAILED:
        return MPColor.danger;
      default:
        return MPColor.primary;
    }
  }

  _buildProgress(BuildContext context, Task item) {
    final color = _progressColor(item);
    return Column(
      children: [
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(MPRadius.pill),
          child: LinearProgressIndicator(
            color: color,
            backgroundColor: MPColor.border,
            minHeight: 5,
            value: item.progress,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  item.progressState,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: MPColor.ink2,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Text(
              item.state.label(context),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class DesktopTaskScreen extends StatefulWidget {
  const DesktopTaskScreen({
    super.key,
  });

  @override
  State<DesktopTaskScreen> createState() => _DesktopTaskState();
}

class _DesktopTaskState extends State<DesktopTaskScreen> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState navigatorState(context) {
    return _navigatorKey.currentState ?? Navigator.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final menu = [
      CustomTreeMenu(
        label: "正在进行".tr(),
        expanded: true,
      ),
      CustomTreeMenu(
        label: "已完成".tr(),
        expanded: true,
      ),
      CustomTreeMenu(
        label: "已失败".tr(),
        expanded: true,
      ),
    ];

    return CustomLayout(
      menu: menu,
      navigatorKey: _navigatorKey,
      initialRoute: "/task/list",
      onGenerateRoute: App.router.onGenerateRouteReplace(
        context: context,
        replace: {
          "/": null,
        },
      ),
    );
  }
}
