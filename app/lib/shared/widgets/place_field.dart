import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'yobu_text_field.dart';

/// Une suggestion de lieu, agnostique de sa source (liste locale
/// aujourd'hui, Places Autocomplete demain). `data` transporte l'objet
/// métier de la feature sans que le design system le connaisse.
class PlaceSuggestion {
  const PlaceSuggestion({required this.label, this.data});

  final String label;
  final Object? data;
}

/// PlaceField (docs/03-design-brief.md §3) : YobuTextField + suggestions +
/// état « sélectionné ». La recherche est déléguée via [onSearch].
class PlaceField extends StatefulWidget {
  const PlaceField({
    super.key,
    required this.label,
    required this.onSearch,
    required this.onSelected,
    this.hint,
  });

  final String label;
  final String? hint;
  final Future<List<PlaceSuggestion>> Function(String query) onSearch;

  /// Appelé avec la suggestion choisie, ou `null` quand l'utilisateur
  /// retouche le champ après une sélection.
  final ValueChanged<PlaceSuggestion?> onSelected;

  @override
  State<PlaceField> createState() => _PlaceFieldState();
}

class _PlaceFieldState extends State<PlaceField> {
  final _controller = TextEditingController();
  Timer? _debounce;
  List<PlaceSuggestion> _suggestions = const [];
  bool _selected = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String query) {
    if (_selected) {
      _selected = false;
      widget.onSelected(null);
    }

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () async {
      final results = await widget.onSearch(query);
      if (mounted) setState(() => _suggestions = results);
    });
  }

  void _select(PlaceSuggestion suggestion) {
    _debounce?.cancel();
    setState(() {
      _selected = true;
      _suggestions = const [];
      _controller.text = suggestion.label;
    });
    FocusScope.of(context).unfocus();
    widget.onSelected(suggestion);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        YobuTextField(
          label: widget.label,
          hint: widget.hint,
          controller: _controller,
          onChanged: _onChanged,
          suffix: _selected
              ? const Icon(Icons.check_circle_rounded,
                  color: AppColors.primaryVivid)
              : const Icon(Icons.search_rounded, color: AppColors.inkMuted),
        ),
        if (_suggestions.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.line),
            ),
            constraints: const BoxConstraints(maxHeight: 240),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _suggestions.length,
              separatorBuilder: (_, _) =>
                  const Divider(height: 1, color: AppColors.line),
              itemBuilder: (context, index) {
                final suggestion = _suggestions[index];

                return InkWell(
                  onTap: () => _select(suggestion),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm + AppSpacing.xs,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.place_outlined,
                            size: AppSpacing.lg, color: AppColors.inkMuted),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            suggestion.label,
                            style: AppText.bodySm,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
