import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_ui/core_ui.dart';
import '../providers/campus_info_providers.dart';
import 'announcement_detail_page.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();
  String _keyword = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resultsAsync = ref.watch(searchResultsProvider(_keyword));

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: '搜索公告、新闻...',
            border: InputBorder.none,
          ),
          onSubmitted: (value) {
            setState(() => _keyword = value.trim());
          },
          textInputAction: TextInputAction.search,
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                setState(() => _keyword = '');
              },
            ),
        ],
      ),
      body: _keyword.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('输入关键词搜索',
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
            )
          : resultsAsync.when(
              data: (results) {
                if (results.isEmpty) {
                  return EmptyWidget(title: '未找到"$_keyword"相关内容');
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final item = results[index];
                    return ListTile(
                      title: Text(item.title,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(item.summary,
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.withOpacity(0.1),
                        child: Text(item.categoryText[0],
                            style: const TextStyle(color: Colors.blue)),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AnnouncementDetailPage(id: item.id),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const LoadingWidget(),
              error: (error, _) => AppErrorWidget(message: error.toString()),
            ),
    );
  }
}
