import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/theme/design_tokens.dart';
import 'package:maple_file/common/utils/color.dart';
import 'package:maple_file/common/widgets/custom.dart';
import 'package:maple_file/common/widgets/platform/list.dart';
import 'package:maple_file/generated/proto/api/file/repo.pb.dart';

import '../providers/file.dart';
import '../providers/repo.dart';

class RepoListScreen extends ConsumerStatefulWidget {
  const RepoListScreen({super.key});

  @override
  ConsumerState<RepoListScreen> createState() => _RepoListState();
}

class _RepoListState extends ConsumerState<RepoListScreen> {
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      iosContentPadding: true,
      backgroundColor: ColorUtil.scaffoldBackgroundColor(context),
      appBar: PlatformAppBar(
        title: Text('存储库'.tr()),
      ),
      body: CustomRefresh(
        onRefresh: () {
          ref.invalidate(repoProvider);
        },
        childBuilder: (context, physics) {
          return CustomScrollView(
            physics: physics,
            slivers: [
              CustomSliverAsyncValue(
                value: ref.watch(repoProvider),
                builder: (items) {
                  // 稳定分区：组内保持 provider 原有顺序，不引入新排序
                  final enabled = items.where((item) => item.status).toList();
                  final disabled = items.where((item) => !item.status).toList();
                  return SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        if (enabled.isNotEmpty)
                          _buildSection(context, "已启用".tr(), enabled),
                        if (disabled.isNotEmpty)
                          _buildSection(context, "未启用".tr(), disabled),
                        _buildSection(context, null, const <Repo>[]),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String? title,
    List<Repo> items,
  ) {
    return CustomListSection(
      header: title == null
          ? null
          : Container(
              alignment: Alignment.centerLeft,
              child: Text(title, style: Theme.of(context).textTheme.bodySmall),
            ),
      children: <Widget>[
        for (final item in items) _buildRepo(context, item),
        if (title == null) _buildAddTile(context),
      ],
    );
  }

  Widget _buildRepo(BuildContext context, Repo item) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/file/setting/repo/edit',
          arguments: item,
        );
      },
      child: PlatformListTile(
        title: Text(item.name),
        subtitle: Text(
          "存储类型：{driver}".tr(
            args: {"driver": item.driver},
          ),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: MPColor.primary100,
            borderRadius: BorderRadius.circular(MPRadius.s10),
          ),
          child: Center(
            child: Text(
              item.name.substring(0, 1).capitalize,
              style: const TextStyle(
                color: MPColor.primary700,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        trailing: PlatformSwitch(
          value: item.status,
          activeTrackColor: MPColor.primary,
          onChanged: (result) async {
            await RepoService.instance
                .update(item.copyWith((r) {
              r.status = result;
            })).then((_) {
              ref.invalidate(repoProvider);
              ref.invalidate(fileProvider(item.path));
            });
          },
        ),
      ),
    );
  }

  Widget _buildAddTile(BuildContext context) {
    return PlatformListTile(
      leading: const Icon(Icons.add, color: MPColor.primary),
      title: Text("添加新存储".tr()),
      onTap: () {
        Navigator.pushNamed(
          context,
          '/file/setting/repo/edit',
        );
      },
    );
  }
}
