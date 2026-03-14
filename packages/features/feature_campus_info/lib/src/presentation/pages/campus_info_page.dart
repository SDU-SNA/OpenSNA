import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_ui/core_ui.dart';
import '../providers/campus_info_providers.dart';
import '../../data/models/announcement.dart';
import 'announcement_detail_page.dart';
import 'search_page.dart';
import 'favorites_page.dart';

class CampusInfoPage extends ConsumerWidget {
  const CampusInfoPage({super.key});

  static const _categories = [
    (value: null, label: '全部'),
    (value: 'notice', label: '通知'),
    (value: 'news', label: '新闻'),
    (value: 'activity', label: '活动'),
    (value: 'maintenance', label: '维护'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final announcementsAsync = ref.watch(
      announcementsProvider((category: selectedCategory, page: 1)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('校园资讯'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchPage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoritesPage()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = selectedCategory == cat.value;
                return FilterChip(
                  label: Text(cat.label),
                  selected: isSelected,
                  onSelected: (_) {
                    ref.read(selectedCategoryProvider.notifier).state =
                        cat.value;
                  },
                );
              },
            ),
          ),
          Expanded(
            child: announcementsAsync.when(
              data: (announcements) {
                if (announcements.isEmpty) {
                  return const EmptyWidget(title: '暂无公告');
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(announcementsProvider(
                        (category: selectedCategory, page: 1)));
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: announcements.length,
                    itemBuilder: (context, index) {
                      return _AnnouncementCard(
                        announcement: announcements[index],
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AnnouncementDetailPage(
                                id: announcements[index].id),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const LoadingWidget(),
              error: (error, _) => AppErrorWidget(
                message: error.toString(),
                onRetry: () => ref.invalidate(announcementsProvider(
                    (category: selectedCategory, page: 1))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnnouncementCard extends ConsumerWidget {
  final Announcement announcement;
  final VoidCallback onTap;

  const _AnnouncementCard({required this.announcement, required this.onTap});

  Color _getCategoryColor(BuildContext context) {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorited =
        ref.watch(favoriteNotifierProvider).contains(announcement.id);
    final categoryColor = _getCategoryColor(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (announcement.isPinned) ...[
                    const Icon(Icons.push_pin, size: 14, color: Colors.red),
                    const SizedBox(width: 4),
                  ],
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      announcement.categoryText,
                      style: TextStyle(
                          fontSize: 12,
                          color: categoryColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => ref
                        .read(favoriteNotifierProvider.notifier)
                        .toggle(announcement.id),
                    child: Icon(
                      isFavorited ? Icons.bookmark : Icons.bookmark_outline,
                      size: 20,
                      color: isFavorited ? Colors.amber : Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                announcement.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: announcement.isRead
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                announcement.summary,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey[600]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.person_outline, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(announcement.author,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey[500])),
                  const SizedBox(width: 16),
                  Icon(Icons.remove_red_eye_outlined,
                      size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text('${announcement.viewCount}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey[500])),
                  const Spacer(),
                  Text(_formatDate(announcement.publishedAt),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey[500])),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) {
      if (diff.inHours == 0) return '${diff.inMinutes}分钟前';
      return '${diff.inHours}小时前';
    }
    if (diff.inDays < 7) return '${diff.inDays}天前';
    return '${date.month}-${date.day}';
  }
}
