import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profiel')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text('Jouw account', style: AppTextStyles.heading2),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Nipt Pro', style: AppTextStyles.heading3),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.accent.withOpacity(0.4)),
                        ),
                        child: Text('BINNENKORT', style: AppTextStyles.label.copyWith(color: AppColors.accent)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Onbeperkte toetsen, kalender-koppeling en meer.', style: AppTextStyles.bodyMuted),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _PlaceholderTile(label: 'Herinneringen', tag: 'BINNENKORT'),
            _PlaceholderTile(label: 'Streaks', tag: 'BINNENKORT'),
            _PlaceholderTile(label: 'Kalender-koppeling', tag: 'BINNENKORT'),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderTile extends StatelessWidget {
  final String label;
  final String tag;
  const _PlaceholderTile({required this.label, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTextStyles.body)),
          Text(tag, style: AppTextStyles.label),
        ],
      ),
    );
  }
}
