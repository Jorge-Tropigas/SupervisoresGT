// Package imports:
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:app_supervisores_gt/core/data/repository.dart';
import 'package:app_supervisores_gt/core/global/global_bloc.dart';
import 'package:app_supervisores_gt/features/checklist/logic/checklist_logic.dart';
import 'package:app_supervisores_gt/features/checklist/page/checklist_layout.dart';
import 'package:app_supervisores_gt/features/scheduled_visits/model/arguments_by_visits.dart';
import 'package:app_supervisores_gt/utils/injection_container.dart';
import 'package:app_supervisores_gt/utils/widgets/custom_app_bar.dart';

class ChecklistPage extends StatelessWidget {
  const ChecklistPage({super.key, required this.args});

  final ArgumentsByVisits args;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChecklistLogic>(
      create: (context) => ChecklistLogic(
        repository: sl.get<Repository>(),
        args: args,
        global: sl.get<GlobalBloc>(),
      ),
      child: Scaffold(
        appBar: CustomAppBar(title: 'Checklist', showBackButton: true),
        body: ChecklistLayout(),
      ),
    );
  }
}
