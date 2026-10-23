import 'package:path/path.dart' as filepath;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/app/grpc.dart';
import 'package:maple_file/common/theme/design_tokens.dart';
import 'package:maple_file/common/utils/path.dart';
import 'package:maple_file/common/utils/util.dart';
import 'package:maple_file/common/utils/time.dart';
import 'package:maple_file/common/utils/color.dart';
import 'package:maple_file/common/widgets/brand_mark.dart';
import 'package:maple_file/common/widgets/custom.dart';
import 'package:maple_file/common/widgets/surface_card.dart';
import 'package:maple_file/common/providers/selection.dart';

import 'package:maple_file/generated/proto/api/file/file.pb.dart';
import 'package:maple_file/api/setting/providers/setting_appearance.dart';

import 'file_action.dart';
import 'file_breadcrumb.dart';

import 'preview/image.dart';
import 'preview/source.dart';

import '../providers/file.dart';
import '../providers/file_setting.dart';

class FileView extends ConsumerStatefulWidget {
  const FileView({
    super.key,
    this.path = "/",
    this.filter,
    this.selection,
    required this.fileBuilder,
  });

  final String path;
  final bool Function(File)? filter;
  final Selection<File>? selection;
  final Widget Function(BuildContext, File, Widget) fileBuilder;

  @override
  ConsumerState<FileView> createState() => _FileViewState();
}

class _FileViewState extends ConsumerState<FileView> {
  bool get _isRoot => widget.path == "/";

  @override
  Widget build(BuildContext context) {
    return CustomPaging(
      onLoad: () => ref.read(fileProvider(widget.path).notifier).load(),
      onRefresh: () => ref.read(fileProvider(widget.path).notifier).refresh(),
      slivers: [
        if (!_isRoot)
          SliverToBoxAdapter(
            child: ListTile(
              dense: true,
              title: FileBreadcrumb(path: widget.path),
              trailing: const FileSortAction(),
            ),
          ),
        CustomSliverAsyncValue(
          value: ref.watch(fileProvider(widget.path)),
          builder: (items) => buildView(context, items),
        ),
      ],
    );
  }

  buildView(BuildContext context, List<File> items) {
    if (widget.filter != null) {
      items = items.where(widget.filter!).toList();
    }
    if (items.isEmpty) {
      if (_isRoot) {
        return SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const BrandMark(size: 40, color: MPColor.ink3),
                const SizedBox(height: 12),
                TextButton.icon(
                  icon: const Icon(Icons.add, size: 18),
                  label: Text("创建存储".tr()),
                  onPressed: () {
                    Navigator.pushNamed(context, '/file/setting/repo/edit');
                  },
                ),
              ],
            ),
          ),
        );
      }
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const BrandMark(size: 40, color: MPColor.ink3),
            const SizedBox(height: 12),
            Text(
              "暂无文件".tr(),
              style: const TextStyle(
                color: MPColor.ink3,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }
    final view = ref.watch(fileSettingProvider.select((state) => state.view));
    return view == FileListView.grid
        ? buildGridView(context, items)
        : buildListView(context, items);
  }

  buildListView(BuildContext context, List<File> rows) {
    final selection = widget.selection ?? Selection<File>();

    return SliverList.builder(
      // separatorBuilder: (context, index) => Divider(
      //   height: 0.5,
      //   indent: 64,
      // ),
      itemCount: rows.length,
      itemBuilder: (context, index) {
        final row = rows[index];

        return widget.fileBuilder(
          context,
          row,
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: SurfaceCard(
              color: selection.contains(row) ? MPColor.primary50 : null,
              showShadow: false,
              padding: const EdgeInsets.fromLTRB(10, 8, 6, 8),
              child: SizedBox(
                height: 46,
                child: Row(
                  children: <Widget>[
                    FileIcon(file: row, size: 0.625),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _buildName(row),
                          const SizedBox(height: 3),
                          _buildMeta(row),
                        ],
                      ),
                    ),
                    if (_isSelection(row))
                      _buildCheckbox(selection, row)
                    else if (!_isRoot)
                      IconButton(
                        icon: const Icon(
                          Icons.more_vert,
                          size: 20,
                          color: MPColor.ink3,
                        ),
                        onPressed: () async {
                          final result = await showFileAction(context, row);
                          if (!context.mounted) return;
                          result?.action(context, row, ref: ref);
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  buildGridView(BuildContext context, List<File> rows) {
    final selection = widget.selection ?? Selection<File>();

    return SliverAlignedGrid.extent(
      itemCount: rows.length,
      // 单个文件占用的宽度
      maxCrossAxisExtent: 100,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      itemBuilder: (context, index) {
        final row = rows[index];
        return Stack(children: [
          if (_isSelection(row))
            Positioned(
              top: -4,
              right: -4,
              child: _buildCheckbox(selection, row),
            ),
          widget.fileBuilder(
            context,
            row,
            SurfaceCard(
              color: _isSelection(row) ? MPColor.primary50 : null,
              showShadow: false,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FileIcon(file: row, size: 0.75),
                  const SizedBox(height: 8),
                  _buildName(row, maxLines: 2, center: true),
                ],
              ),
            ),
          ),
        ]);
      },
    );
  }

  _buildName(File row, {int? maxLines, bool center = false}) {
    if (row.type == "RECYCLE") {
      return Text(
        "回收站".tr(),
        textAlign: center ? TextAlign.center : null,
      );
    }
    return Text(
      row.name,
      textAlign: center ? TextAlign.center : null,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// 时间 · 大小，12.5/600/ink2
  Widget _buildMeta(File row) {
    const style = TextStyle(
      fontSize: 12.5,
      fontWeight: FontWeight.w600,
      color: MPColor.ink2,
    );
    return Wrap(
      spacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Text(
          TimeUtil.pbToString(row.updatedAt, "yyyy-MM-dd HH:mm"),
          style: style,
        ),
        if (row.type != "DIR")
          Text(Util.formatSize(row.size.toInt()), style: style),
      ],
    );
  }

  _buildCheckbox(Selection<File> selection, File row) {
    return Checkbox(
      value: selection.contains(row),
      onChanged: (checked) {
        ref.read(fileSelectionProvider.notifier).toggle(row, checked: checked);
      },
    );
  }

  bool _isSelection(File file) {
    if (widget.selection != null && widget.selection!.enabled) {
      // if (widget.onLongPress == null) {
      //   return file.type != "DIR";
      // }
      return true;
    }
    return false;
  }
}

class FileIcon extends ConsumerWidget {
  const FileIcon({
    super.key,
    required this.file,
    this.size = 1,
  });

  final double size;
  final File file;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setting = ref.watch(fileSettingProvider);
    switch (setting.icon) {
      case FileListIcon.thumb:
        return SizedBox(
          width: 64 * size,
          height: 64 * size,
          child: file.type.startsWith("image/")
              ? _buildThumb(context, setting)
              : _build(context, setting),
        );
      case FileListIcon.circle:
        return Container(
          height: 48 * size,
          width: 48 * size,
          decoration: BoxDecoration(
            color: setting.iconColor == null
                ? Theme.of(context).primaryColor
                : setting.scheme.primaryColor(context),
            borderRadius: BorderRadius.all(Radius.circular(24 * size)),
          ),
          alignment: Alignment.center,
          child: Icon(
            PathUtil.icon(file.name, type: file.type),
            color: ColorUtil.foregroundColorWithString(file.name),
          ),
        );
      case FileListIcon.rectangle:
        return SizedBox(
          width: 64 * size,
          height: 64 * size,
          child: _build(context, setting),
        );
    }
  }

  _build(BuildContext context, FileSetting setting) {
    return Icon(
      PathUtil.icon(file.name, type: file.type),
      size: 64 * size,
      color: setting.iconColor == null
          ? Theme.of(context).primaryColor
          : setting.scheme.primaryColor(context),
    );
  }

  _buildThumb(BuildContext context, FileSetting setting) {
    return ImagePreview(
      source: PreviewSource.network(
        Grpc.instance.thumbURL(
          filepath.posix.join(file.path, file.name),
        ),
        name: file.name,
      ),
      errorBuilder: (context) {
        return _build(context, setting);
      },
    );
  }
}
