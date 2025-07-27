import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/generated/assets.gen.dart';
import 'package:hr_tcc/models/models.dart';
import 'package:url_launcher/url_launcher.dart';

part 'quick_links_event.dart';
part 'quick_links_state.dart';

class QuickLinksBloc extends Bloc<QuickLinksEvent, QuickLinksState> {
  QuickLinksBloc() : super(QuickLinksInitial()) {
    on<LoadQuickLinks>((event, emit) => emit(QuickLinksLoaded(_defaultLinks)));
    on<QuickLinkClicked>(_onLinkClicked);
  }

  // MOK
  static final _defaultLinks = <QuickLinkModel>[
    QuickLinkModel(
      title: 'Potok',
      subtitle: 'Автоматизация рекрутинга',
      icon: Assets.icons.quickLinks.quickLinksPotok.path,
      url: 'https://potok.io',
    ),
    QuickLinkModel(
      title: 'Jira',
      subtitle: 'Диспетчер задач (управление проектами)',
      icon: Assets.icons.quickLinks.quickLinksJira.path,
      url: 'https://jira.tccenter.com',
    ),
    QuickLinkModel(
      title: 'Confluence',
      subtitle: 'Совместная работа с документами',
      icon: Assets.icons.quickLinks.quickLinksConfluence.path,
      url: 'https://confluence.tccenter.com',
    ),
    QuickLinkModel(
      title: 'Ispring',
      subtitle: 'Дистанционное обучение организаций',
      icon: Assets.icons.quickLinks.quickLinksIspring.path,
      url: 'https://ispring.ru',
    ),
    QuickLinkModel(
      title: 'Telegram',
      subtitle: 'Телеграм‑канал S8',
      icon: Assets.icons.quickLinks.quickLinksTelegram.path,
      url: 'https://t.me/s8_tccenter',
    ),
    const QuickLinkModel(
      title: 'PrimeZone',
      subtitle: 'Корпоративные скидки',
      url: 'https://primezone.tccenter.com',
    ),
    const QuickLinkModel(
      title: 'AXO‑бот',
      subtitle: 'Бот‑помощник',
      url: 'https://axo-bot.tccenter.com',
    ),
  ];

  Future<void> _onLinkClicked(
    QuickLinkClicked event,
    Emitter<QuickLinksState> emit,
  ) async {
    final uri = Uri.parse(event.link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch ${event.link}';
    }
  }
}
