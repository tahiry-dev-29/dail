import 'package:daily_os/design_system/molecules/structures/glass_scaffold.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/settings/presentation/components/pro_toggle_card.dart';
import 'package:daily_os/features/settings/presentation/components/settings_header.dart';
import 'package:daily_os/features/settings/presentation/components/settings_item.dart';
import 'package:daily_os/features/settings/presentation/components/settings_section.dart';
import 'package:daily_os/features/settings/presentation/providers/settings_provider.dart';
import 'package:daily_os/features/settings/presentation/screens/appearance_settings_page.dart';
import 'package:daily_os/features/settings/presentation/screens/notification_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signals_flutter/signals_flutter.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final isCalSync = isCalendarSyncEnabled.watch(context);
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
                icon: FontAwesomeIcons.user,
                iconColor: Colors.blueAccent,
                title: 'Profil',
                subtitle: 'Modifier vos informations',
                onTap: () {},
              ),
              SettingsItem(
                icon: FontAwesomeIcons.bell,
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
                icon: FontAwesomeIcons.palette,
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
                icon: FontAwesomeIcons.calendarCheck,
                iconColor: Colors.greenAccent,
                title: 'Calendriers Connectés',
                subtitle: 'Google, Outlook, Apple',
                onTap: () =>
                    isCalendarSyncEnabled.value = !isCalendarSyncEnabled.value,
                trailing: Switch(
                  value: isCalSync,
                  onChanged: (v) => isCalendarSyncEnabled.value = v,
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
                icon: FontAwesomeIcons.circleQuestion,
                iconColor: Colors.cyanAccent,
                title: 'Aide & Support',
                subtitle: 'FAQ, Contactez-nous',
                onTap: () {},
              ),
              SettingsItem(
                icon: FontAwesomeIcons.arrowRightFromBracket,
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
