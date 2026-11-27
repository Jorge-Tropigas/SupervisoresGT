// Package imports:
import 'package:material_ui/material_ui.dart';
import 'package:tomza_kit/utils/responsive.dart';

// Project imports:
import 'package:app_supervisores_gt/features/inventory/models/inventory.dart';

class InventoryTable extends StatelessWidget {
  const InventoryTable({
    super.key,
    required this.listInventory,
    required this.onTap,
  });

  final List<Inventory> listInventory;
  final Function(Inventory) onTap;

  static const List<Color> palette = <Color>[
    Color(0xFFE3F2FD), // azul claro
    Color(0xFFE8F5E9), // verde claro
    Color(0xFFFFF3E0), // naranja claro
    Color(0xFFFFEBEE), // rojo claro
    Color(0xFFEDE7F6), // morado claro
  ];

  Color rowColor(int presentation) {
    final int idx = presentation.hashCode.abs() % palette.length;
    return palette[idx];
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = context.isMobile;

    final TextTheme tt = Theme.of(context).textTheme;
    final double fontSize = isMobile ? 12.0 : 13.5;

    final TextStyle headerStyle = tt.labelMedium!.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: 0.3,
    );

    final List<DataColumn> columns = <DataColumn>[
      const DataColumn(label: SizedBox.shrink()),
      const DataColumn(label: Text('Asignado')),
      const DataColumn(label: Text('Llenos')),
      const DataColumn(label: Text('Vacíos')),
      const DataColumn(label: Text('Dif')),
    ];

    final List<DataRow> rows = listInventory.map((item) {
      final int full = item.fullCylinder ?? 0;
      final int empty = item.emptyCylinder ?? 0;
      final bool hasInput =
          item.assignedIPDV > 0 &&
          (item.fullCylinder != null || item.emptyCylinder != null);
      final int sum = full + empty;
      final int diff = sum - item.assignedIPDV;
      final Color base = rowColor(item.presentation);
      final Color diffColor = !hasInput
          ? Theme.of(context).disabledColor
          : diff == 0
          ? Theme.of(context).colorScheme.onSurface
          : Colors.red;

      Widget diffBadge() {
        if (!hasInput) {
          return Text('-', style: TextStyle(fontSize: fontSize));
        }
        final bool isZero = diff == 0;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isZero
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.12)
                : Colors.red.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: isZero
                  ? Theme.of(context).colorScheme.primary
                        .withValues(alpha: 0.55)
                  : Colors.red.withValues(alpha: 0.55),
            ),
          ),
          child: Text(
            diff.toString(),
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: diffColor,
            ),
          ),
        );
      }

      return DataRow(
        color: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) => base.withValues(
            alpha: states.contains(WidgetState.hovered) ? 0.9 : 0.75,
          ),
        ),
        cells: <DataCell>[
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: <Color>[
                        Theme.of(context).colorScheme.primary
                            .withValues(alpha: 0.85),
                        Theme.of(context).colorScheme.primary
                            .withValues(alpha: 0.55),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: EdgeInsets.all(isMobile ? 8 : 10),
                  child: Icon(
                    Icons.propane_tank_rounded,
                    color: Colors.white,
                    size: isMobile ? 22 : 26,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${item.presentation} lbs',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      width: 90,
                      child: Text(
                        item.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: fontSize - 2,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          DataCell(
            Text(
              item.assignedIPDV.toString(),
              style: TextStyle(fontSize: fontSize),
            ),
          ),
          DataCell(
            onTap: () => onTap(item),
            Text(
              item.fullCylinder?.toString() ?? '-',
              style: TextStyle(fontSize: fontSize),
            ),
          ),
          DataCell(
            onTap: () => onTap(item),
            Text(
              item.emptyCylinder?.toString() ?? '-',
              style: TextStyle(fontSize: fontSize),
            ),
          ),
          DataCell(diffBadge()),
        ],
      );
    }).toList();

    final Widget dataTable = DataTable(
      headingTextStyle: headerStyle,
      dataRowMinHeight: isMobile ? 60 : 64,
      dataRowMaxHeight: isMobile ? 60 : 64,
      headingRowHeight: isMobile ? 42 : 48,
      horizontalMargin: isMobile ? 8 : 12,
      columnSpacing: isMobile ? 18 : 26,
      showCheckboxColumn: false,
      columns: columns,
      rows: rows,
    );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: dataTable,
          ),
        );
      },
    );
  }
}
