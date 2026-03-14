import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_ui/core_ui.dart';
import '../providers/campus_info_providers.dart';
import 'announcement_detail_page.dart';

/// 收藏页面
class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('我的收藏')),
      body: favoritesAsync.when(
        data: (favorites) {
          if (favorites.isEmpty) {
            return const EmptyWidget(title: '暂无收藏');
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final item = favorites[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${item.categoryText} · ${item.author}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.bookmark, color: Colors.amber),
                    onPressed: () {
                      ref
                          .read(favoriteNotifierProvider.notifier)
                          .toggle(item.id);
                      ref.invalidate(favoritesProvider);
                    },
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AnnouncementDetailPage(id: item.id),
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const LoadingWidget(),
        error: (error, _) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(favoritesProvider),
        ),
      ),
    );
  }
}
