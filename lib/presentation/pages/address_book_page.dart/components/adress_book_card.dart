import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/app_typography.dart';
import 'package:hr_tcc/presentation/pages/address_book_page.dart/components/components.dart';

class AdressBookCard extends StatelessWidget {
  final String? imageUrl;

  final String fullName;
  final List<AdressBookBadge> badges;
  final List<ContactLink> contacts;

  const AdressBookCard({
    super.key,
    this.imageUrl,
    required this.fullName,
    required this.badges,
    required this.contacts,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AdressBookAvatar(fullName: fullName),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(fullName, style: AppTypography.text1Semibold),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 4, children: badges),
              const SizedBox(height: 16),
              Column(spacing: 8, children: contacts),
            ],
          ),
        ),
      ],
    );
  }
}
