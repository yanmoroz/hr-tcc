import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/models/models.dart';
import 'package:hr_tcc/presentation/blocs/blocs.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';

import '../../blocs/polls_list/polls_list_bloc.dart';

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
    // final bloc = context.read<PollsListBloc>();
    // final state = bloc.state;
    // if (!state.isLoadingMore &&
    //     state.hasMorePassedPolls &&
    //     _scrollController.position.pixels >=
    //         _scrollController.position.maxScrollExtent - 200) {
    //   bloc.add(LoadMoreFinishedPolls());
    // }
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   backgroundColor: widget.backgroundColor,
    //   appBar: const AppNavigationBar(title: 'Опросы'),
    //   body: Column(
    //     children: [
    //       BlocBuilder<PollsListBloc, PollsListState>(
    //         builder: (context, state) {
    //           if (state is PollsListLoading) {
    //             return const Center(child: CircularProgressIndicator());
    //           }

    //           if (state is PollsListLoaded) {
    //             return Expanded(
    //               child: ListView.builder(
    //                 itemCount: state.viewModel.polls.length,
    //                 itemBuilder: (context, index) {
    //                   final poll = state.viewModel.polls[index];
    //                   return Text(poll.title);
    //                 },
    //               ),
    //             );
    //           }

    //           return const SizedBox.shrink();
    //         },
    //       ),
    //     ],
    //   ),
    // );
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: const AppNavigationBar(title: 'Опросы'),
      body: const Placeholder(),
    );
  }

  // Widget _buildSection(
  //   String title,
  //   List<PollCardModel> polls,
  //   Color cardColor,
  // ) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
  //         child: Text(title, style: AppTypography.text1Semibold),
  //       ),
  //       ...polls.map(
  //         (poll) => Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //           child: AppInfoCard(
  //             color: cardColor,
  //             shadowColor: AppColors.cardShadowColor,
  //             children: [
  //               // TODO: fix it
  //               // PollCard(
  //               //   poll: poll,
  //               //   onTap: () {
  //               //     context.push(AppRoute.pollDetailWithId('poll_001'));
  //               //   },
  //               // ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
