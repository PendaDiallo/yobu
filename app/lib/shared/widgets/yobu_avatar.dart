import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Avatar : photo si disponible, sinon initiales en menthe sur vert profond.
/// La pastille « vérifié » est un accent vert vif avec une coche sombre —
/// jamais de blanc sur le vert vif.
class YobuAvatar extends StatelessWidget {
  const YobuAvatar({
    super.key,
    required this.initials,
    this.photoUrl,
    this.size = 48,
    this.verified = false,
  });

  final String initials;
  final String? photoUrl;
  final double size;
  final bool verified;

  @override
  Widget build(BuildContext context) {
    final url = photoUrl;
    final avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
        image: url == null
            ? null
            : DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
      alignment: Alignment.center,
      child: url == null
          ? Text(
              initials.toUpperCase(),
              style: AppText.h2.copyWith(
                color: AppColors.primaryMint,
                fontSize: size * 0.36,
              ),
            )
          : null,
    );

    if (!verified) return avatar;

    final badgeSize = size * 0.38;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          avatar,
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: badgeSize,
              height: badgeSize,
              decoration: BoxDecoration(
                color: AppColors.primaryVivid,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.surface, width: 2),
              ),
              child: Icon(
                Icons.check,
                size: badgeSize * 0.55,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
