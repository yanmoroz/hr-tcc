import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/config/localise/localise.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/presentation/blocs/blocs.dart';
import 'package:hr_tcc/presentation/pages/address_book_page.dart/components/components.dart';
import 'package:hr_tcc/presentation/pages/helpers/helpers.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';

import '../../cubits/snackbar/snackbar_cubit.dart';

class AddressBookPage extends StatefulWidget {
  const AddressBookPage({super.key});
  @override
  State<AddressBookPage> createState() => AddressBookViewState();
}

class AddressBookViewState extends State<AddressBookPage> {
  final _controller = ScrollController();
  late AddressBookBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<AddressBookBloc>();
    _controller.addListener(_maybeLoadMore);
  }

  void _maybeLoadMore() {
    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent - 180) {
      _bloc.add(LoadNextPage());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SnackBarWidget(
      child: Scaffold(
        backgroundColor: AppColors.gray200,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(38),
          child: BlocSelector<AddressBookBloc, AddressBookState, int>(
            selector: (state) => state.totalCount,
            builder:
                (context, total) => AppNavigationBar(
                  title: 'Адресная книга',
                  subTitle: getEmployeesText(total),
                ),
          ),
        ),
        body: Column(
          children: [
            // Поиск
            Container(
              color: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                height: 40,
                child: AppSearchField(
                  hint: 'Поиск',
                  onChanged:
                      (q) => context.read<AddressBookBloc>().add(
                        SearchQueryChanged(q),
                      ),
                ),
              ),
            ),
            // Список с пагинацией
            Expanded(
              child: BlocBuilder<AddressBookBloc, AddressBookState>(
                builder: (context, state) {
                  if (state.employees.isEmpty) {
                    if (state.isLoading) {
                      // Идет загрузка
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.query.isNotEmpty) {
                      // Пусто и есть поисковый запрос — показываем сообщение
                      return Center(
                        child: Text(
                          'Таких сотрудников нет',
                          style: AppTypography.text1Regular,
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }

                  return ListView(
                    controller: _controller,
                    padding: const EdgeInsets.only(top: 8, bottom: 32),
                    children: [
                      ...state.employees.map(
                        (e) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: AppInfoCard(
                            color: AppColors.white,
                            shadowColor: AppColors.cardShadowColor,
                            children: [
                              AdressBookCard(
                                fullName: e.fullName,
                                badges:
                                    e.badges
                                        .map(
                                          (b) =>
                                              AdressBookBadge(label: b.label),
                                        )
                                        .toList(),
                                contacts:
                                    e.contacts
                                        .map(
                                          (c) => ContactLink(
                                            mainText: c.mainText,
                                            subText: c.subText,
                                            onTap: () async {
                                              final result =
                                                  await ExternalActionHelper.open(
                                                    c.mainText,
                                                  );
                                              if (!result.success &&
                                                  context.mounted) {
                                                context
                                                    .read<SnackBarCubit>()
                                                    .showSnackBar(
                                                      result.errorMessage,
                                                    );
                                              }
                                            },
                                          ),
                                        )
                                        .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (state.isLoading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
