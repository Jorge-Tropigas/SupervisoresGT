// Package imports:
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:tomza_kit/tomza_kit.dart';

// Project imports:
import 'package:app_supervisores_gt/features/signature/logic/signature_logic.dart';

class SignatureLayout extends StatelessWidget {
  const SignatureLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignatureLogic>(
      builder: (context, logic, child) => Column(
        children: [
          SizedBox(height: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 12.0),
                child: Text(
                  'Firme dentro del cuadro blanco',
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              SizedBox(width: 32),
              if (logic.hasSigned) ...[
                Column(
                  children: [
                    TomzaTextButton(
                      label: 'Limpiar',
                      textColor: TropigasGTColors.error,
                      onPressed: logic.clear,
                    ),
                    SizedBox(height: 12),
                    TomzaPrimaryButton(
                      label: 'Guardar',
                      onPressed: () async {
                        await logic.saveSignature(context);
                      },
                    ),
                  ],
                ),
              ],
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
              ),
              child: SfSignaturePad(
                key: logic.signatureKey,
                minimumStrokeWidth: 2,
                maximumStrokeWidth: 3,
                onDrawStart: () {
                  logic.onDrawStart();
                  return false;
                },
              ),
            ),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}
