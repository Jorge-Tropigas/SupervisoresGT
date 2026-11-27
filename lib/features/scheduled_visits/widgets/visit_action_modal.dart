// Package imports:
import 'package:material_ui/material_ui.dart';
import 'package:tomza_kit/utils/responsive.dart';

// Project imports:
import 'package:app_supervisores_gt/features/scheduled_visits/model/schedule_visits.dart';
import 'package:app_supervisores_gt/features/scheduled_visits/widgets/action_item.dart';

class VisitActionModal extends StatelessWidget {
  const VisitActionModal({
    super.key,
    required this.visit,
    required this.onTapChecklist,
    required this.onTapInventory,
    required this.onTapGoals,
  });

  final ScheduleVisits visit;
  final VoidCallback onTapChecklist;
  final VoidCallback onTapInventory;
  final VoidCallback onTapGoals;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = context.isMobile;
    final ThemeData theme = Theme.of(context);
    final MediaQueryData mq = MediaQuery.of(context);
    final double bottomInset = mq.viewInsets.bottom; // teclado
    final double navBarPadding = mq.padding.bottom;

    return SafeArea(
      top: false,
      child: Container(
        margin: EdgeInsets.only(
          left: isMobile ? 8 : 16,
          right: isMobile ? 8 : 16,
          top: isMobile ? 8 : 12,
          bottom: navBarPadding + (bottomInset > 0 ? 8 : 12),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 28,
          vertical: isMobile ? 20 : 28,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(28),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: .min,
          children: [
            Container(
              width: 52,
              height: 5,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            SizedBox(height: isMobile ? 14 : 18),
            Text(
              'Acciones rápidas',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: isMobile ? 18 : 22,
                letterSpacing: .3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              visit.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                fontSize: isMobile ? 13 : 14,
              ),
            ),
            SizedBox(height: isMobile ? 16 : 20),
            Divider(
              thickness: 1,
              height: 1,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
            SizedBox(height: isMobile ? 20 : 26),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: isMobile ? 12 : 20,
              runSpacing: isMobile ? 14 : 20,
              children: [
                ActionItem(
                  context: context,
                  icon: Icons.check_circle_rounded,
                  label: 'Checklist',
                  color: Colors.blue,
                  onTap: onTapChecklist,
                ),
                ActionItem(
                  context: context,
                  icon: Icons.trending_up_rounded,
                  label: 'Metas',
                  color: Colors.deepPurple,
                  onTap: onTapGoals,
                ),
                ActionItem(
                  context: context,
                  icon: Icons.inventory_2_rounded,
                  label: 'Inventario',
                  color: Colors.green,
                  onTap: onTapInventory,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
