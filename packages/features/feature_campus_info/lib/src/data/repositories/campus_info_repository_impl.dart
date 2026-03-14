import '../../domain/repositories/campus_info_repository.dart';
import '../datasources/campus_info_api.dart';
import '../models/announcement.dart';

/// 校园资讯 Repository 实现
class CampusInfoRepositoryImpl implements CampusInfoRepository {
  final CampusInfoApi _api;

  CampusInfoRepositoryImpl(this._api);

  @override
  Future<List<Announcement>> getAnnouncements({
    String? category,
    int page = 1,
    int pageSize = 20,
  }) =>
      _api.getAnnouncements(category: category, page: page, pageSize: pageSize);

  @override
  Future<Announcement> getAnnouncementDetail(String id) =>
      _api.getAnnouncementDetail(id);

  @override
  Future<List<Announcement>> searchAnnouncements(String keyword) =>
      _api.searchAnnouncements(keyword);

  @override
  Future<void> markAsRead(String id) => _api.markAsRead(id);

  @override
  Future<void> favoriteAnnouncement(String id) => _api.favoriteAnnouncement(id);

  @override
  Future<void> unfavoriteAnnouncement(String id) =>
      _api.unfavoriteAnnouncement(id);

  @override
  Future<List<Announcement>> getFavorites() => _api.getFavorites();
}
