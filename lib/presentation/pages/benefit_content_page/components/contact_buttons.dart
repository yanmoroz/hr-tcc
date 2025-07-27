import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/presentation/pages/helpers/helpers.dart';

import '../../../cubits/snackbar/snackbar_cubit.dart';

class ContactButtons extends StatelessWidget {
  final String? phone;
  final String? email;

  const ContactButtons({super.key, this.phone, this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        if (phone != null && phone!.isNotEmpty) ...[
          SizedBox(
            height: 52,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                final result = await ExternalActionHelper.open(phone ?? '');
                if (!result.success && context.mounted) {
                  context.read<SnackBarCubit>().showSnackBar(
                    result.errorMessage!,
                  );
                }
              },
              child: const Text('Позвонить'),
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (email != null && email!.isNotEmpty) ...[
          SizedBox(
            height: 52,
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.white),
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                final result = await ExternalActionHelper.open(email ?? '');
                if (!result.success && context.mounted) {
                  context.read<SnackBarCubit>().showSnackBar(
                    result.errorMessage!,
                  );
                }
              },
              child: const Text('Написать на почту'),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}
