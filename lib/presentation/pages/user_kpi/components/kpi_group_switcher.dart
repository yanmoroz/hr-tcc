import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../generated/assets.gen.dart';
import '../../../blocs/blocs.dart';
import '../../../widgets/common/common.dart';

class KpiGroupSwitcher extends StatelessWidget {
  final KpiLoaded state;

  const KpiGroupSwitcher({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final canGoLeft = state.currentIndex > 0;
    final canGoRight = state.currentIndex < state.groups.length - 1;

    Widget arrowButton({
      required bool visible,
      required VoidCallback onTap,
      required String asset,
    }) {
      return Visibility(
        visible: visible,
        replacement: const SizedBox(
          width: kMinInteractiveDimension,
          height: kMinInteractiveDimension,
        ),
        child: IconButton(
          icon: SvgPicture.asset(asset, width: 20, height: 20),
          onPressed: onTap,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        arrowButton(
          visible: canGoLeft,
          onTap:
              () => context.read<UserKpiBloc>().add(
                ChangeKpiGroup(state.currentIndex - 1),
              ),
          asset: Assets.icons.userKpi.chevronLeft.path,
        ),
        AppCircularProgressIndicator(
          progress: state.groups[state.currentIndex].progress,
          size: 120,
        ),
        arrowButton(
          visible: canGoRight,
          onTap:
              () => context.read<UserKpiBloc>().add(
                ChangeKpiGroup(state.currentIndex + 1),
              ),
          asset: Assets.icons.userKpi.chevronRight.path,
        ),
      ],
    );
  }
}
