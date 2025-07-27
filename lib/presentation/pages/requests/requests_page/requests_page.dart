import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/models/models.dart';
import 'package:hr_tcc/presentation/navigation/navigation.dart';
import 'package:hr_tcc/presentation/pages/main_page_wrapper_with_scroll/components/user_navigation_bar.dart';
import 'package:hr_tcc/presentation/pages/requests/requests_page/components/request_type_navigation.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';
import 'package:hr_tcc/presentation/blocs/blocs.dart';
import 'package:hr_tcc/domain/entities/entities.dart';
import 'dart:async';

class RequestsPage extends StatelessWidget {
  static const List<RequestStatus> statusTabs = [
    RequestStatus.all,
    RequestStatus.active,
    RequestStatus.newRequest,
    RequestStatus.draft,
    RequestStatus.completed,
    RequestStatus.approved,
    RequestStatus.rejected,
  ];

  const RequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => BlocFactory.createRequestsBloc()..add(RequestsLoad()),
        ),
        BlocProvider(
          create:
              (context) => BlocFactory.createFilterBloc(
                _buildInitialTabs(context, statusTabs),
              ),
        ),
      ],
      child: const _RequestsView(statusTabs: statusTabs),
    );
  }
}

List<FilterTabModel<RequestStatus>> _buildInitialTabs(
  BuildContext context,
  List<RequestStatus> statusTabs,
) {
  // Пока нет данных, count = null
  return statusTabs
      .map(
        (e) =>
            FilterTabModel<RequestStatus>(label: e.name, value: e, count: null),
      )
      .toList();
}

class _RequestsView extends StatefulWidget {
  final List<RequestStatus> statusTabs;

  const _RequestsView({required this.statusTabs});

  @override
  State<_RequestsView> createState() => _RequestsViewState();
}

class _RequestsViewState extends State<_RequestsView> {
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final bloc = context.read<RequestsBloc>();
    final state = bloc.state;
    if (state is RequestsLoaded &&
        state.hasMore &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100) {
      bloc.add(RequestsLoadMore());
    }
  }

  void _onFilterChanged(RequestStatus status) {
    context.read<RequestsBloc>().add(RequestsFilterChanged(status));
  }

  void _onSearchChanged(String query, RequestStatus status) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      context.read<RequestsBloc>().add(
        RequestsSearchChanged(query, status: status),
      );
      _searchQuery = query;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const UserNavigationBar(
        backgroundColor: AppColors.white,
        cornerRadius: 24,
        height: 80,
        rounded: true,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            color: AppColors.white,
            child: BlocBuilder<RequestsBloc, RequestsState>(
              builder: (context, state) {
                final bloc = context.read<RequestsBloc>();
                final totalCount = bloc.tabCounts[RequestStatus.all] ?? 0;
                if (totalCount == 0 && _searchQuery.isEmpty) {
                  // Нет ни одной заявки вообще и поиск пустой
                  return const _EmptyRequestsPlaceholder();
                }
                // Есть заявки — показываем фильтры, поиск и список
                return Column(
                  children: [
                    BlocBuilder<RequestsBloc, RequestsState>(
                      buildWhen: (prev, curr) => true,
                      builder: (context, state) {
                        final bloc = context.read<RequestsBloc>();
                        return FilterBar(
                          filterSelectorTabBuilder: (
                            tab, {
                            required isSelected,
                          }) {
                            final count = bloc.tabCounts[tab.value];
                            final tabWithCount = FilterTabModel(
                              label: tab.label,
                              value: tab.value,
                              count: count,
                            );
                            return FilterBarTab(
                              tab: tabWithCount,
                              isSelected: isSelected,
                              borderRadius: 12,
                            );
                          },
                          onTabChanged: (index) {
                            final filterState =
                                context.read<FilterBloc>().state;
                            final status = filterState.tabs[index].value;
                            _onFilterChanged(status);
                          },
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: SizedBox(
                        height: 40,
                        child: AppSearchField(
                          hint: 'Поиск по заявкам',
                          onChanged: (query) {
                            _searchQuery = query;
                            context.read<RequestsBloc>().add(
                              UpdateRequestStatusTabCountsTrigger(query: query),
                            );
                            final filterState =
                                context.read<FilterBloc>().state;
                            final status =
                                filterState
                                    .tabs[filterState.selectedIndex]
                                    .value;
                            _onSearchChanged(query, status);
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: BlocBuilder<RequestsBloc, RequestsState>(
                        builder: (context, state) {
                          if (state is RequestsLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            switchInCurve: Curves.easeIn,
                            switchOutCurve: Curves.easeOut,
                            child:
                                state is RequestsLoaded
                                    ? _RequestsListWidget(
                                      key: const ValueKey('requests-list'),
                                      state: state,
                                      searchQuery: _searchQuery,
                                      scrollController: _scrollController,
                                    )
                                    : const SizedBox(
                                      key: ValueKey('empty-list'),
                                    ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: AppButton(
                text: 'Создать заявку',
                variant: AppButtonVariant.primary,
                onPressed: () async {
                  final type = await context.push(AppRoute.newRequest.path);
                  if (!context.mounted) return;
                  await navigateToRequestCreatePage(
                    context,
                    type as RequestType?,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestsListWidget extends StatelessWidget {
  const _RequestsListWidget({
    super.key,
    required RequestsLoaded state,
    required String searchQuery,
    required ScrollController scrollController,
  }) : _state = state,
       _searchQuery = searchQuery,
       _scrollController = scrollController;

  final RequestsLoaded _state;
  final String _searchQuery;
  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.gray100,
      child: BlocBuilder<FilterBloc, FilterState>(
        builder: (context, filterState) {
          return RefreshIndicator(
            onRefresh: () async {
              final status = filterState.tabs[filterState.selectedIndex].value;
              context.read<RequestsBloc>().add(
                RequestsReload(status: status, query: _searchQuery),
              );
              await Future.delayed(const Duration(milliseconds: 600));
            },
            child:
                _state.requests.isEmpty
                    ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(
                          height: 200,
                          child: Center(child: Text('Нет заявок')),
                        ),
                      ],
                    )
                    : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(
                        bottom: 100,
                      ).copyWith(top: 8),
                      itemCount:
                          _state.hasMore
                              ? _state.requests.length + 1
                              : _state.requests.length,
                      itemBuilder: (context, index) {
                        if (index < _state.requests.length) {
                          final request = _state.requests[index];
                          return RequestListItem(
                            request: request,
                            onTap:
                                () => navigateToRequestViewPage(
                                  context,
                                  request.type,
                                  request.id,
                                ),
                          );
                        } else {
                          return _state.hasMore
                              ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                              : const SizedBox();
                        }
                      },
                    ),
          );
        },
      ),
    );
  }
}

class _EmptyRequestsPlaceholder extends StatelessWidget {
  const _EmptyRequestsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Здесь появится список всех\nсозданных заявок',
        textAlign: TextAlign.center,
        style: AppTypography.text1Regular.copyWith(color: AppColors.black),
      ),
    );
  }
}
