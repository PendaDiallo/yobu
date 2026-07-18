import 'package:flutter/material.dart';

import '../../../../shared/widgets/empty_screen.dart';

class TripDetailScreen extends StatelessWidget {
  const TripDetailScreen({super.key, required this.tripId});

  final String tripId;

  @override
  Widget build(BuildContext context) =>
      EmptyScreen(title: 'trip_detail #$tripId');
}
