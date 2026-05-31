import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PlanningScreen extends StatelessWidget {
  const PlanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Planning')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('BINNENKORT', style: AppTextStyles.label),
            const SizedBox(height: 16),
            Text('Week-planning', style: AppTextStyles.heading2),
            const SizedBox(height: 8),
            Text('Automatische studie-blokken op basis\nvan je beschikbare tijd.', style: AppTextStyles.bodyMuted, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
