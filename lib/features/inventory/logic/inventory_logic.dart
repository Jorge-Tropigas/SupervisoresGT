// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:material_ui/material_ui.dart';
import 'package:tomza_kit/tomza_kit.dart';

// Project imports:
import 'package:app_supervisores_gt/core/data/model/request/create_update_inventory_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/get_inventory_request.dart';
import 'package:app_supervisores_gt/core/data/repository.dart';
import 'package:app_supervisores_gt/features/inventory/models/inventory.dart';
import 'package:app_supervisores_gt/features/scheduled_visits/model/arguments_by_visits.dart';

class InventoryLogic extends ChangeNotifier {
  InventoryLogic({required this.args, required this._repository}) {
    getInventory();
  }

  final Repository _repository;
  final ArgumentsByVisits args;

  List<Inventory> _listInventory = [];
  List<Inventory> get listInventory => _listInventory;

  final TextEditingController fullCylindersController = TextEditingController();
  final TextEditingController emptyCylindersController =
      TextEditingController();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future<void> getInventory() async {
    setLoading(true);

    if (!await NetworkUtils.hasInternet()) {
      showError('No tienes conexión a internet');
      setLoading(false);
      return;
    }

    if (!await ConnectivityHandler.hasExcellentSignal()) {
      showError(
        'Señal débil o inestable. Para anular una factura debe tener una señal excelente',
      );
      setLoading(false);
      return;
    }

    try {
      final request = GetInventoryRequest(
        idVisit: args.visitId,
        salePoint: args.pointSale,
      );
      final result = await _repository.getInventory(request);
      setLoading(false);

      _listInventory = result.listInventory;
    } catch (e) {
      setLoading(false);
      showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> updateInventory(BuildContext context, Inventory item) async {
    int llenos = item.fullCylinder ?? 0;
    int vacios = item.emptyCylinder ?? 0;
    final int asignados = item.assignedIPDV;
    fullCylindersController.text = llenos.toString();
    emptyCylindersController.text = vacios.toString();

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Ingreso de Inventario'),
          content: Column(
            mainAxisSize: .min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Llenos',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => setStateDialog(() {
                      if (llenos > 0) {
                        llenos--;
                        fullCylindersController.text = llenos.toString();
                      }
                    }),
                  ),
                  Expanded(
                    child: TextField(
                      controller: fullCylindersController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 18,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      onTap: () {
                        if (fullCylindersController.text.trim() == '0') {
                          fullCylindersController.clear();
                          setStateDialog(() {
                            llenos = 0;
                          });
                        } else {
                          final String t = fullCylindersController.text;
                          fullCylindersController.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: t.length,
                          );
                        }
                      },
                      onChanged: (String v) => setStateDialog(() {
                        final int? parsed = int.tryParse(v);
                        llenos = (parsed != null && parsed >= 0) ? parsed : 0;
                      }),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => setStateDialog(() {
                      llenos++;
                      fullCylindersController.text = llenos.toString();
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Vacíos',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => setStateDialog(() {
                      if (vacios > 0) {
                        vacios--;
                        emptyCylindersController.text = vacios.toString();
                      }
                    }),
                  ),
                  Expanded(
                    child: TextField(
                      controller: emptyCylindersController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 18,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      onTap: () {
                        if (emptyCylindersController.text.trim() == '0') {
                          emptyCylindersController.clear();
                          setStateDialog(() {
                            vacios = 0;
                          });
                        } else {
                          final String t = emptyCylindersController.text;
                          emptyCylindersController.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: t.length,
                          );
                        }
                      },
                      onChanged: (String v) => setStateDialog(() {
                        final int? parsed = int.tryParse(v);
                        vacios = (parsed != null && parsed >= 0) ? parsed : 0;
                      }),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => setStateDialog(() {
                      vacios++;
                      emptyCylindersController.text = vacios.toString();
                    }),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TomzaTextButton(
              label: 'Cancelar',
              textColor: TropigasGTColors.error,
              fontSize: 16,
              fontWeight: .normal,
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TomzaTextButton(
              label: 'Aceptar',
              textColor: TropigasGTColors.primary,
              fontSize: 16,
              fontWeight: .normal,
              onPressed: () {
                final fullFinal =
                    int.tryParse(fullCylindersController.text) ?? 0;
                final emptyFinal =
                    int.tryParse(emptyCylindersController.text) ?? 0;

                int clampedLlenos = fullFinal <= 0 ? 0 : fullFinal;
                int clampedVacios = emptyFinal <= 0 ? 0 : emptyFinal;

                final int newShortages =
                    (clampedLlenos + clampedVacios) - asignados;
                final int index = _listInventory.indexOf(item);

                if (index != -1) {
                  _listInventory = List<Inventory>.from(_listInventory);
                  _listInventory[index] = Inventory(
                    missingCylinder: newShortages,
                    fullCylinder: clampedLlenos,
                    emptyCylinder: clampedVacios,
                    companyOwnedCylinder: item.companyOwnedCylinder,
                    description: item.description,
                    assignedIPDV: item.assignedIPDV,
                    presentation: item.presentation,
                    product: item.product,
                    inventoryVisitId: item.inventoryVisitId,
                  );
                }
                Navigator.of(dialogContext).pop();
                if (index != -1) {
                  notifyListeners();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> createUpdateInventory(BuildContext context) async {
    setLoading(true);

    if (!await NetworkUtils.hasInternet()) {
      showError('No tienes conexión a internet');
      setLoading(false);
      return;
    }

    if (!await ConnectivityHandler.hasExcellentSignal()) {
      showError(
        'Señal débil o inestable. Para anular una factura debe tener una señal excelente',
      );
      setLoading(false);
      return;
    }

    try {
      final request = CreateUpdateInventoryRequest(
        visitId: args.visitId,
        listInventory: listInventory,
      );
      final result = await _repository.createUpdateInventory(request);
      setLoading(false);

      showSuccess(result.message ?? 'Inventario guardado exitosamente');
      Navigator.pop(context);
    } catch (e) {
      setLoading(false);
      showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
