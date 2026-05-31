import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ExamsScreen extends StatelessWidget {
  const ExamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Toetsen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('TOETSEN', style: AppTextStyles.label),
            const SizedBox(height: 16),
            Text('Jouw toetsen', style: AppTextStyles.heading2),
            const SizedBox(height: 8),
            Text('Al je toetsen op één plek.', style: AppTextStyles.bodyMuted),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: AppColors.background),
      ),
    );
  }
}
