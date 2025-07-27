import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/data/extensions/local_auth_extension.dart';
import 'package:hr_tcc/presentation/blocs/blocs.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';
import 'package:local_auth/local_auth.dart';

import '../../navigation/navigation.dart';

class PincodeSetupPage extends StatefulWidget {
  const PincodeSetupPage({super.key});

  @override
  State<PincodeSetupPage> createState() => _PincodeSetupPageState();
}

class _PincodeSetupPageState extends State<PincodeSetupPage>
    with SingleTickerProviderStateMixin {
  static final TextStyle _titleStyle = AppTypography.title2Bold.copyWith(
    color: AppColors.black,
  );
  static final TextStyle _subtitleStyle = AppTypography.text1Regular.copyWith(
    color: AppColors.black,
  );
  static final TextStyle _errorTextStyle = AppTypography.text1Regular.copyWith(
    color: AppColors.red500,
  );

  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  bool _isLoading = false;
  final LocalAuthentication _localAuth = GetIt.I<LocalAuthentication>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _navigateToNextPage() async {
    setState(() => _isLoading = true);
    await _animationController.forward();

    final isAvailable = await _localAuth.isBiometricAvailable();
    if (!isAvailable) {
      if (mounted) {
        context.go(AppRoute.home.path);
      }
      return;
    }

    final biometrics = await _localAuth.getAvailableBiometrics();
    if (biometrics.isEmpty) {
      if (mounted) {
        context.go(AppRoute.home.path);
      }
      return;
    }

    if (!mounted) return;

    if (biometrics.contains(BiometricType.face)) {
      context.push(AppRoute.biometricAuthWithType('face'));
    } else if (biometrics.contains(BiometricType.fingerprint) ||
        biometrics.contains(BiometricType.strong)) {
      context.push(AppRoute.biometricAuthWithType('fingerprint'));
    } else {
      context.go(AppRoute.home.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<PincodeSetupBloc, PincodeSetupState>(
        listener: (context, state) {
          if (state.isSuccess) {
            _navigateToNextPage();
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Gap(32),
                Text(
                  state.isSuccess
                      ? 'Повторите ПИН-код'
                      : (state.isConfirmation
                          ? 'Повторите ПИН-код'
                          : 'Создайте код доступа'),
                  style: _titleStyle,
                  textAlign: TextAlign.center,
                ),
                const Gap(8),
                Text(
                  state.isSuccess
                      ? 'Войдите в свою учётную запись'
                      : (state.isConfirmation
                          ? 'Войдите в свою учётную запись'
                          : 'Войдите в свою учётную запись'),
                  style: _subtitleStyle,
                  textAlign: TextAlign.center,
                ),
                const Gap(40),
                SizedBox(
                  height: 80,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            PincodeIndicator(
                              length: 4,
                              enteredLength: state.currentPincode.length,
                              hasError: state.error != null,
                            ),
                            if (state.error != null) ...[
                              const Gap(16),
                              Text(
                                'Код не совпадает',
                                style: _errorTextStyle,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (_isLoading)
                        FadeTransition(
                          opacity: ReverseAnimation(_fadeAnimation),
                          child: const CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ),
                const Spacer(),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: PincodeKeyboard(
                    type: PincodeKeyboardType.setup,
                    onKeyPressed: (String value) {
                      if (value == 'backspace') {
                        context.read<PincodeSetupBloc>().add(
                          PincodeBackspacePressedOnSetupStep(),
                        );
                      } else {
                        context.read<PincodeSetupBloc>().add(
                          PincodeNumberEntered.pincodeNumberEnteredOnSetupStep(
                            value,
                          ),
                        );
                      }
                    },
                    showBackspace: state.currentPincode.isNotEmpty,
                  ),
                ),
                const Gap(48),
              ],
            ),
          );
        },
      ),
    );
  }
}
