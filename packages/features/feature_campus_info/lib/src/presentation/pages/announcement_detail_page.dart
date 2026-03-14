import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_ui/core_ui.dart';
import '../providers/campus_info_providers.dart';
import '../../data/models/announcement.dart';

/// 公告详情页面
class AnnouncementDetailPage extends ConsumerStatefulWidget {
  final String id;

  const AnnouncementDetailPage({super.key, required this.id});

  @override
  ConsumerState<AnnouncementDetailPage> createState() =>
      _AnnouncementDetailPageState();
}

class _AnnouncementDetailPageState
    extends ConsumerState<AnnouncementDetailPage> {
  @override
  void initState() {
    super.initState();
    // 标记为已读
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(campusInfoRepositoryProvider).markAsRead(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(announcementDetailProvider(widget.id));
    final isFavorited =
        ref.watch(favoriteNotifierProvider).contains(widget.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('公告详情'),
        actions: [
          IconButton(
            icon: Icon(
              isFavorited ? Icons.bookmark : Icons.bookmark_outline,
              color: isFavorited ? Colors.amber : null,
            ),
            onPressed: () {
              ref.read(favoriteNotifierProvider.notifier).toggle(widget.id);
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('分享功能开发中')),
              );
            },
          ),
        ],
      ),
      body: detailAsync.when(
        data: (announcement) => _DetailContent(announcement: announcement),
        loading: () => const LoadingWidget(),
        error: (error, _) => AppErrorWidget(
          error: error.toString(),
          onRetry: () => ref.invalidate(announcementDetailProvider(widget.id)),
        ),
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  final Announcement announcement;

  const _DetailContent({required this.announcement});

  Color _getCategoryColor() {
    switch (announcement.category) {
      case 'notice':
        return Colors.blue;
      case 'news':
        return Colors.green;
      case 'activity':
        return Colors.orange;
      case 'maintenance':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 分类标签
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: categoryColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              announcement.categoryText,
              style: TextStyle(
                color: categoryColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // 标题
          Text(
            announcement.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),

          // 元信息
          Row(
            children: [
              const Icon(Icons.person_outline, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                announcement.author,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.access_time, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                _formatDate(announcement.publishedAt),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.remove_red_eye_outlined,
                  size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                '${announcement.viewCount}',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey),
              ),
            ],
          ),

          // 标签
          if (announcement.tags.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              children: announcement.tags
                  .map((tag) => Chip(
                        label: Text(tag),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        labelStyle: const TextStyle(fontSize: 12),
                      ))
                  .toList(),
            ),
          ],

          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 20),

          // 正文
          Text(
            announcement.content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.8,
                ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
