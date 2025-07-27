import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hr_tcc/generated/assets.gen.dart';
import 'package:hr_tcc/presentation/pages/pages.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Обновляем состояние при смене вкладки
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildTabIcon(int index) {
    bool isSelected = _tabController.index == index;
    String iconPath;

    switch (index) {
      case 0:
        iconPath =
            isSelected
                ? Assets.icons.tabBar.tabBarHomeFilled.path
                : Assets.icons.tabBar.tabBarHome.path;
        break;
      case 1:
        iconPath =
            isSelected
                ? Assets.icons.tabBar.tabBarRequestsFilled.path
                : Assets.icons.tabBar.tabBarRequests.path;
        break;
      case 2:
        iconPath =
            isSelected
                ? Assets.icons.tabBar.tabBarMoreFilled.path
                : Assets.icons.tabBar.tabBarMore.path;
        break;
      default:
        iconPath =
            isSelected
                ? Assets.icons.tabBar.tabBarHomeFilled.path
                : Assets.icons.tabBar.tabBarHome.path;
    }

    return SvgPicture.asset(iconPath, width: 32, height: 32);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: [const HomePage(), const RequestsPage(), MorePage()],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: SizedBox(
          height: 92,
          child: TabBar(
            controller: _tabController,
            indicator: const BoxDecoration(),
            labelColor: const Color(0xFF2C447B),
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.33,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.33,
            ),
            tabs: [
              Tab(icon: _buildTabIcon(0), text: 'Главная'),
              Tab(icon: _buildTabIcon(1), text: 'Мои заявки'),
              Tab(icon: _buildTabIcon(2), text: 'Ещё'),
            ],
          ),
        ),
      ),
    );
  }
}
