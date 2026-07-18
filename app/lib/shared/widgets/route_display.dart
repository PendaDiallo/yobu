import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// La ligne verticale point A → point B avec les labels.
/// Le point de départ est un accent vert vif, l'arrivée un point vert profond.
class RouteDisplay extends StatelessWidget {
  const RouteDisplay({
    super.key,
    required this.originLabel,
    required this.destLabel,
    this.dense = false,
  });

  final String originLabel;
  final String destLabel;

  /// Version compacte pour l'intérieur des cartes (`TripCard`).
  final bool dense;

  static const _dotSize = 10.0;

  Widget _dot({required bool origin}) {
    return Container(
      width: _dotSize,
      height: _dotSize,
      decoration: BoxDecoration(
        color: origin ? AppColors.primaryVivid : AppColors.primary,
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = dense ? AppText.bodySm : AppText.body;
    final labelStyle = style.copyWith(fontWeight: FontWeight.w700);
    final gap = dense ? AppSpacing.md : AppSpacing.lg;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: style.fontSize! * 0.25),
                child: _dot(origin: true),
              ),
              Expanded(
                child: Container(width: 2, color: AppColors.line),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: style.fontSize! * 0.25),
                child: _dot(origin: false),
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(originLabel,
                    style: labelStyle, overflow: TextOverflow.ellipsis),
                SizedBox(height: gap),
                Text(destLabel,
                    style: labelStyle, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
