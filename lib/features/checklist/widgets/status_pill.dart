// Package imports:
import 'package:material_ui/material_ui.dart';

class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.color,
    required this.label,
    required this.done,
  });
  final Color color;
  final String label;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (done)
            const Icon(Icons.check_circle, size: 16, color: Colors.green)
          else
            Icon(Icons.radio_button_unchecked, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
