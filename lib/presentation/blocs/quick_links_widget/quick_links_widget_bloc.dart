import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/generated/assets.gen.dart';
import 'package:hr_tcc/models/models.dart';
import 'package:url_launcher/url_launcher.dart';

part 'quick_links_widget_event.dart';
part 'quick_links_widget_state.dart';

class QuickLinksWidgetBloc
    extends Bloc<QuickLinksWidgetEvent, QuickLinksWidgetState> {
  QuickLinksWidgetBloc() : super(QuickLinksWidgetInitial()) {
    on<LoadQuickWidgetLinks>(_onLoadQuickLinks);
    on<QuickLinksWidgetOpenLink>(_onLinkClicked);
  }

  Future<void> _onLoadQuickLinks(
    LoadQuickWidgetLinks event,
    Emitter<QuickLinksWidgetState> emit,
  ) async {
    final mockGroups = [
      QuickLinkModel(
        title: 'Телеграм-\nканал S8',
        subtitle: '',
        icon: Assets.icons.quickLinksWidget.quickLinksWidgetTelegram.path,
        url: 'https://t.me/s8_tccenter',
        backgroundColor: AppColors.quickLinksTelegramBackgroundColor,
      ),
      QuickLinkModel(
        title: 'Ispring',
        subtitle: '',
        icon: Assets.icons.quickLinksWidget.quickLinksWidgetIspring.path,
        url: 'https://ispring.ru',
        backgroundColor: AppColors.quickLinksIspringBackgroundColor,
      ),
      QuickLinkModel(
        title: 'Potok',
        subtitle: '',
        icon: Assets.icons.quickLinksWidget.quickLinksWidgetPodok.path,
        url: 'https://potok.io',
        backgroundColor: AppColors.quickLinksPotokBackgroundColor,
      ),
      QuickLinkModel(
        title: 'Confluence',
        subtitle: '',
        icon: Assets.icons.quickLinksWidget.quickLinksWidgetConfluence.path,
        url: 'https://confluence.tccenter.com',
        backgroundColor: AppColors.quickLinksConfluenceJiraBackgroundColor,
      ),
      QuickLinkModel(
        title: 'Jira',
        subtitle: '',
        icon: Assets.icons.quickLinksWidget.quickLinksWidgetJira.path,
        url: 'https://jira.tccenter.com',
        backgroundColor: AppColors.quickLinksConfluenceJiraBackgroundColor,
      ),
    ];

    emit(QuickLinksWidgetLoaded(links: mockGroups));
  }

  Future<void> _onLinkClicked(
    QuickLinksWidgetOpenLink event,
    Emitter<QuickLinksWidgetState> emit,
  ) async {
    final uri = Uri.parse(event.link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch ${event.link}';
    }
  }
}
