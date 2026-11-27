// Package imports:
import 'package:material_ui/material_ui.dart';

// Project imports:
import 'package:app_supervisores_gt/features/scheduled_visits/model/date_filter.dart';

class QuickFilters extends StatelessWidget {
  const QuickFilters({
    super.key,
    required this.isMobile,
    required this.current,
    required this.onSelect,
    required this.onCustom,
  });
  final bool isMobile;
  final DateFilter current;
  final ValueChanged<DateFilter> onSelect;
  final VoidCallback onCustom;

  @override
  Widget build(BuildContext context) {
    EdgeInsets pad = EdgeInsets.symmetric(
      horizontal: isMobile ? 8 : 12,
      vertical: 8,
    );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: pad,
      child: Row(
        children: <Widget>[
          _chip(context, 'Hoy', DateFilter.today),
          _chip(context, 'Mañana', DateFilter.tomorrow),
          _chip(context, 'Personalizado', DateFilter.custom, custom: true),
        ],
      ),
    );
  }

  Widget _chip(
    BuildContext context,
    String label,
    DateFilter f, {
    bool custom = false,
  }) {
    bool selected = current == f;
    ThemeData theme = Theme.of(context);
    ColorScheme cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: () => custom ? onCustom() : onSelect(f),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 24,
            vertical: isMobile ? 8 : 12,
          ),
          decoration: BoxDecoration(
            color: selected ? cs.primary : cs.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? cs.primary : cs.outline.withValues(alpha: 0.3),
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: cs.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (custom) ...[
                Icon(
                  Icons.event_note_rounded,
                  size: isMobile ? 16 : 18,
                  color: selected ? cs.onPrimary : cs.onSurface,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  color: selected ? cs.onPrimary : cs.onSurface,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: isMobile ? 13 : 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
