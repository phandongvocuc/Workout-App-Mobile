import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/strings.dart';
import '../../providers/notification_settings_provider.dart';
import '../../providers/schedule_provider.dart';
import '../../providers/theme_provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Refresh permission check on screen open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationSettingsProvider>().checkPermissionStatus();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Re-check permissions when returning from system settings
      context.read<NotificationSettingsProvider>().checkPermissionStatus();
    }
  }

  Future<void> _handleNotificationToggle(bool enabled) async {
    final notifSettings = context.read<NotificationSettingsProvider>();
    final scheduleProvider = context.read<ScheduleProvider>();

    if (enabled) {
      final granted = await notifSettings.requestNotificationPermission();
      if (!granted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Notification permission is needed for workout reminders.',
            ),
          ),
        );
      }
    }

    await notifSettings.setNotificationsEnabled(enabled);

    // Resync scheduled notifications
    await scheduleProvider.resyncNotifications(
      leadMinutes: notifSettings.reminderLeadMinutes,
      notificationsEnabled: enabled,
    );
  }

  Future<void> _handleLeadTimeChange(int minutes) async {
    final notifSettings = context.read<NotificationSettingsProvider>();
    final scheduleProvider = context.read<ScheduleProvider>();

    await notifSettings.setReminderLeadMinutes(minutes);

    // Resync notifications with new lead time
    await scheduleProvider.resyncNotifications(
      leadMinutes: minutes,
      notificationsEnabled: notifSettings.notificationsEnabled,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reminder schedule updated with new lead time.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeProvider = context.watch<ThemeProvider>();
    final notifSettings = context.watch<NotificationSettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.accountTitle),
            Text(
              'App preferences & offline storage',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        children: [
          // SECTION 1: APPEARANCE
          _buildSectionHeader(
            icon: Icons.palette_outlined,
            title: AppStrings.appearanceSection,
            colorScheme: colorScheme,
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Theme Mode',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.system,
                        label: Text(AppStrings.themeSystem),
                        icon: Icon(Icons.brightness_auto, size: 18),
                      ),
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: Text(AppStrings.themeLight),
                        icon: Icon(Icons.light_mode, size: 18),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        label: Text(AppStrings.themeDark),
                        icon: Icon(Icons.dark_mode, size: 18),
                      ),
                    ],
                    selected: {themeProvider.themeMode},
                    onSelectionChanged: (Set<ThemeMode> newSelection) {
                      themeProvider.setThemeMode(newSelection.first);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // SECTION 2: NOTIFICATIONS
          _buildSectionHeader(
            icon: Icons.notifications_active_outlined,
            title: AppStrings.notificationsSection,
            colorScheme: colorScheme,
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  // Master toggle
                  SwitchListTile(
                    title: const Text(
                      AppStrings.enableReminders,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text(
                      AppStrings.enableRemindersSubtitle,
                      style: TextStyle(fontSize: 12),
                    ),
                    value: notifSettings.notificationsEnabled,
                    onChanged: _handleNotificationToggle,
                  ),
                  const Divider(height: 1),

                  // Lead time selector
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.reminderLeadTime,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              _formatLeadTime(notifSettings.reminderLeadMinutes),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          children: [
                            _buildLeadTimeChip(30, '30 min', notifSettings),
                            _buildLeadTimeChip(60, '1 hour', notifSettings),
                            _buildLeadTimeChip(360, '6 hours', notifSettings),
                            _buildLeadTimeChip(720, '12 hours', notifSettings),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Permission Warning Banner if denied
                  if (!notifSettings.isPermissionGranted) ...[
                    const Divider(height: 1),
                    Container(
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.errorContainer.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: colorScheme.error,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Permission Required',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.error,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            AppStrings.notificationPermissionDenied,
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onErrorContainer,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 8),
                          FilledButton.tonal(
                            onPressed: notifSettings.openSystemSettings,
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                            ),
                            child: const Text(AppStrings.grantPermission),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // SECTION 3: ABOUT
          _buildSectionHeader(
            icon: Icons.info_outline,
            title: AppStrings.aboutSection,
            colorScheme: colorScheme,
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.water_drop,
                          color: colorScheme.primary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.appName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            AppStrings.appVersion,
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    AppStrings.aboutDescription,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.45,
                      color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.85),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.verified_user_outlined,
                          size: 18,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            '100% Offline • Zero Analytics • Local SQLite DB',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadTimeChip(
    int minutes,
    String label,
    NotificationSettingsProvider notifSettings,
  ) {
    final isSelected = notifSettings.reminderLeadMinutes == minutes;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: notifSettings.notificationsEnabled
          ? (selected) {
              if (selected) {
                _handleLeadTimeChange(minutes);
              }
            }
          : null,
    );
  }

  String _formatLeadTime(int minutes) {
    switch (minutes) {
      case 30:
        return AppStrings.reminderLead30m;
      case 60:
        return AppStrings.reminderLead1h;
      case 360:
        return AppStrings.reminderLead6h;
      case 720:
        return AppStrings.reminderLead12h;
      default:
        return '$minutes minutes before';
    }
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required ColorScheme colorScheme,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
