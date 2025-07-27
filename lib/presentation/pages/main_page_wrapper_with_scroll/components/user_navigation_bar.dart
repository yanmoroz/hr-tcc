import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/themes/themes.dart';
import '../../../../generated/assets.gen.dart';
import '../../../blocs/blocs.dart';
import '../../../navigation/navigation.dart';
import '../../../widgets/common/common.dart';

// Навигационный бар c настраиваемыми радиусами и данными пользователя
class UserNavigationBar extends StatelessWidget implements PreferredSizeWidget {
  final bool rounded;
  final Color backgroundColor;
  final double height;
  final double cornerRadius;

  const UserNavigationBar({
    super.key,
    this.rounded = false,
    required this.backgroundColor,
    required this.cornerRadius,
    required this.height,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(rounded ? cornerRadius : 0),
        bottomRight: Radius.circular(rounded ? cornerRadius : 0),
      ),
      child: Container(
        color: backgroundColor,
        child: SafeArea(
          child: BlocProvider(
            create:
                (_) =>
                    BlocFactory.createUserNavigationBarBloc()
                      ..add(UserNavigationBarLoad()),
            child: BlocBuilder<UserNavigationBarBloc, UserNavigationBarState>(
              builder: (context, state) {
                if (state is UserNavigationBarLoaded) {
                  return GestureDetector(
                    onTap: () {
                      context.push(AppRoute.userProfile.path);
                    },
                    child: Container(
                      height: height,
                      padding: const EdgeInsets.only(
                        top: 4,
                        left: 16,
                        right: 16,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppImageWithBorder(imageUrl: state.user.avatarUrl),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                state.user.userName,
                                style: AppTypography.title4Bold,
                              ),
                              Text(
                                state.user.userRole,
                                style: AppTypography.caption2Medium.copyWith(
                                  color: AppColors.gray700,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              context.read<UserNavigationBarBloc>().add(
                                NavigationBarOnMainTapOnBell(),
                              );
                            },
                            icon: SvgPicture.asset(
                              Assets.icons.navigationBar.bellAlert.path,
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      ),
    );
  }
}
