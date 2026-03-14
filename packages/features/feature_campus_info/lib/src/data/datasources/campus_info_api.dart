import 'package:core_network/core_network.dart';
import '../models/announcement.dart';

/// 校园资讯 API 数据源
class CampusInfoApi {
  final ApiClient _apiClient;

  CampusInfoApi(this._apiClient);

  /// 获取公告列表
  Future<List<Announcement>> getAnnouncements({
    String? category,
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _apiClient.get(
      '/campus/announcements',
      queryParameters: {
        if (category != null) 'category': category,
        'page': page,
        'pageSize': pageSize,
      },
    );
    final data = response.data as List;
    return data
        .map((item) => Announcement.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// 获取公告详情
  Future<Announcement> getAnnouncementDetail(String id) async {
    final response = await _apiClient.get('/campus/announcements/$id');
    return Announcement.fromJson(response.data as Map<String, dynamic>);
  }

  /// 搜索公告
  Future<List<Announcement>> searchAnnouncements(String keyword) async {
    final response = await _apiClient.get(
      '/campus/announcements/search',
      queryParameters: {'keyword': keyword},
    );
    final data = response.data as List;
    return data
        .map((item) => Announcement.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// 标记公告为已读
  Future<void> markAsRead(String id) async {
    await _apiClient.post('/campus/announcements/$id/read');
  }

  /// 收藏公告
  Future<void> favoriteAnnouncement(String id) async {
    await _apiClient.post('/campus/announcements/$id/favorite');
  }

  /// 取消收藏
  Future<void> unfavoriteAnnouncement(String id) async {
    await _apiClient.delete('/campus/announcements/$id/favorite');
  }

  /// 获取收藏列表
  Future<List<Announcement>> getFavorites() async {
    final response = await _apiClient.get('/campus/favorites');
    final data = response.data as List;
    return data
        .map((item) => Announcement.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
