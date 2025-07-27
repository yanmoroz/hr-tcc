import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/themes/themes.dart';
import '../../../../domain/entities/entities.dart';
import '../../../../models/models.dart';
import '../../../blocs/blocs.dart';
import '../../../widgets/common/common.dart';
import '../components/components.dart';

final groupTabs = [
  RequestGroup.all,
  RequestGroup.education,
  RequestGroup.office,
  RequestGroup.corporate,
  RequestGroup.hr,
  RequestGroup.regime,
];

class NewRequestPage extends StatelessWidget {
  const NewRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) =>
                  BlocFactory.createRequestTypesBloc()..add(RequestTypesLoad()),
        ),
        BlocProvider(
          create:
              (context) =>
                  BlocFactory.createFilterBloc(_buildInitialTabs(context)),
        ),
      ],
      child: const _NewRequestView(),
    );
  }
}

List<FilterTabModel<RequestGroup>> _buildInitialTabs(BuildContext context) {
  // Пока нет данных, count = null
  return groupTabs
      .map(
        (e) =>
            FilterTabModel<RequestGroup>(label: e.name, value: e, count: null),
      )
      .toList();
}

class _NewRequestView extends StatefulWidget {
  const _NewRequestView();
  @override
  State<_NewRequestView> createState() => _NewRequestViewState();
}

class _NewRequestViewState extends State<_NewRequestView> {
  String _searchQuery = '';
  // int _page = 1;
  bool _hasMore = true;
  // List<RequestTypeInfo> _types = [];
  bool _initialized = false;
  // Map<RequestGroup, int> _tabCounts = {};
  bool _isLoadingTabCounts = false;
  Timer? _debounce;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _loadTabCounts();
      _loadTypes(context, reset: true);
    }
  }

  Future<void> _loadTabCounts() async {
    setState(() => _isLoadingTabCounts = true);
    final useCase =
        context.read<RequestTypesBloc>().fetchRequestTypesCountUseCase;
    final counts = await useCase(query: _searchQuery);
    setState(() {
      // _tabCounts = counts;
      _isLoadingTabCounts = false;
    });
    _updateTabsCount(counts);
  }

  void _updateTabsCount(Map<RequestGroup, int> counts) {
    final tabCounts = groupTabs.map((e) => counts[e] ?? 0).toList();
    context.read<FilterBloc>().add(UpdateTabCounts<RequestGroup>(tabCounts));
  }

  Future<void> _loadTypes(BuildContext context, {bool reset = false}) async {
    // final bloc = context.read<RequestTypesBloc>();
    // final filterState = context.read<FilterBloc>().state;
    // final selectedGroup = filterState.tabs[filterState.selectedIndex].value;
    // final types = await bloc.fetchRequestTypesUseCase(
    //   group: selectedGroup == RequestGroup.all ? null : selectedGroup,
    //   query: _searchQuery.isEmpty ? null : _searchQuery,
    // );
    // _types = types;
    _hasMore = false;
    setState(() {});
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const RequestCreationAppBar(title: 'Создание заявки'),
      body: PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          // Если возврат с вложенного экрана с результатом true, пробрасываем наверх
          if (didPop && result == true) {
            context.pop(true);
          }
        },
        child: Container(
          color: AppColors.white,
          child: Column(
            children: [
              BlocListener<FilterBloc, FilterState>(
                listenWhen:
                    (prev, curr) => prev.selectedIndex != curr.selectedIndex,
                listener: (context, state) {
                  _loadTypes(context, reset: true);
                  _loadTabCounts();
                },
                child: FilterBar(
                  filterSelectorTabBuilder:
                      (tab, {required isSelected}) => FilterBarTab(
                        tab: tab,
                        isSelected: isSelected,
                        borderRadius: 12,
                      ),
                  onTabChanged: (index) {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: SizedBox(
                  height: 40,
                  child: AppSearchField(
                    hint: 'Наименование заявки',
                    onChanged: (query) {
                      _searchQuery = query;
                      // Сразу обновляем counts
                      context.read<RequestTypesBloc>().add(
                        UpdateRequestTypeTabCountsTrigger(query: query),
                      );
                      _debounce?.cancel();
                      _debounce = Timer(const Duration(milliseconds: 400), () {
                        context.read<RequestTypesBloc>().add(
                          RequestTypesSearchChanged(query),
                        );
                      });
                    },
                  ),
                ),
              ),
              if (_isLoadingTabCounts)
                const LinearProgressIndicator(minHeight: 2),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    if (_hasMore &&
                        scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent - 100) {
                      // _page++;
                      _loadTypes(context);
                    }
                    return false;
                  },
                  child: BlocBuilder<RequestTypesBloc, RequestTypesState>(
                    builder: (context, state) {
                      final filterState = context.watch<FilterBloc>().state;
                      final selectedGroup =
                          filterState.tabs[filterState.selectedIndex].value;
                      if (state is RequestTypesLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is RequestTypesLoaded) {
                        final types = state.types;
                        final filtered =
                            selectedGroup == RequestGroup.all
                                ? types
                                : types
                                    .where((t) => t.group == selectedGroup)
                                    .toList();
                        if (filtered.isEmpty) {
                          return const Center(child: Text('Нет типов заявок'));
                        }
                        return ListView.builder(
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final typeInfo = filtered[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x0A38990D),
                                    offset: Offset(0, 4),
                                    blurRadius: 30,
                                  ),
                                ],
                              ),
                              child: Card(
                                color: Colors.transparent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                    ),
                                    title: Text(typeInfo.type.name),
                                    leading: SvgPicture.asset(
                                      typeInfo.type.icon,
                                      width: 28,
                                      height: 28,
                                      colorFilter: const ColorFilter.mode(
                                        AppColors.blue300,
                                        BlendMode.srcIn,
                                      ),
                                      placeholderBuilder:
                                          (ctx) =>
                                              const Icon(Icons.description),
                                    ),
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: AppColors.gray500,
                                    ),
                                    onTap: () {
                                      _handleRequestTypeTap(
                                        context,
                                        typeInfo.type,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleRequestTypeTap(BuildContext context, RequestType type) {
    switch (type) {
      case RequestType.courierDelivery:
        context.pop(RequestType.courierDelivery);
      case RequestType.alpinaAccess:
        context.pop(RequestType.alpinaAccess);
      case RequestType.workCertificate:
        context.pop(RequestType.workCertificate);
      case RequestType.violation:
        context.pop(RequestType.violation);
      case RequestType.absence:
        context.pop(RequestType.absence);
      case RequestType.referralProgram:
        context.pop(RequestType.referralProgram);
      case RequestType.pass:
        context.pop(RequestType.pass);
      case RequestType.parking:
        context.pop(RequestType.parking);
      case RequestType.businessTrip:
        context.pop(RequestType.businessTrip);
      case RequestType.unplannedTraining:
        context.pop(RequestType.unplannedTraining);
      case RequestType.workBookCopy:
        context.pop(RequestType.workBookCopy);
      case RequestType.taxCertificate:
        context.pop(RequestType.taxCertificate);
      case RequestType.internalTraining:
        context.pop(RequestType.internalTraining);
      case RequestType.dpo:
        context.pop(RequestType.dpo);
    }
  }
}
