import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'components/components.dart';

// Обертка с прокруткой, передающая радиус углов
class MainPageWrapperWithScroll extends StatefulWidget {
  final List<Widget> children;
  final double barHeight;
  final Color backgroundColor;
  final Color backgroundColorBar;
  final double cornerRadius;

  const MainPageWrapperWithScroll({
    super.key,
    this.barHeight = 56,
    this.backgroundColor = AppColors.gray100,
    required this.backgroundColorBar,
    required this.cornerRadius,
    required this.children,
  });

  @override
  State<MainPageWrapperWithScroll> createState() =>
      _MainPageWrapperWithScrollState();
}

class _MainPageWrapperWithScrollState extends State<MainPageWrapperWithScroll> {
  final ScrollController _scrollController = ScrollController();
  bool _showRoundedCorners = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    final isScrolled = _scrollController.offset > 15;
    if (_showRoundedCorners != isScrolled) {
      setState(() {
        _showRoundedCorners = isScrolled;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double safeTop = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: Stack(
        children: [
          // Прокручиваемый контент
          SingleChildScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: widget.barHeight + safeTop),
                ...widget.children,
              ],
            ),
          ),

          // Бар с динамическими углами и настраиваемым радиусом
          UserNavigationBar(
            backgroundColor: widget.backgroundColorBar,
            height: widget.barHeight,
            rounded: _showRoundedCorners,
            cornerRadius: widget.cornerRadius,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }
}
