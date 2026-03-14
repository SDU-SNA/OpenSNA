import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_network/core_network.dart';
import '../../data/datasources/campus_info_api.dart';
import '../../data/repositories/campus_info_repository_impl.dart';
import '../../domain/repositories/campus_info_repository.dart';
import '../../data/models/announcement.dart';

// ==================== 依赖注入 ====================

final campusInfoApiProvider = Provider<CampusInfoApi>((ref) {
  return CampusInfoApi(ApiClient());
});

final campusInfoRepositoryProvider = Provider<CampusInfoRepository>((ref) {
  return CampusInfoRepositoryImpl(ref.watch(campusInfoApiProvider));
});

// ==================== 公告列表 ====================

/// 当前选中的分类
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

/// 公告列表 Provider
final announcementsProvider = FutureProvider.family<List<Announcement>,
    ({String? category, int page})>((ref, params) async {
  final repo = ref.watch(campusInfoRepositoryProvider);
  return repo.getAnnouncements(
    category: params.category,
    page: params.page,
  );
});

/// 公告详情 Provider
final announcementDetailProvider =
    FutureProvider.family<Announcement, String>((ref, id) async {
  final repo = ref.watch(campusInfoRepositoryProvider);
  return repo.getAnnouncementDetail(id);
});

// ==================== 搜索 ====================

/// 搜索关键词
final searchKeywordProvider = StateProvider<String>((ref) => '');

/// 搜索结果 Provider
final searchResultsProvider =
    FutureProvider.family<List<Announcement>, String>((ref, keyword) async {
  if (keyword.isEmpty) return [];
  final repo = ref.watch(campusInfoRepositoryProvider);
  return repo.searchAnnouncements(keyword);
});

// ==================== 收藏 ====================

/// 收藏列表 Provider
final favoritesProvider = FutureProvider<List<Announcement>>((ref) async {
  final repo = ref.watch(campusInfoRepositoryProvider);
  return repo.getFavorites();
});

/// 收藏操作 Notifier
class FavoriteNotifier extends StateNotifier<Set<String>> {
  final CampusInfoRepository _repository;

  FavoriteNotifier(this._repository) : super({});

  Future<void> toggle(String id) async {
    if (state.contains(id)) {
      await _repository.unfavoriteAnnouncement(id);
      state = {...state}..remove(id);
    } else {
      await _repository.favoriteAnnouncement(id);
      state = {...state, id};
    }
  }

  bool isFavorited(String id) => state.contains(id);
}

final favoriteNotifierProvider =
    StateNotifierProvider<FavoriteNotifier, Set<String>>((ref) {
  return FavoriteNotifier(ref.watch(campusInfoRepositoryProvider));
});
