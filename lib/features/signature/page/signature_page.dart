// Package imports:
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:app_supervisores_gt/core/data/repository.dart';
import 'package:app_supervisores_gt/core/global/global_bloc.dart';
import 'package:app_supervisores_gt/features/signature/logic/signature_logic.dart';
import 'package:app_supervisores_gt/features/signature/models/signature_args.dart';
import 'package:app_supervisores_gt/features/signature/page/signature_layout.dart';
import 'package:app_supervisores_gt/utils/injection_container.dart';
import 'package:app_supervisores_gt/utils/widgets/custom_app_bar.dart';

class SignaturePage extends StatelessWidget {
  const SignaturePage({super.key, required this.args});

  final SignatureArgs args;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignatureLogic>(
      create: (context) => SignatureLogic(
        global: sl.get<GlobalBloc>(),
        repository: sl.get<Repository>(),
        args: args,
      ),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Scaffold(
          appBar: CustomAppBar(title: 'Firma', showBackButton: true),
          body: SignatureLayout(),
        ),
      ),
    );
  }
}
