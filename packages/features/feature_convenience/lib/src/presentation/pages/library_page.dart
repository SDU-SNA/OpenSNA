import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_ui/core_ui.dart';
import '../providers/convenience_providers.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(libraryStatusProvider);
    final seatsAsync = ref.watch(librarySeatsProvider(null));

    return Scaffold(
      appBar: AppBar(
        title: const Text('图书馆'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(libraryStatusProvider);
              ref.invalidate(librarySeatsProvider(null));
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(libraryStatusProvider);
          ref.invalidate(librarySeatsProvider(null));
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            statusAsync.when(
              data: (status) => _StatusCard(status: status),
              loading: () => const Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              error: (error, _) => AppErrorWidget(message: error.toString()),
            ),
            const SizedBox(height: 16),
            Text('座位情况',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            seatsAsync.when(
              data: (areas) {
                if (areas.isEmpty) return const EmptyWidget(title: '暂无座位数据');
                return Column(
                  children: areas.map((area) => _AreaCard(area: area)).toList(),
                );
              },
              loading: () => const LoadingWidget(),
              error: (error, _) => AppErrorWidget(message: error.toString()),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final Map<String, dynamic> status;
  const _StatusCard({required this.status});

  @override
  Widget build(BuildContext context) {
    final isOpen = status['isOpen'] as bool? ?? false;
    final openTime = status['openTime'] as String? ?? '--';
    final closeTime = status['closeTime'] as String? ?? '--';
    final totalSeats = status['totalSeats'] as int? ?? 0;
    final availableSeats = status['availableSeats'] as int? ?? 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isOpen ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  isOpen ? '图书馆开放中' : '图书馆已关闭',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isOpen ? Colors.green : Colors.red,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _InfoItem(
                    icon: Icons.access_time,
                    label: '开放时间',
                    value: '$openTime - $closeTime'),
                _InfoItem(
                    icon: Icons.event_seat,
                    label: '可用座位',
                    value: '$availableSeats / $totalSeats'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoItem(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 22),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _AreaCard extends StatelessWidget {
  final Map<String, dynamic> area;
  const _AreaCard({required this.area});

  @override
  Widget build(BuildContext context) {
    final name = area['name'] as String? ?? '';
    final total = area['total'] as int? ?? 0;
    final available = area['available'] as int? ?? 0;
    final ratio = total > 0 ? available / total : 0.0;

    Color progressColor;
    if (ratio > 0.5) {
      progressColor = Colors.green;
    } else if (ratio > 0.2) {
      progressColor = Colors.orange;
    } else {
      progressColor = Colors.red;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text('$available 个空位',
                    style: TextStyle(
                        color: progressColor, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: ratio,
                backgroundColor: Colors.grey.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation(progressColor),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 4),
            Text('共 $total 个座位，已占用 ${total - available} 个',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
