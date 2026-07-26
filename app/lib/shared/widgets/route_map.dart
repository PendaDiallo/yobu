import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// L'itinéraire du trajet, en schéma stylisé.
///
/// Version sans Google Maps SDK (DETTE.md — facturation pas activée) :
/// un tracé dessiné avec les tokens. L'interface ne changera pas quand la
/// vraie carte arrivera — seul l'intérieur de ce widget bougera.
class RouteMap extends StatelessWidget {
  const RouteMap({
    super.key,
    required this.originLabel,
    required this.destLabel,
    this.pickupLabel,
  });

  final String originLabel;
  final String destLabel;

  /// Ex. « Te prend à ~150 m de ton départ ».
  final String? pickupLabel;

  @override
  Widget build(BuildContext context) {
    final pickupLabel = this.pickupLabel;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 96,
            width: double.infinity,
            child: CustomPaint(painter: _RoutePainter()),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Text(
                  originLabel,
                  style: AppText.caption.copyWith(color: AppColors.inkMuted),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.arrow_forward_rounded,
                  size: AppSpacing.md, color: AppColors.inkMuted),
              Expanded(
                child: Text(
                  destLabel,
                  style: AppText.caption.copyWith(color: AppColors.inkMuted),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (pickupLabel != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryVivid,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    pickupLabel,
                    style: AppText.caption.copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final start = Offset(size.width * 0.06, size.height * 0.82);
    final end = Offset(size.width * 0.94, size.height * 0.2);

    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..cubicTo(
        size.width * 0.35, size.height * 0.95,
        size.width * 0.6, size.height * 0.05,
        end.dx, end.dy,
      );

    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawCircle(start, 6, Paint()..color = AppColors.primaryVivid);
    canvas.drawCircle(end, 6, Paint()..color = AppColors.primary);
    canvas.drawCircle(
      end,
      10,
      Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
