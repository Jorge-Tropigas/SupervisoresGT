// Dart imports:
import 'dart:io';
import 'dart:typed_data';

// Package imports:
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:tomza_kit/tomza_kit.dart';
import 'package:tomza_kit/ui/components/input/tomza_user_input.dart';

// Project imports:
import 'package:app_supervisores_gt/core/data/repository.dart';
import 'package:app_supervisores_gt/core/global/global_bloc.dart';
import 'package:app_supervisores_gt/features/photo_descripcion/logic/photo_description_logic.dart';
import 'package:app_supervisores_gt/features/photo_descripcion/models/photo_arguments.dart';
import 'package:app_supervisores_gt/utils/injection_container.dart';
import 'package:app_supervisores_gt/utils/widgets/custom_app_bar.dart';

class PhotoDescriptionPage extends StatelessWidget {
  const PhotoDescriptionPage({
    super.key,
    required this.title,
    required this.args,
  });

  final String title;
  final PhotoArguments args;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PhotoDescriptionLogic>(
      create: (context) => PhotoDescriptionLogic(
        args: args,
        repository: sl.get<Repository>(),
        global: sl.get<GlobalBloc>(),
      ),
      child: Consumer<PhotoDescriptionLogic>(
        builder: (context, logic, child) {
          return Scaffold(
            appBar: CustomAppBar(title: title, showBackButton: true),
            body: logic.isLoading
                ? Center(
                    child: Lottie.asset(
                      'assets/animations/loading_fire.json',
                      width: 260,
                      height: 260,
                    ) /* CircularProgressIndicator(
                      color: TropigasGTColors.circleBackground,
                    ), */,
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                            itemCount: PhotoDescriptionLogic.maxPhotos,
                            itemBuilder: (_, index) {
                              final localFile = logic.localImages[index];
                              final existing = logic.existingPhotoAtSlot(index);

                              if (localFile != null) {
                                return _UploadPhotoCard(
                                  image: localFile,
                                  label: 'Foto ${index + 1}',
                                  onTap: () => logic.pickImage(index),
                                  onRemove: () => logic.removeImage(index),
                                );
                              }

                              if (existing != null) {
                                return _ExistingPhotoCard(
                                  photoBytes: existing.decodedBytes,
                                  label: 'Foto ${existing.index}',
                                );
                              }

                              return _UploadPhotoCard(
                                image: null,
                                label: 'Foto ${index + 1}',
                                onTap: () => logic.pickImage(index),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: UserInput(
                            title: 'Observaciones',
                            controller: logic.observationsController,
                            maxLength: 150,
                            maxLines:
                                logic.observationsController.text.length < 150
                                ? null
                                : 150,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TomzaPrimaryButton(
                          label: 'Guardar',
                          icon: Icons.save,
                          onPressed: () =>
                              logic.observationsController.text.isEmpty
                              ? showInfo('Debe ingresar una observación')
                              : logic.createUpdateIncident(context),
                        ),
                      ],
                    ),
                  ),
            floatingActionButton: logic.slotsWithPhotos.isNotEmpty
                ? FloatingActionButton.small(
                    onPressed: () => logic.showSlotPicker(context),
                    child: const Icon(Icons.add_a_photo),
                  )
                : null,
          );
        },
      ),
    );
  }
}

class _ExistingPhotoCard extends StatelessWidget {
  const _ExistingPhotoCard({required this.photoBytes, required this.label});

  final Uint8List photoBytes;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TropigasGTColors.layout,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(photoBytes, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: GoogleFonts.gabarito()),
        ],
      ),
    );
  }
}

class _UploadPhotoCard extends StatelessWidget {
  const _UploadPhotoCard({
    required this.image,
    required this.label,
    required this.onTap,
    this.onRemove,
  });

  final File? image;
  final String label;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: TropigasGTColors.layout,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: image != null
                ? Colors.transparent
                : TropigasGTColors.circleBackground,
            width: 2,
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: image != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(image!, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: onRemove,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    size: 40,
                    color: TropigasGTColors.circleBackground,
                  ),
                  const SizedBox(height: 8),
                  Text(label, style: GoogleFonts.gabarito()),
                ],
              ),
      ),
    );
  }
}
