import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/models/models.dart';
import 'package:hr_tcc/presentation/blocs/blocs.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';

import '../../widgets/polls_section/subwidgets/poll_card.dart';
import '../../../../../presentation/navigation/navigation.dart';

class PollsListPage extends StatefulWidget {
  final Color backgroundColor;
  final Color cardColor;

  const PollsListPage({
    super.key,
    this.backgroundColor = AppColors.gray200,
    this.cardColor = AppColors.white,
  });

  @override
  State<PollsListPage> createState() => _PollsListPageState();
}

class _PollsListPageState extends State<PollsListPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    final bloc = context.read<PollsListBloc>();
    final state = bloc.state;
    if (!state.isLoadingMore &&
        state.hasMorePassedPolls &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
      bloc.add(LoadMoreFinishedPollsList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PollsListBloc, PollsListState>(
      builder: (context, state) {
        final filtered = state.selectedFilter;
        final grouped = state.groupedPolls;

        final notPassed =
            (filtered == PollStatus.all || filtered == PollStatus.notPassed)
                ? grouped[PollStatus.notPassed] ?? []
                : <PollCardModel>[];

        final passed =
            (filtered == PollStatus.all || filtered == PollStatus.passed)
                ? grouped[PollStatus.passed] ?? []
                : <PollCardModel>[];

        return Scaffold(
          backgroundColor: widget.backgroundColor,
          appBar: const AppNavigationBar(title: 'Опросы'),
          body: Column(
            children: [
              BlocListener<PollsListBloc, PollsListState>(
                listenWhen: (prev, curr) => prev.filterTabs != curr.filterTabs,
                listener: (context, state) {
                  if (state.filterTabs != null) {
                    context.read<FilterBloc>().add(
                      SetFilterTabs<PollStatus>(state.filterTabs!),
                    );
                  }
                },
                child: BlocListener<FilterBloc, FilterState>(
                  listenWhen:
                      (prev, curr) => prev.selectedIndex != curr.selectedIndex,
                  listener: (context, state) {
                    context.read<PollsListBloc>().add(
                      FilterPollsListByStatus(state.selectedTab.value),
                    );
                  },
                  child: FilterBar(
                    filterSelectorTabBuilder: (
                      tab, {
                      required bool isSelected,
                    }) {
                      return FilterBarTab(isSelected: isSelected, tab: tab);
                    },
                    onTabChanged: (index) => {},
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  key: PageStorageKey<String>('polls_list_${filtered?.name}'),
                  controller: _scrollController,
                  children: [
                    if (notPassed.isNotEmpty)
                      _buildSection(
                        state.sectionTitles[PollStatus.notPassed] ??
                            'Непройденные',
                        notPassed,
                        widget.cardColor,
                      ),
                    if (passed.isNotEmpty)
                      _buildSection(
                        state.sectionTitles[PollStatus.passed] ?? 'Пройденные',
                        passed,
                        widget.cardColor,
                      ),
                    if ((filtered == PollStatus.all ||
                            filtered == PollStatus.passed) &&
                        state.hasMorePassedPolls)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection(
    String title,
    List<PollCardModel> polls,
    Color cardColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(title, style: AppTypography.text1Semibold),
        ),
        ...polls.map(
          (poll) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: AppInfoCard(
              color: cardColor,
              shadowColor: AppColors.cardShadowColor,
              children: [
                PollCard(
                  poll: poll,
                  onTap: () {
                    context.push(AppRoute.pollDetailWithId('poll_001'));
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
