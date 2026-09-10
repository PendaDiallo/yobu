import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../shared/theme/tokens.dart';
import '../../../../shared/widgets/star_rating.dart';
import '../../../../shared/widgets/tag_chip.dart';
import '../../../../shared/widgets/yobu_avatar.dart';
import '../../../../shared/widgets/yobu_button.dart';
import '../../../../shared/widgets/yobu_text_field.dart';
import '../rating_controller.dart';

/// Ce qu'il faut pour noter : le booking et de quoi afficher la personne.
/// Passé en `state.extra` depuis « Mes réservations ».
class RatingArgs {
  const RatingArgs({
    required this.bookingId,
    required this.tripId,
    required this.personName,
    required this.personInitials,
    this.personPhotoUrl,
  });

  final int bookingId;
  final int tripId;
  final String personName;
  final String personInitials;
  final String? personPhotoUrl;
}

class RatingScreen extends ConsumerStatefulWidget {
  const RatingScreen({super.key, required this.args});

  final RatingArgs? args;

  @override
  ConsumerState<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends ConsumerState<RatingScreen> {
  /// clé API → libellé affiché (docs/02-technique.md §3).
  static const _tags = {
    'ponctuel': 'Ponctuel',
    'sympa': 'Sympa',
    'conduite_sure': 'Conduite sûre',
    'voiture_propre': 'Voiture propre',
  };

  int _score = 0;
  final Set<String> _selectedTags = {};
  final _comment = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _send(RatingArgs args) async {
    setState(() => _busy = true);
    try {
      await ref.read(ratingControllerProvider).submit(
            bookingId: args.bookingId,
            tripId: args.tripId,
            score: _score,
            tags: _selectedTags.toList(),
            comment: _comment.text.trim().isEmpty ? null : _comment.text.trim(),
          );
      if (mounted) context.pop(true);
    } on AppException catch (exception) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(exception.message),
          backgroundColor: AppColors.danger,
        ));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = widget.args;
    if (args == null) {
      return const Scaffold(
        body: Center(child: Text('Rien à noter.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Noter le trajet')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Row(
              children: [
                YobuAvatar(
                  initials: args.personInitials,
                  photoUrl: args.personPhotoUrl,
                  size: AppSpacing.xxl,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(args.personName,
                      style: AppText.h1, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('TA NOTE', style: AppText.label),
            const SizedBox(height: AppSpacing.sm),
            Center(
              child: StarRating(
                value: _score.toDouble(),
                onChanged: (value) => setState(() => _score = value),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('CE QUI T\'A MARQUÉ', style: AppText.label),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final entry in _tags.entries)
                  TagChip(
                    label: entry.value,
                    selected: _selectedTags.contains(entry.key),
                    onTap: () => setState(() {
                      _selectedTags.contains(entry.key)
                          ? _selectedTags.remove(entry.key)
                          : _selectedTags.add(entry.key);
                    }),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            YobuTextField(
              label: 'Un mot (facultatif)',
              controller: _comment,
              hint: 'Ce que tu veux ajouter',
            ),
            const SizedBox(height: AppSpacing.xl),
            YobuButton(
              label: 'Envoyer',
              loading: _busy,
              onPressed: _score == 0 || _busy ? null : () => _send(args),
            ),
          ],
        ),
      ),
    );
  }
}
