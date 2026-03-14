import 'dart:math';
import '../../domain/repositories/campus_info_repository.dart';
import '../models/announcement.dart';

/// Mock 校园资讯 Repository（用于开发/演示）
class MockCampusInfoRepository implements CampusInfoRepository {
  final _random = Random();
  final _readIds = <String>{};
  final _favoriteIds = <String>{};

  static final _mockData = [
    (
      'notice',
      '关于2024-2025学年第二学期期末考试安排的通知',
      '根据学校教学计划，现将本学期期末考试安排通知如下：考试时间为2025年1月6日至1月17日，请各位同学提前做好复习准备，按时参加考试。考试期间请携带学生证和准考证入场。',
      '期末考试时间为2025年1月6日至1月17日'
    ),
    (
      'activity',
      '第十届山东大学文化艺术节开幕式',
      '山东大学第十届文化艺术节将于本周六在中心广场隆重开幕，届时将有精彩的文艺演出、书画展览、摄影展等多项活动，欢迎全体师生积极参与。',
      '文化艺术节本周六开幕，欢迎参与'
    ),
    (
      'academic',
      '2025年研究生招生简章发布',
      '我校2025年硕士研究生招生简章已正式发布，招生专业涵盖理、工、文、法、医等多个学科门类，报名时间为2024年10月10日至10月31日。',
      '2025年研究生招生简章已发布'
    ),
    (
      'notice',
      '图书馆寒假开放时间调整通知',
      '寒假期间（2025年1月18日至2月28日），图书馆开放时间调整为每天9:00-17:00，节假日正常开放。电子资源全天候可访问。',
      '寒假图书馆开放时间调整为9:00-17:00'
    ),
    (
      'activity',
      '校园马拉松报名开始',
      '2025年山东大学校园马拉松活动报名正式开始，设有全程、半程、迷你跑三个组别，欢迎全体师生踊跃报名参加，名额有限，先到先得。',
      '校园马拉松报名开始，名额有限'
    ),
    (
      'academic',
      '国家奖学金评定结果公示',
      '2024-2025学年国家奖学金评定工作已完成，现将评定结果予以公示，公示期为5个工作日。如有异议，请在公示期内向学生处反映。',
      '国家奖学金评定结果公示，公示期5个工作日'
    ),
    (
      'notice',
      '校园网升级维护通知',
      '为提升校园网络服务质量，网络信息中心将于本周六凌晨2:00-6:00对核心网络设备进行升级维护，届时部分区域网络可能出现短暂中断，请提前做好准备。',
      '本周六凌晨2:00-6:00校园网维护'
    ),
    (
      'activity',
      '创新创业大赛报名通知',
      '第九届"互联网+"大学生创新创业大赛校内选拔赛报名工作正式启动，欢迎有创业梦想的同学积极组队参赛，优秀项目将代表学校参加省级比赛。',
      '"互联网+"大赛校内选拔赛报名启动'
    ),
  ];

  static const _authors = [
    '教务处',
    '学生处',
    '研究生院',
    '图书馆',
    '体育部',
    '学生处',
    '网络信息中心',
    '创新创业学院'
  ];

  @override
  Future<List<Announcement>> getAnnouncements({
    String? category,
    int page = 1,
    int pageSize = 20,
  }) async {
    await _delay();
    var data = _mockData.asMap().entries.toList();
    if (category != null && category != 'all') {
      data = data.where((e) => e.value.$1 == category).toList();
    }
    return data.map((entry) {
      final i = entry.key;
      final d = entry.value;
      final id = 'ann_$i';
      return Announcement(
        id: id,
        title: d.$2,
        content: d.$3,
        summary: d.$4,
        category: d.$1,
        author: _authors[i % _authors.length],
        isPinned: i == 0,
        isRead: _readIds.contains(id),
        viewCount: 100 + _random.nextInt(900),
        publishedAt: DateTime.now().subtract(Duration(days: i)),
        updatedAt: DateTime.now().subtract(Duration(hours: i * 3)),
        tags: [d.$1],
      );
    }).toList();
  }

  @override
  Future<Announcement> getAnnouncementDetail(String id) async {
    await _delay();
    final all = await getAnnouncements();
    return all.firstWhere((a) => a.id == id, orElse: () => all.first);
  }

  @override
  Future<List<Announcement>> searchAnnouncements(String keyword) async {
    await _delay();
    final all = await getAnnouncements();
    return all
        .where((a) => a.title.contains(keyword) || a.content.contains(keyword))
        .toList();
  }

  @override
  Future<void> markAsRead(String id) async {
    await _delay();
    _readIds.add(id);
  }

  @override
  Future<void> favoriteAnnouncement(String id) async {
    await _delay();
    _favoriteIds.add(id);
  }

  @override
  Future<void> unfavoriteAnnouncement(String id) async {
    await _delay();
    _favoriteIds.remove(id);
  }

  @override
  Future<List<Announcement>> getFavorites() async {
    await _delay();
    final all = await getAnnouncements();
    return all.where((a) => _favoriteIds.contains(a.id)).toList();
  }

  Future<void> _delay() =>
      Future.delayed(Duration(milliseconds: 200 + _random.nextInt(300)));
}
