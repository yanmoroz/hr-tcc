import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/domain/models/models.dart';
import 'package:hr_tcc/generated/assets.gen.dart';
import 'package:hr_tcc/presentation/blocs/blocs.dart';
import 'package:local_auth/local_auth.dart';

import '../../../domain/repositories/auth_repository.dart';
import '../../navigation/navigation.dart';
import '../../widgets/common/common.dart';

class BiometricSetupPage extends StatelessWidget {
  final BiometricType type;
  final _authRepository = GetIt.I<AuthRepository>();

  BiometricSetupPage({super.key, required this.type});

  String get _title {
    switch (type) {
      case BiometricType.face:
        return 'Хотите использовать Face ID\nдля входа в приложение?';
      case BiometricType.fingerprint:
        return 'Использовать биометрию\nдля входа в приложение?';
      default:
        return 'Использовать биометрию\nдля входа в приложение?';
    }
  }

  String get _buttonText {
    switch (type) {
      case BiometricType.face:
        return 'Использовать Face ID';
      case BiometricType.fingerprint:
        return 'Использовать биометрию';
      default:
        return 'Использовать биометрию';
    }
  }

  SvgPicture get _icon {
    switch (type) {
      case BiometricType.face:
        return Assets.icons.auth.faceIdBig.svg(width: 120, height: 120);
      case BiometricType.fingerprint:
        return Assets.icons.auth.touchIdBig.svg(width: 120, height: 120);
      default:
        return Assets.icons.auth.touchIdBig.svg(width: 120, height: 120);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _BiometricSetupPageContent(
      type: type,
      title: _title,
      buttonText: _buttonText,
      icon: _icon,
      onAuthenticationSuccess: (context) => _onAuthenticationSuccess(context),
      onSkip: (context) => _onSkip(context),
    );
  }

  Future<void> _onAuthenticationSuccess(BuildContext context) async {
    final authType =
        type == BiometricType.face
            ? AuthType.pincodeWithFaceID
            : AuthType.pincodeWithTouchID;
    await _authRepository.updateAuthType(authType);
    if (context.mounted) {
      context.go(AppRoute.home.path);
    }
  }

  Future<void> _onSkip(BuildContext context) async {
    await _authRepository.updateAuthType(AuthType.pincodeOnly);
    if (context.mounted) {
      context.go(AppRoute.home.path);
    }
  }
}

class _BiometricSetupPageContent extends StatefulWidget {
  final BiometricType type;
  final String title;
  final String buttonText;
  final SvgPicture icon;
  final Function(BuildContext) onAuthenticationSuccess;
  final Function(BuildContext) onSkip;

  const _BiometricSetupPageContent({
    required this.type,
    required this.title,
    required this.buttonText,
    required this.icon,
    required this.onAuthenticationSuccess,
    required this.onSkip,
  });

  @override
  State<_BiometricSetupPageContent> createState() =>
      _BiometricSetupPageContentState();
}

class _BiometricSetupPageContentState
    extends State<_BiometricSetupPageContent> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: BlocConsumer<BiometricSetupBloc, BiometricSetupState>(
          listener: (context, state) {
            if (state.status == BiometricSetupStatus.success) {
              widget.onAuthenticationSuccess(context);
            } else if (state.status == BiometricSetupStatus.skipped) {
              widget.onSkip(context);
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.icon,
                    const Gap(32),
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: AppTypography.title2Bold.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    const Gap(48),
                    AppButton(
                      text: widget.buttonText,
                      isFullWidth: true,
                      isLoading:
                          state.loadingAction == BiometricSetupAction.biometric,
                      onPressed:
                          state.status == BiometricSetupStatus.inProgress
                              ? null
                              : () {
                                context.read<BiometricSetupBloc>()
                                  ..add(CheckBiometricAvailability(widget.type))
                                  ..add(TurnOnBiometric());
                              },
                    ),
                    const Gap(16),
                    AppButton(
                      text: 'Входить только с кодом',
                      variant: AppButtonVariant.secondary,
                      isFullWidth: true,
                      isLoading:
                          state.loadingAction == BiometricSetupAction.skip,
                      onPressed:
                          state.status == BiometricSetupStatus.inProgress
                              ? null
                              : () => context.read<BiometricSetupBloc>().add(
                                SkipBiometricSetup(),
                              ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
