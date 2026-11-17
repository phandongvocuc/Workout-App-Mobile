import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/strings.dart';
import '../../data/models/schedule_item.dart';
import '../../providers/notification_settings_provider.dart';
import '../../providers/schedule_provider.dart';
import '../../widgets/empty_state_view.dart';
import 'schedule_form_dialog.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  static const List<Map<String, dynamic>> _daysInfo = [
    {'day': 1, 'name': 'Monday', 'short': 'MON'},
    {'day': 2, 'name': 'Tuesday', 'short': 'TUE'},
    {'day': 3, 'name': 'Wednesday', 'short': 'WED'},
    {'day': 4, 'name': 'Thursday', 'short': 'THU'},
    {'day': 5, 'name': 'Friday', 'short': 'FRI'},
    {'day': 6, 'name': 'Saturday', 'short': 'SAT'},
    {'day': 7, 'name': 'Sunday', 'short': 'SUN'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final scheduleProvider = context.watch<ScheduleProvider>();
    final notifSettings = context.watch<NotificationSettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.scheduleTitle),
            Text(
              'Weekly alarm & workout routine',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => ScheduleFormDialog.show(context),
            icon: const Icon(Icons.add_circle_outline, size: 28),
            tooltip: AppStrings.addSchedule,
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => ScheduleFormDialog.show(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Workout'),
      ),
      body: scheduleProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Permission / status banner if notifications are disabled or denied
                if (!notifSettings.isPermissionGranted ||
                    !notifSettings.notificationsEnabled)
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.notifications_off_outlined,
                            color: Colors.amber, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            !notifSettings.isPermissionGranted
                                ? 'Notification permission disabled. Reminders won\'t ring.'
                                : 'Reminders are toggled OFF in HydroFit settings.',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ),
                        if (!notifSettings.isPermissionGranted)
                          TextButton(
                            onPressed: notifSettings.openSystemSettings,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text('Enable', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                      ],
                    ),
                  ),

                // Main content
                Expanded(
                  child: scheduleProvider.isEmpty
                      ? EmptyStateView(
                          icon: Icons.calendar_today_outlined,
                          title: AppStrings.noScheduleTitle,
                          subtitle: AppStrings.noScheduleSubtitle,
                          actionLabel: AppStrings.addSchedule,
                          onAction: () => ScheduleFormDialog.show(context),
                        )
                      : _buildGroupedScheduleList(
                          context,
                          scheduleProvider.groupedByDay,
                          theme,
                          colorScheme,
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildGroupedScheduleList(
    BuildContext context,
    Map<int, List<ScheduleItem>> grouped,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final currentDay = DateTime.now().weekday;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
      itemCount: _daysInfo.length,
      itemBuilder: (context, index) {
        final dayData = _daysInfo[index];
        final dayNumber = dayData['day'] as int;
        final dayName = dayData['name'] as String;
        final dayShort = dayData['short'] as String;
        final items = grouped[dayNumber] ?? [];
        final isToday = dayNumber == currentDay;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header: Day of week
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isToday
                          ? colorScheme.primary
                          : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      dayShort,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isToday
                            ? Colors.white
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    dayName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isToday ? colorScheme.primary : null,
                    ),
                  ),
                  if (isToday) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'TODAY',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  Text(
                    '${items.length} ${items.length == 1 ? "workout" : "workouts"}',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),

            // Entries for this day
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 12, top: 2),
                child: Text(
                  'Rest day — no workouts scheduled',
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                ),
              )
            else
              ...items.map((item) => _ScheduleItemCard(item: item)),

            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}

class _ScheduleItemCard extends StatelessWidget {
  final ScheduleItem item;

  const _ScheduleItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: InkWell(
        onTap: () => ScheduleFormDialog.show(context, existingItem: item),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Clock alarm style time
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.alarm, size: 16, color: colorScheme.primary),
                    const SizedBox(width: 6),
                    Text(
                      item.formattedTime,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),

              // Title and Notes
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (item.description != null && item.description!.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        item.description!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              Icon(
                Icons.edit_outlined,
                size: 20,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
