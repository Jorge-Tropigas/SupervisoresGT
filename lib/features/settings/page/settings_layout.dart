// Package imports:
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tomza_kit/ui/themes/colors.dart';
import 'package:tomza_kit/utils/responsive.dart';

// Project imports:
import 'package:app_supervisores_gt/features/settings/widget/info_section.dart';
import 'package:app_supervisores_gt/features/settings/widget/link_item.dart';

class SettingsLayout extends StatefulWidget {
  const SettingsLayout({super.key});

  @override
  State<SettingsLayout> createState() => _SettingsLayoutState();
}

class _SettingsLayoutState extends State<SettingsLayout> {
  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 24.0 : 48.0),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: isMobile ? 24.0 : 48.0),
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  const SizedBox(height: 40),
                  InfoSection(
                    title: 'Soporte Técnico',
                    icon: Icons.support_agent_rounded,
                    items: [
                      LinkItem(
                        label: 'soporte@tomzagroup.com',
                        subtitle: 'Toca para escribirnos',
                        icon: Icons.email_rounded,
                        onTap: () {} /* => handleLaunch(
                              () => model.launchEmail('soporte@tomzagroup.com'),
                              'No encontramos una app de correo instalada.',
                            ), */,
                      ),
                      LinkItem(
                        label: '+502 5858-2601',
                        subtitle: 'Toca para llamar',
                        icon: Icons.phone_rounded,
                        onTap: () {} /* => handleLaunch(
                              () => model.launchPhone('+50258582601'),
                              'No pudimos abrir la app de teléfono.',
                            ), */,
                      ),
                      const SizedBox(height: 24),
                      InfoSection(
                        title: 'Contact Center',
                        icon: Icons.headset_mic_rounded,
                        items: [
                          LinkItem(
                            label: 'Marcación rápida: 1765',
                            subtitle: 'Toca para llamar',
                            icon: Icons.call_rounded,
                            onTap: () {} /*  => handleLaunch(
                              () => model.launchPhone('1765'),
                              'No pudimos abrir la app de teléfono.',
                            ), */,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 48),
          Text(
            '© ${DateTime.now().year} Tomza Group',
            textAlign: TextAlign.center,
            style: GoogleFonts.gabarito(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: TropigasGTColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: TropigasGTColors.layoutBorder.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '2.0.1',
                style: GoogleFonts.gabarito(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: TropigasGTColors.secondaryDark,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
