import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_ui/core_ui.dart';
import '../providers/convenience_providers.dart';
import '../../data/models/bus_route.dart';

class BusPage extends ConsumerWidget {
  const BusPage({super.key});

  static const _types = [
    (value: null, label: '全部'),
    (value: 'intercampus', label: '校区间'),
    (value: 'campus', label: '校内'),
    (value: 'city', label: '城市'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(selectedBusTypeProvider);
    final routesAsync = ref.watch(busRoutesProvider(selectedType));

    return Scaffold(
      appBar: AppBar(title: const Text('校车服务')),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _types.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final t = _types[index];
                final isSelected = selectedType == t.value;
                return FilterChip(
                  label: Text(t.label),
                  selected: isSelected,
                  onSelected: (_) => ref
                      .read(selectedBusTypeProvider.notifier)
                      .state = t.value,
                );
              },
            ),
          ),
          Expanded(
            child: routesAsync.when(
              data: (routes) {
                if (routes.isEmpty) return const EmptyWidget(title: '暂无班次信息');

                final soon =
                    routes.where((r) => r.isSoon && !r.isDeparted).toList();
                final upcoming = routes
                    .where((r) => !r.isSoon && !r.isDeparted)
                    .toList()
                  ..sort((a, b) => a.minutesUntilDeparture
                      .compareTo(b.minutesUntilDeparture));
                final departed = routes.where((r) => r.isDeparted).toList();

                return RefreshIndicator(
                  onRefresh: () async =>
                      ref.invalidate(busRoutesProvider(selectedType)),
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (soon.isNotEmpty) ...[
                        _SectionLabel(label: '即将发车', color: Colors.orange),
                        ...soon.map((r) => _BusCard(route: r)),
                        const SizedBox(height: 8),
                      ],
                      if (upcoming.isNotEmpty) ...[
                        _SectionLabel(label: '待发车', color: Colors.blue),
                        ...upcoming.map((r) => _BusCard(route: r)),
                        const SizedBox(height: 8),
                      ],
                      if (departed.isNotEmpty) ...[
                        _SectionLabel(label: '已发车', color: Colors.grey),
                        ...departed
                            .map((r) => _BusCard(route: r, isDeparted: true)),
                      ],
                    ],
                  ),
                );
              },
              loading: () => const LoadingWidget(),
              error: (error, _) => AppErrorWidget(
                message: error.toString(),
                onRetry: () => ref.invalidate(busRoutesProvider(selectedType)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final Color color;
  const _SectionLabel({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(width: 8),
          Text(label,
              style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

class _BusCard extends StatelessWidget {
  final BusRoute route;
  final bool isDeparted;
  const _BusCard({required this.route, this.isDeparted = false});

  @override
  Widget build(BuildContext context) {
    final textColor = isDeparted ? Colors.grey : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _showStops(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              SizedBox(
                width: 52,
                child: Column(
                  children: [
                    Text(
                      route.departureTime,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDeparted
                            ? Colors.grey
                            : (route.isSoon ? Colors.orange : Colors.blue),
                      ),
                    ),
                    if (!isDeparted && route.isSoon)
                      const Text('即将',
                          style: TextStyle(fontSize: 11, color: Colors.orange)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(route.routeName,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: textColor)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 13, color: Colors.grey[500]),
                        const SizedBox(width: 2),
                        Text(route.departure,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[500])),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(Icons.arrow_forward,
                              size: 12, color: Colors.grey),
                        ),
                        Text(route.destination,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[500])),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.timer, size: 13, color: Colors.grey[400]),
                        const SizedBox(width: 2),
                        Text('${route.durationMinutes}分钟',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[400])),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(route.typeText,
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.blue)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(route.arrivalTime,
                  style: TextStyle(
                      fontSize: 14, color: textColor ?? Colors.grey[600])),
            ],
          ),
        ),
      ),
    );
  }

  void _showStops(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(route.routeName,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...route.stops.asMap().entries.map((entry) {
              final isFirst = entry.key == 0;
              final isLast = entry.key == route.stops.length - 1;
              return Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isFirst || isLast ? Colors.blue : Colors.grey,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                      if (!isLast)
                        Container(
                            width: 2, height: 24, color: Colors.grey[300]),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        fontWeight: isFirst || isLast
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
