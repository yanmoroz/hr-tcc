import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/generated/assets.gen.dart';
import 'package:hr_tcc/presentation/blocs/blocs.dart';
import 'package:hr_tcc/presentation/navigation/app_route.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';

import 'components/logout_dialog.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  final backgroundColor = AppColors.gray100;
  final cardColor = AppColors.white;
  final cardShadowColor = AppColors.cardShadowColor;
  final subTitleTextColor = AppColors.gray700;

  final _sectionSpacing = const SizedBox(height: 24);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => BlocFactory.createUserProfileBloc()..add(LoadUserProfile()),
      child: Builder(
        builder: (context) {
          return BlocConsumer<UserProfileBloc, UserProfileState>(
            listener: (context, state) {
              if (state is UserProfileLoggedOut) {
                context.go(AppRoute.login.path);
              }
            },
            builder: (context, state) {
              return Scaffold(
                backgroundColor: backgroundColor,
                appBar: AppNavigationBar(
                  title: 'Профиль',
                  leftIconAsset: Assets.icons.navigationBar.back.path,
                  rightIconAsset: Assets.icons.navigationBar.exit.path,
                  onRight: () {
                    showLogoutDialog(
                      context,
                      onConfirm: () {
                        context.read<UserProfileBloc>().add(
                          UserProfileLogout(),
                        );
                      },
                    );
                  },
                ),
                body: BlocBuilder<UserProfileBloc, UserProfileState>(
                  builder: (context, state) {
                    if (state is UserProfileLoading ||
                        state is UserProfileInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is UserProfileError) {
                      return Center(child: Text(state.message));
                    }

                    if (state is UserProfileLoaded) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.only(
                          top: 16,
                          left: 16,
                          right: 16,
                          bottom: 64,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            _buildAvatar(state.photoUrl),
                            const SizedBox(height: 12),
                            Text(
                              state.name,
                              style: AppTypography.title2Bold,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${state.phoneMobile}\n${state.phoneWork}\n${state.email}',
                              textAlign: TextAlign.center,
                              style: AppTypography.text2Regular,
                            ),
                            const SizedBox(height: 36),
                            AppSectionWithCard(
                              title: 'Подразделение и должность',
                              cards: [
                                AppInfoCard(
                                  color: cardColor,
                                  shadowColor: cardShadowColor,
                                  children: [
                                    AppInfoRow(
                                      label: 'Подразделение',
                                      value: state.department,
                                      labelColor: subTitleTextColor,
                                    ),
                                    const SizedBox(height: 24),
                                    AppInfoRow(
                                      label: 'Должность',
                                      value: state.position,
                                      labelColor: subTitleTextColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            _sectionSpacing,
                            GestureDetector(
                              onTap: () {
                                context.push(AppRoute.userKpi.path);
                              },
                              child: AppSectionWithCard(
                                title: 'КПЭ',
                                cards: [
                                  AppInfoCard(
                                    color: cardColor,
                                    shadowColor: cardShadowColor,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            state.quarterLabel,
                                            style: AppTypography.text2Regular
                                                .copyWith(
                                                  color: subTitleTextColor,
                                                ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                '${(state.kpiProgress * 100).toInt()} %',
                                                style:
                                                    AppTypography.text1Semibold,
                                              ),
                                              const SizedBox(width: 8),
                                              AppCircularProgressIndicator(
                                                size: 20,
                                                progressStroke: 5,
                                                backgroundStroke: 2,
                                                backgroundPaintColor:
                                                    AppColors
                                                        .progressIndicatorBackgroundProfile,
                                                showPercentage: false,
                                                progress: state.kpiProgress,
                                              ),
                                              const SizedBox(width: 4),
                                              SvgPicture.asset(
                                                Assets
                                                    .icons
                                                    .userProfile
                                                    .openKpi
                                                    .path,
                                                width: 20,
                                                height: 20,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            _sectionSpacing,
                            AppSectionWithCard(
                              title: 'Доход',
                              cards: [
                                AppInfoCard(
                                  color: cardColor,
                                  shadowColor: cardShadowColor,
                                  children: [
                                    _buildIncomeRow(
                                      'Общий доход',
                                      state.incomeTotal,
                                    ),
                                    const SizedBox(height: 24),
                                    _buildIncomeRow(
                                      'Заработная плата',
                                      state.incomeSalary,
                                    ),
                                    const SizedBox(height: 24),
                                    _buildIncomeRow(
                                      'Премия',
                                      state.incomeBonus,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            _sectionSpacing,
                            AppSectionWithCard(
                              title: 'Отпуск',
                              cards: [
                                AppInfoCard(
                                  color: cardColor,
                                  shadowColor: cardShadowColor,
                                  children: [
                                    _buildIncomeRow(
                                      'Остаток дней',
                                      state.vacationDays,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildAvatar(String photoUrl) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(photoUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildIncomeRow(String label, String value) {
    return AppInfoRow(
      label: label,
      value: value,
      labelColor: subTitleTextColor,
      valueFontWeight: FontWeight.w600,
    );
  }

  void showLogoutDialog(
    BuildContext context, {
    required VoidCallback onConfirm,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: const Color.fromRGBO(60, 60, 63, 0.15),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return LogoutDialog(
          onCancel: () => context.pop(),
          onConfirm: () {
            onConfirm();
            context.pop();
          },
        );
      },
    );
  }
}
