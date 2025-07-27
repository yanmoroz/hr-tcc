import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/generated/assets.gen.dart';
import 'package:hr_tcc/models/models.dart';
import 'package:hr_tcc/presentation/blocs/blocs.dart';
import 'package:hr_tcc/presentation/pages/news_list_page/components/components.dart';
import 'package:hr_tcc/presentation/pages/news_section_widget/components/components.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';

class NewsListPage extends StatefulWidget {
  const NewsListPage({super.key});

  @override
  State<NewsListPage> createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<NewsListBloc>().add(LoadMoreNewsList());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsListBloc, NewsListState>(
      builder: (context, state) {
        final selectedCategory = _getSelectedCategory(state);

        return Scaffold(
          backgroundColor: AppColors.gray200,
          appBar: const AppNavigationBar(title: 'Новости'),
          body: Column(
            children: [
              _buildSearchField(),
              _buildCategorySelector(selectedCategory),
              Expanded(child: _buildNewsList()),
            ],
          ),
        );
      },
    );
  }

  NewsCategory _getSelectedCategory(NewsListState state) {
    if (state is NewsListLoaded) return state.selectedCategory;
    if (state is NewsListLoadingInProgress) return state.selectedCategory;
    return NewsCategory.all;
  }

  Widget _buildSearchField() {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        height: 40,
        child: AppSearchField(
          hint: 'Поиск',
          onChanged: (query) {
            context.read<NewsListBloc>().add(SearchQueryChangedNewsList(query));
          },
        ),
      ),
    );
  }

  Widget _buildCategorySelector(NewsCategory selectedCategory) {
    return GestureDetector(
      onTap: () {
        appShowModularSheet(
          context: context,
          title: 'Выберите категорию',
          titleStyle: AppTypography.title3Bold,
          content: SelectionRadioListContent<NewsCategory>(
            textStyle: AppTypography.text1Medium,
            items: NewsCategory.values,
            selectedValue: selectedCategory,
            onSelected:
                (val) => context.read<NewsListBloc>().add(
                  ChangeCategoryNewsList(val),
                ),
            itemLabelBuilder: (c) => c.title,
            itemPaddingVertical: 14,
            modalBackgroundColor: AppColors.white,
          ),
        );
      },
      child: Container(
        color: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            BlocSelector<NewsListBloc, NewsListState, NewsCategory>(
              selector: _getSelectedCategory,
              builder:
                  (context, selectedCategory) => Text(
                    selectedCategory.title,
                    style: AppTypography.text2Regular,
                  ),
            ),
            SvgPicture.asset(
              Assets.icons.news.newsCategoriesSelector.path,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsList() {
    return BlocBuilder<NewsListBloc, NewsListState>(
      builder: (context, state) {
        if (state is NewsListLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is NewsListLoaded) {
          final groupedNews = context.read<NewsListBloc>().groupNews(
            state.news,
          );

          if (groupedNews.isEmpty) {
            return Center(
              child: Text(
                'Новости не найдены',
                style: AppTypography.text1Regular.copyWith(
                  color: AppColors.gray700,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: groupedNews.length + (state.hasReachedMax ? 0 : 1),
            itemBuilder: (context, index) {
              if (index >= groupedNews.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final groupTitle = groupedNews.keys.elementAt(index);
              final groupItems = groupedNews[groupTitle];

              return VerticalSection(
                title: groupTitle,
                cards:
                    groupItems?.map((card) => _buildNewsCard(card)).toList() ??
                    [],
              );
            },
          );
        } else if (state is NewsListError) {
          return Center(child: Text(state.message));
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildNewsCard(NewsCardModel card) {
    return GestureDetector(
      onTap: () {
        // BlocFactory.createNewsPageBloc()..add(LoadNewsPage())
        // NewsPage()
      },
      child: AppInfoCard(
        color: AppColors.white,
        shadowColor: AppColors.cardShadowColor,
        children: [NewsContentCard(model: card)],
      ),
    );
  }
}
