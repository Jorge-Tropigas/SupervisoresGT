// Package imports:
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tomza_kit/ui/themes/colors.dart';
import 'package:tomza_kit/utils/responsive.dart';

// Project imports:
import 'package:app_supervisores_gt/features/dashboard/widgets/animated_sales_gauge.dart';
import 'package:app_supervisores_gt/features/dashboard/widgets/progress_info.dart';

class SalesByDayCard extends StatelessWidget {
  const SalesByDayCard({
    required this.stripes,
    required this.totalGoals,
    required this.calculateProgress,
    required this.getProgressColors,
    super.key,
    this.projected,
  });

  final double stripes;
  final double totalGoals;
  final double? projected;
  final double Function(double stripes, double totalGoals) calculateProgress;
  final Map<String, dynamic> Function(double progressValue) getProgressColors;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = context.isMobile;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final double progressValue = calculateProgress(stripes, totalGoals);

    final Color projectedColor = isDark
        ? Colors.greenAccent
        : TropigasGTColors.circleBackground;
    final Color metaColor = isDark
        ? Colors.orangeAccent
        : TropigasGTColors.primary;
    final Color actualColor = isDark
        ? Colors.blueAccent
        : TropigasGTColors.secondary;

    return Padding(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surfaceTint.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                isMobile ? 16 : 20,
                isMobile ? 16 : 20,
                isMobile ? 16 : 20,
                isMobile ? 8 : 12,
              ),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.propane_tank_rounded,
                    color: TropigasGTColors.circleBackground,
                    size: isMobile ? 20 : 24,
                  ),
                  SizedBox(width: isMobile ? 8 : 12),
                  Expanded(
                    child: Text(
                      'Progreso de Ventas',
                      style: GoogleFonts.alexandria(
                        fontSize: isMobile ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 20,
                vertical: isMobile ? 8 : 12,
              ),
              child: Column(
                children: <Widget>[
                  AnimatedSalesGauge(
                    progress: progressValue.clamp(0, 1),
                    projectedProgress: calculateProgress(
                      projected ?? 0,
                      totalGoals,
                    ).clamp(0, 1),
                    size: isMobile ? 180 : 220,
                    gradientColors: <Color>[
                      projectedColor.withValues(alpha: 0.8),
                      projectedColor,
                    ],
                    backgroundColor: metaColor.withValues(alpha: 0.15),
                    borderColor: metaColor.withValues(alpha: 0.3),
                    needleColor: actualColor,
                    labelStyle: GoogleFonts.alexandria(
                      fontWeight: FontWeight.w700,
                      fontSize: isMobile ? 24 : 28,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    subtitleStyle: GoogleFonts.alexandria(
                      fontWeight: FontWeight.w400,
                      fontSize: isMobile ? 11 : 13,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: isMobile ? 8 : 12),
                  ProgressInfo(
                    progressValue: progressValue,
                    isMobile: isMobile,
                  ),
                  SizedBox(height: isMobile ? 12 : 16),
                  _GoalProjectedRow(
                    goal: totalGoals,
                    projected: projected ?? 0,
                    isMobile: isMobile,
                    metaColor: metaColor,
                    projectedColor: projectedColor,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 20,
                vertical: isMobile ? 8 : 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _ValueTile(
                    title: 'G. Vendidos',
                    value: stripes,
                    icon: Icons.water_drop,
                    color: actualColor,
                    isMobile: isMobile,
                  ),
                  _ValueTile(
                    title: 'Meta',
                    value: totalGoals,
                    icon: Icons.flag,
                    color: metaColor,
                    isMobile: isMobile,
                  ),
                  _ValueTile(
                    title: 'Proyectado',
                    value: projected ?? 0,
                    icon: Icons.trending_up,
                    color: projectedColor,
                    isMobile: isMobile,
                  ),
                ],
              ),
            ),
            SizedBox(height: isMobile ? 16 : 20),
          ],
        ),
      ),
    );
  }
}

class _GoalProjectedRow extends StatelessWidget {
  const _GoalProjectedRow({
    required this.goal,
    required this.projected,
    required this.isMobile,
    required this.metaColor,
    required this.projectedColor,
  });

  final double goal;
  final double projected;
  final bool isMobile;
  final Color metaColor;
  final Color projectedColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _BarIndicator(
            label: 'Meta',
            value: goal,
            color: metaColor,
            isMobile: isMobile,
          ),
        ),
        SizedBox(width: isMobile ? 12 : 16),
        Expanded(
          child: _BarIndicator(
            label: 'Proyectado',
            value: projected,
            color: projectedColor,
            isMobile: isMobile,
          ),
        ),
      ],
    );
  }
}

class _BarIndicator extends StatelessWidget {
  const _BarIndicator({
    required this.label,
    required this.value,
    required this.color,
    required this.isMobile,
  });

  final String label;
  final double value;
  final Color color;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: isMobile ? 10 : 12,
              height: isMobile ? 10 : 12,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            SizedBox(width: isMobile ? 6 : 8),
            Text(
              label,
              style: TextStyle(
                fontSize: isMobile ? 11 : 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value.toStringAsFixed(1),
          style: TextStyle(
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _ValueTile extends StatelessWidget {
  const _ValueTile({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.isMobile,
  });

  final String title;
  final double value;
  final IconData icon;
  final Color color;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Icon(icon, color: color, size: isMobile ? 20 : 24),
        const SizedBox(height: 4),
        Text(
          value.toStringAsFixed(1),
          style: TextStyle(
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: isMobile ? 10 : 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
