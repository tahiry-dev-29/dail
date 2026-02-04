import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/molecules/structures/glass_scaffold.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/settings/presentation/components/pro_toggle_card.dart';
import 'package:daily_os/features/settings/presentation/components/settings_header.dart';
import 'package:daily_os/features/settings/presentation/components/settings_item.dart';
import 'package:daily_os/features/settings/presentation/components/settings_section.dart';
import 'package:daily_os/features/settings/presentation/screens/appearance_settings_page.dart';
import 'package:daily_os/features/settings/presentation/screens/notification_settings_page.dart';
import 'package:daily_os/features/settings/presentation/state/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final settingsVM = sl<SettingsViewModel>();
    final isCalSync = settingsVM.isCalendarSyncEnabled.watch(context);
    final colors = context.colors;

    return GlassScaffold(
      body: ListView(
        children: [
          const SettingsHeader(),
          const ProToggleCard(),
          const SizedBox(height: 24),
          SettingsSection(
            title: 'COMPTE',
            children: [
              SettingsItem(
                icon: AppIcons.user(context),
                iconColor: Colors.blueAccent,
                title: 'Profil',
                subtitle: 'Modifier vos informations',
                onTap: () {},
              ),
              SettingsItem(
                icon: AppIcons.bell(context),
                iconColor: Colors.orangeAccent,
                title: 'Notifications',
                subtitle: 'Sons, alertes & rappels',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationSettingsPage(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SettingsSection(
            title: 'PRÉFÉRENCES',
            children: [
              SettingsItem(
                icon: AppIcons.palette(context),
                iconColor: Colors.purpleAccent,
                title: 'Apparence',
                subtitle: "Thème & couleur d'accent",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AppearanceSettingsPage(),
                  ),
                ),
              ),
              SettingsItem(
                icon: AppIcons.calendarCheck(context),
                iconColor: Colors.greenAccent,
                title: 'Calendriers Connectés',
                subtitle: 'Google, Outlook, Apple',
                onTap: () => settingsVM.toggleCalendarSync(!isCalSync),
                trailing: Switch(
                  value: isCalSync,
                  onChanged: (v) => settingsVM.toggleCalendarSync(v),
                  activeTrackColor: colors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SettingsSection(
            title: 'SUPPORT',
            children: [
              SettingsItem(
                icon: AppIcons.circleQuestion(context),
                iconColor: Colors.cyanAccent,
                title: 'Aide & Support',
                subtitle: 'FAQ, Contactez-nous',
                onTap: () {},
              ),
              SettingsItem(
                icon: AppIcons.logout(context),
                iconColor: Colors.redAccent,
                title: 'Déconnexion',
                subtitle: '',
                isDestructive: true,
                onTap: () {},
                trailing: const SizedBox.shrink(),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              'Version 2.4.0 (Build 302)',
              style: TextStyle(fontSize: 11, color: colors.textSecondary),
            ),
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}
