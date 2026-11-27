// Package imports:
import 'package:lottie/lottie.dart';
import 'package:material_ui/material_ui.dart';

/// Placeholder reutilizable para estados vacíos en el dashboard.
/// Mantiene consistencia visual ocupando el mismo alto que un gráfico.
class EmptyStatePlaceholder extends StatelessWidget {
  const EmptyStatePlaceholder({
    required this.height,
    required this.onRetry,
    this.message = 'Sin datos disponibles',
    this.animationAsset,
    super.key,
  });

  final double height;
  final VoidCallback onRetry;
  final String message;
  final String? animationAsset;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;
    Color fg = theme.colorScheme.onSurface.withValues(alpha: 0.75);

    return SizedBox(
      height: height,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Animación o ícono
            SizedBox(
              height: height * 0.45,
              child: animationAsset != null
                  ? Lottie.asset(
                      animationAsset!,
                      repeat: true,
                      fit: BoxFit.contain,
                    )
                  : Icon(
                      Icons.insights_outlined,
                      size: height * 0.28,
                      color: fg,
                    ),
            ),
            const SizedBox(height: 12),
            Text(
              message.toUpperCase(),
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                color: fg,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Desliza para refrescar o toca el botón',
              style: theme.textTheme.bodySmall?.copyWith(
                color: fg.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                backgroundColor: isDark
                    ? theme.colorScheme.primary.withValues(alpha: 0.25)
                    : theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
