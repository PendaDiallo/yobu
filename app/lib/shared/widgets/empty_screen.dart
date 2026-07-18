import 'package:flutter/material.dart';

/// Placeholder du J1 : chaque écran de la liste de docs/01-produit.md existe
/// et est routable, sans contenu. Remplacé au fil des jours.
class EmptyScreen extends StatelessWidget {
  const EmptyScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title — à construire')),
    );
  }
}
