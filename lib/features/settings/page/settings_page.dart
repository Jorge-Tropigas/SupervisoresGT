// Package imports:
import 'package:material_ui/material_ui.dart';

// Project imports:
import 'package:app_supervisores_gt/features/settings/page/settings_layout.dart';
import 'package:app_supervisores_gt/utils/widgets/custom_app_bar.dart';
import 'package:app_supervisores_gt/utils/widgets/custom_bottom_navigator.dart';
import 'package:app_supervisores_gt/utils/widgets/custom_drawer.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Soporte', showDrawerButton: false),
      drawer: CustomDrawer(),
      bottomNavigationBar: CustomBottomNavigator(currentIndex: 4),
      body: SettingsLayout(),
    );
  }
}
