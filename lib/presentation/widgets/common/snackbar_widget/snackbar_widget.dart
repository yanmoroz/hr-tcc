import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/presentation/cubits/snackbar/snackbar_cubit.dart';

class SnackBarWidget extends StatelessWidget {
  final Widget child;

  const SnackBarWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SnackBarCubit, SnackBarState>(
      listener: (context, state) {
        if (state.isVisible && state.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(
                child: Text(
                  state.message!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              backgroundColor: AppColors.blue700,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              duration: const Duration(seconds: 3),
            ),
          );
          // Автоматически скрываем после показа
          context.read<SnackBarCubit>().hideSnackBar();
        }
      },
      child: child,
    );
  }
}
