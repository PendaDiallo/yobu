import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../shared/theme/tokens.dart';
import '../../../../shared/widgets/yobu_avatar.dart';
import '../../../../shared/widgets/yobu_button.dart';
import '../../../../shared/widgets/yobu_text_field.dart';
import '../../domain/user.dart';
import '../profile_controller.dart';

/// Le formulaire partagé entre profile_setup et profile_edit : photo,
/// prénom, nom, rôle. L'écran hôte fournit le titre, le libellé du CTA
/// et la navigation de sortie.
class ProfileForm extends ConsumerStatefulWidget {
  const ProfileForm({
    super.key,
    required this.ctaLabel,
    required this.onSaved,
    this.initial,
  });

  final String ctaLabel;
  final VoidCallback onSaved;

  /// Pré-remplissage (profile_edit). Null en setup.
  final User? initial;

  @override
  ConsumerState<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends ConsumerState<ProfileForm> {
  late final _firstName =
      TextEditingController(text: widget.initial?.firstName);
  late final _lastName = TextEditingController(text: widget.initial?.lastName);
  String? _role;
  XFile? _photo;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _role = widget.initial?.role;
    _firstName.addListener(_refresh);
    _lastName.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    super.dispose();
  }

  bool get _complete =>
      _firstName.text.trim().isNotEmpty &&
      _lastName.text.trim().isNotEmpty &&
      _role != null;

  Future<void> _pickPhoto() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 90,
    );
    if (picked != null) setState(() => _photo = picked);
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(profileControllerProvider.notifier).saveProfile(
            firstName: _firstName.text.trim(),
            lastName: _lastName.text.trim(),
            role: _role!,
            photoPath: _photo?.path,
          );
      if (mounted) widget.onSaved();
    } on AppException catch (exception) {
      setState(() {
        _saving = false;
        _error = exception.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final error = _error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(child: _PhotoPicker(photo: _photo, initial: widget.initial,
            onTap: _pickPhoto)),
        const SizedBox(height: AppSpacing.lg),
        YobuTextField(
          label: 'Prénom',
          hint: 'Awa',
          controller: _firstName,
        ),
        const SizedBox(height: AppSpacing.md),
        YobuTextField(
          label: 'Nom',
          hint: 'Ndiaye',
          controller: _lastName,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'JE SUIS',
          style: AppText.label.copyWith(color: AppColors.inkMuted),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            for (final (value, label, icon) in const [
              ('driver', 'Conducteur', Icons.directions_car_outlined),
              ('rider', 'Passager', Icons.hail_rounded),
              ('both', 'Les deux', Icons.swap_horiz_rounded),
            ]) ...[
              if (value != 'driver') const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _RoleCard(
                  label: label,
                  icon: icon,
                  selected: _role == value,
                  onTap: () => setState(() => _role = value),
                ),
              ),
            ],
          ],
        ),
        const Spacer(),
        if (error != null) ...[
          Text(
            error,
            style: AppText.bodySm.copyWith(color: AppColors.danger),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        YobuButton(
          label: widget.ctaLabel,
          loading: _saving,
          onPressed: _complete && !_saving ? _save : null,
        ),
      ],
    );
  }
}

class _PhotoPicker extends StatelessWidget {
  const _PhotoPicker({
    required this.photo,
    required this.initial,
    required this.onTap,
  });

  final XFile? photo;
  final User? initial;
  final VoidCallback onTap;

  static const _size = 96.0;

  @override
  Widget build(BuildContext context) {
    final photo = this.photo;
    final initials = [
      initial?.firstName,
      initial?.lastName,
    ].map((part) => part?.isNotEmpty == true ? part![0] : '').join();

    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (photo != null)
            Container(
              width: _size,
              height: _size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: FileImage(File(photo.path)),
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            YobuAvatar(
              initials: initials.isEmpty ? '?' : initials,
              photoUrl: initial?.photoUrl,
              size: _size,
            ),
          Positioned(
            right: -AppSpacing.xs,
            bottom: -AppSpacing.xs,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.surface, width: 2),
              ),
              child: const Icon(
                Icons.photo_camera_outlined,
                size: AppSpacing.md,
                color: AppColors.primaryMint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primarySurface : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.line,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Column(
            children: [
              Icon(icon,
                  color: selected ? AppColors.primary : AppColors.inkMuted),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: AppText.caption.copyWith(
                  color: selected ? AppColors.primary : AppColors.inkMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
