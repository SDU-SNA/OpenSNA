import '../../data/models/announcement.dart';

/// 校园资讯 Repository 接口
abstract class CampusInfoRepository {
  Future<List<Announcement>> getAnnouncements({
    String? category,
    int page = 1,
    int pageSize = 20,
  });

  Future<Announcement> getAnnouncementDetail(String id);

  Future<List<Announcement>> searchAnnouncements(String keyword);

  Future<void> markAsRead(String id);

  Future<void> favoriteAnnouncement(String id);

  Future<void> unfavoriteAnnouncement(String id);

  Future<List<Announcement>> getFavorites();
}
