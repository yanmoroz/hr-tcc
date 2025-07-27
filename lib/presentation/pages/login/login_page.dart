import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/presentation/blocs/blocs.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => context.read<LoginBloc>(),
      child: const _LoginPageContent(),
    );
  }
}

class _LoginPageContent extends StatefulWidget {
  const _LoginPageContent();

  @override
  State<_LoginPageContent> createState() => _LoginPageContentState();
}

class _LoginPageContentState extends State<_LoginPageContent>
    with SingleTickerProviderStateMixin {
  static final TextStyle _titleStyle = AppTypography.title3Bold.copyWith(
    color: AppColors.black,
  );

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _isFormValid = false;
  String? _usernameError;
  String? _passwordError;
  // bool _wasUsernameTouched = false;
  // bool _wasPasswordTouched = false;

  late final AnimationController _errorAnimationController;
  // late final Animation<double> _errorAnimation;

  @override
  void initState() {
    super.initState();
    _errorAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // _errorAnimation = CurvedAnimation(
    //   parent: _errorAnimationController,
    //   curve: Curves.easeInOut,
    // );

    _usernameFocusNode.addListener(_handleUsernameFocusChange);
    _passwordFocusNode.addListener(_handlePasswordFocusChange);
    _setupFormValidation();
  }

  @override
  void dispose() {
    _usernameFocusNode.removeListener(_handleUsernameFocusChange);
    _passwordFocusNode.removeListener(_handlePasswordFocusChange);
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _errorAnimationController.dispose();
    super.dispose();
  }

  void _setupFormValidation() {
    void validateForm() {
      if (!mounted) return;

      final hasUsername = _usernameController.text.isNotEmpty;
      final hasPassword = _passwordController.text.isNotEmpty;
      final isAgreedToTerms = context.read<LoginBloc>().state.isAgreedToTerms;

      final newIsFormValid = hasUsername && hasPassword && isAgreedToTerms;

      if (_isFormValid != newIsFormValid) {
        setState(() {
          _isFormValid = newIsFormValid;
        });
      }
    }

    _usernameController.addListener(validateForm);
    _passwordController.addListener(validateForm);
  }

  void _handleUsernameFocusChange() {
    if (!_usernameFocusNode.hasFocus) {
      setState(() {
        // _wasUsernameTouched = true;
      });
      if (_usernameController.text.isEmpty) {
        if (mounted && !_usernameFocusNode.hasFocus) {
          setState(() {
            _usernameError = 'Введите логин';
          });
        }
      }
    } else {
      setState(() {
        _usernameError = null;
      });
    }
  }

  void _handlePasswordFocusChange() {
    if (!_passwordFocusNode.hasFocus) {
      setState(() {
        // _wasPasswordTouched = true;
      });
      if (_passwordController.text.isEmpty) {
        if (mounted && !_passwordFocusNode.hasFocus) {
          setState(() {
            _passwordError = 'Введите пароль';
          });
        }
      }
    } else {
      setState(() {
        _passwordError = null;
      });
    }
  }

  void _onLoginPressed() {
    _unfocus();
    setState(() {
      // _wasUsernameTouched = true;
      // _wasPasswordTouched = true;
    });

    final hasUsername = _usernameController.text.isNotEmpty;
    final hasPassword = _passwordController.text.isNotEmpty;

    if (!hasUsername || !hasPassword) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            if (!hasUsername) _usernameError = 'Введите логин';
            if (!hasPassword) _passwordError = 'Введите пароль';
          });
        }
      });
      return;
    }

    context.read<LoginBloc>().add(
      LoginWithCredentials(
        username: _usernameController.text,
        password: _passwordController.text,
      ),
    );
  }

  void _unfocus() {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          FocusScope.of(context).unfocus();
          context.push(
            '/pincode-setup',
            extra: {
              'accessToken': state.accessToken,
              'currentUser': state.currentUser,
            },
          );
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: _unfocus,
          behavior: HitTestBehavior.opaque,
          child: Scaffold(
            appBar: AppBar(),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 40),
                              Text(
                                'Войдите в учётную запись',
                                style: _titleStyle,
                                textAlign: TextAlign.center,
                              ),
                              const Gap(40),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppTextField(
                                    controller: _usernameController,
                                    focusNode: _usernameFocusNode,
                                    hint: 'Логин',
                                    textInputAction: TextInputAction.next,
                                    fillColor: AppColors.gray100,
                                    errorText: _usernameError,
                                  ),
                                  const Gap(16),
                                  BlocBuilder<LoginBloc, LoginState>(
                                    builder: (context, state) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppTextField(
                                            controller: _passwordController,
                                            focusNode: _passwordFocusNode,
                                            hint: 'Пароль',
                                            obscureText:
                                                !state.isPasswordVisible,
                                            textInputAction:
                                                TextInputAction.done,
                                            fillColor: AppColors.gray100,
                                            errorText: _passwordError,
                                            onSubmitted: (_) {
                                              if (_isFormValid) {
                                                _onLoginPressed();
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const Gap(24),
                              BlocConsumer<LoginBloc, LoginState>(
                                listener: (context, state) {
                                  final hasUsername =
                                      _usernameController.text.isNotEmpty;
                                  final hasPassword =
                                      _passwordController.text.isNotEmpty;
                                  final newIsFormValid =
                                      hasUsername &&
                                      hasPassword &&
                                      state.isAgreedToTerms;

                                  if (_isFormValid != newIsFormValid) {
                                    setState(() {
                                      _isFormValid = newIsFormValid;
                                    });
                                  }
                                },
                                builder: (context, state) {
                                  return Row(
                                    children: [
                                      AppCheckBox(
                                        value: state.isAgreedToTerms,
                                        onChanged: (value) {
                                          context.read<LoginBloc>().add(
                                            UpdateAgreement(isAgreed: value),
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: RichText(
                                          text: TextSpan(
                                            style: AppTypography.caption2Medium
                                                .copyWith(
                                                  color: AppColors.gray700,
                                                ),
                                            children: [
                                              const TextSpan(
                                                text: 'Я согласен(на) на ',
                                              ),
                                              TextSpan(
                                                text:
                                                    'обработку персональных данных',
                                                style: AppTypography
                                                    .caption2Medium
                                                    .copyWith(
                                                      color: AppColors.blue700,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              if (state.errorMessage != null) ...[
                                const Gap(16),
                                AnimatedOpacity(
                                  duration: const Duration(milliseconds: 200),
                                  opacity:
                                      state.errorMessage != null ? 1.0 : 0.0,
                                  child: Text(
                                    state.errorMessage!,
                                    style: AppTypography.text1Regular.copyWith(
                                      color: AppColors.red500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                              const Gap(40),
                              AppButton(
                                text: 'Продолжить',
                                onPressed:
                                    _isFormValid && state is! LoginLoading
                                        ? _onLoginPressed
                                        : null,
                                isLoading: state is LoginLoading,
                                isFullWidth: true,
                                isDisabled: !_isFormValid,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Builder(
                      builder: (context) {
                        final isKeyboardVisible =
                            _usernameFocusNode.hasFocus ||
                            _passwordFocusNode.hasFocus;
                        return isKeyboardVisible
                            ? const SizedBox.shrink()
                            : AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: 1.0,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                child: Column(
                                  children: [
                                    Text(
                                      'Если у вас нет учётной записи,\nобратитесь в компанию',
                                      style: AppTypography.text1Regular
                                          .copyWith(color: AppColors.gray700),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 12),
                                  ],
                                ),
                              ),
                            );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
