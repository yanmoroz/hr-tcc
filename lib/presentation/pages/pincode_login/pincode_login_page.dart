import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../config/themes/themes.dart';
import '../../blocs/blocs.dart';
import '../../navigation/navigation.dart';
import '../../widgets/common/common.dart';

class PincodeLoginPage extends StatelessWidget {
  const PincodeLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PincodeLoginPageContent();
  }
}

class _PincodeLoginPageContent extends StatefulWidget {
  const _PincodeLoginPageContent();

  @override
  State<_PincodeLoginPageContent> createState() =>
      _PincodeLoginPageContentState();
}

class _PincodeLoginPageContentState extends State<_PincodeLoginPageContent>
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

  String _enteredPin = '';
  bool _showBackspace = false;
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

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

  void _onKeyPressed(String value) {
    final state = context.read<PincodeLoginBloc>().state;
    if (state.isLoading) return;

    if (value == 'backspace') {
      if (_enteredPin.isNotEmpty) {
        setState(() {
          _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
          _showBackspace = _enteredPin.isNotEmpty;
        });
        context.read<PincodeLoginBloc>().add(
          PincodeBackspacePressedOnLoginStep(),
        );
      }
    } else if (_enteredPin.length < 4) {
      setState(() {
        _enteredPin += value;
        _showBackspace = true;
      });
      context.read<PincodeLoginBloc>().add(
        PincodeNumberEnteredOnLoginStep(value),
      );

      if (_enteredPin.length == 4) {
        _animationController.forward();
      }
    }
  }

  void _onBiometricPressed() {
    context.read<PincodeLoginBloc>().add(
      const AuthenticateWithBiometricsOnPinStep(),
    );
  }

  Future<void> _onPasswordLoginPressed() async {
    if (!mounted) return;

    context.read<PincodeLoginBloc>().add(const ResetPincode());
  }

  PincodeKeyboardType _getKeyboardType(PincodeLoginState state) {
    if (state.isFaceIdAvailable) {
      return PincodeKeyboardType.pinWithFaceID;
    } else if (state.isTouchIdAvailable) {
      return PincodeKeyboardType.pinWithTouchID;
    }
    return PincodeKeyboardType.pinOnly;
  }

  Future<void> _showResetPinAlert(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AppAlertDialog(
          actionsOrientation: DialogActionsOrientation.horizontal,
          title: 'Сбросить код?',
          content:
              'Вы уверены, что хотите сбросить ПИН-код и войти по обычному паролю?',

          actions: [
            DialogAction(
              label: 'Отмена',
              type: DialogActionType.cancel,
              onPressed: () => context.pop(),
            ),
            DialogAction(
              label: 'Сбросить',
              type: DialogActionType.confirm,
              onPressed: () {
                context.pop();
                _onPasswordLoginPressed();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PincodeLoginBloc, PincodeLoginState>(
      listener: (context, state) {
        if (state.isAuthenticated) {
          context.go(AppRoute.home.path);
        } else if (state.error != null) {
          setState(() {
            _enteredPin = state.currentPincode;
          });
          _animationController.reverse();
        } else if (state.currentPincode.isEmpty && state.error == null) {
          setState(() {
            _enteredPin = '';
            _showBackspace = false;
          });
          _animationController.reverse();
        } else {
          setState(() {
            _enteredPin = state.currentPincode;
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Gap(32),
                  Text(
                    'Введите код доступа',
                    style: _titleStyle,
                    textAlign: TextAlign.center,
                  ),
                  const Gap(8),
                  Text(
                    'Войдите в свою учётную запись',
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
                                enteredLength: _enteredPin.length,
                                hasError: state.error != null,
                              ),
                              if (state.error != null) ...[
                                const Gap(16),
                                Text(
                                  'Код не подходит, попробуйте снова',
                                  style: _errorTextStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (state.isLoading)
                          FadeTransition(
                            opacity: ReverseAnimation(_fadeAnimation),
                            child: const CircularProgressIndicator(
                              color: AppColors.blue700,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  PincodeKeyboard(
                    type:
                        _showBackspace
                            ? PincodeKeyboardType.pinOnly
                            : _getKeyboardType(state),
                    onKeyPressed: _onKeyPressed,
                    onBiometricPressed: _onBiometricPressed,
                    onPasswordLoginPressed: () => _showResetPinAlert(context),
                    showBackspace: _showBackspace,
                  ),
                  const Gap(48),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
