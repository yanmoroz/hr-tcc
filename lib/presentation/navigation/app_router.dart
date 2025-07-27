import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_tcc/domain/usecases/usecases.dart';

import '../../data/extensions/biometric_type_extension.dart';
import '../../domain/entities/current_user.dart';
import '../../domain/repositories/pincode_repository.dart';
import '../../models/benefits_list_categories_model.dart';
import '../blocs/blocs.dart';
import '../cubits/auth/auth_cubit.dart';
import '../cubits/cubit_factory.dart';
import '../cubits/snackbar/snackbar_cubit.dart';
import '../pages/pages.dart';
import 'app_route.dart';
import 'go_router_refresh_stream.dart';

class AppRouter {
  final PincodeRepository _pincodeRepository;

  AppRouter(this._pincodeRepository);

  Future<GoRouter> createRouter(AuthCubit authCubit) async {
    return GoRouter(
      refreshListenable: GoRouterRefreshStream(authCubit.stream),
      redirect: _redirectHandler(authCubit),
      routes: _createRoutes(),
      initialLocation: await _getInitialLocation(),
    );
  }

  static String? Function(BuildContext, GoRouterState) _redirectHandler(
    AuthCubit authCubit,
  ) {
    return (context, state) {
      final status = authCubit.state.status;

      if (status == AuthStatus.pincode) {
        return AppRoute.pincodeLogin.path;
      } else if (status == AuthStatus.unauthenticated) {
        return AppRoute.login.path;
      }

      return null;
    };
  }

  static List<RouteBase> _createRoutes() {
    return [
      _createHomeRoute(),
      _createLoginRoute(),
      _createPincodeSetupRoute(),
      _createPincodeLoginRoute(),
      _createBiometricAuthRoute(),
      _createQuickLinksRoute(),
      _createResaleListRoute(),
      _createResaleDetailRoute(),
      _createPollsRoute(),
      _createNewsRoute(),
      _createBenefitsRoute(),
      _createBenefitsCategoryRoute(),
      _createBenefitContentRoute(),
      _createAddressBookRoute(),
      _createUserKpiRoute(),
      _createUserProfileRoute(),
      _createNewRequestRoute(),
      _createCourierRequestCreateRoute(),
      _createCourierRequestViewRoute(),
      _createAbsenceRequestCreateRoute(),
      _createAbsenceRequestViewRoute(),
      _createAlpinaRequestCreateRoute(),
      _createAlpinaRequestViewRoute(),
      _createWorkCertificateRequestCreateRoute(),
      _createWorkCertificateRequestViewRoute(),
      _createViolationRequestCreateRoute(),
      _createViolationRequestViewRoute(),
      _createReferralProgramRequestCreateRoute(),
      _createReferralProgramRequestViewRoute(),
      _createTwoNdflRequestCreateRoute(),
      _createTwoNdflRequestViewRoute(),
      _createPassRequestCreateRoute(),
      _createPassRequestViewRoute(),
      _createParkingRequestCreateRoute(),
      _createParkingRequestViewRoute(),
      _createBusinessTripRequestCreateRoute(),
      _createBusinessTripRequestViewRoute(),
      _createUnplannedTrainingRequestCreateRoute(),
      _createUnplannedTrainingRequestViewRoute(),
      _createWorkBookRequestCreateRoute(),
      _createWorkBookRequestViewRoute(),
      _createChatRoute(),
      _createPollDetailRoute(),
    ];
  }

  static GoRoute _createHomeRoute() {
    return GoRoute(
      path: AppRoute.home.path,
      pageBuilder:
          (context, state) => const NoTransitionPage(child: MainPage()),
    );
  }

  static GoRoute _createLoginRoute() {
    return GoRoute(
      path: AppRoute.login.path,
      pageBuilder:
          (context, state) => NoTransitionPage(
            child: BlocProvider(
              create: (context) => BlocFactory.createLoginBloc(),
              child: const LoginPage(),
            ),
          ),
    );
  }

  static GoRoute _createPincodeSetupRoute() {
    return GoRoute(
      path: AppRoute.pincodeSetup.path,
      builder:
          (context, state) => BlocProvider(
            create: (context) {
              final extra = state.extra as Map<String, dynamic>;
              return BlocFactory.createPincodeSetupBloc(
                extra['accessToken'] as String,
                extra['currentUser'] as CurrentUser,
              );
            },
            child: const PincodeSetupPage(),
          ),
    );
  }

  static GoRoute _createPincodeLoginRoute() {
    return GoRoute(
      path: AppRoute.pincodeLogin.path,
      builder:
          (context, state) => BlocProvider(
            create: (context) => BlocFactory.createPincodeLoginBloc(),
            child: const PincodeLoginPage(),
          ),
    );
  }

  static GoRoute _createBiometricAuthRoute() {
    return GoRoute(
      path: AppRoute.biometricAuth.path,
      pageBuilder: (context, state) {
        final type = BiometricTypeExtension.fromString(
          state.pathParameters['type']!,
        );

        return NoTransitionPage(
          child: BlocProvider(
            create: (context) => BlocFactory.createBiometricSetupBloc(type),
            child: BiometricSetupPage(type: type),
          ),
        );
      },
    );
  }

  static GoRoute _createQuickLinksRoute() {
    return GoRoute(
      path: AppRoute.quickLinks.path,
      builder:
          (context, state) => BlocProvider(
            create:
                (context) =>
                    BlocFactory.createQuickLinksBloc()..add(LoadQuickLinks()),
            child: const QuickLinksPage(),
          ),
    );
  }

  static GoRoute _createResaleListRoute() {
    return GoRoute(
      path: AppRoute.resaleList.path,
      builder:
          (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create:
                    (_) =>
                        BlocFactory.createResaleListPageBloc()
                          ..add(LoadResaleListPage()),
              ),
              BlocProvider(create: (_) => BlocFactory.createFilterBloc([])),
            ],
            child: const ResaleListPage(),
          ),
    );
  }

  static GoRoute _createResaleDetailRoute() {
    return GoRoute(
      path: AppRoute.resaleDetail.path,
      builder:
          (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create:
                    (_) =>
                        BlocFactory.createResaleDetailPageBloc()
                          ..add(LoadResaleDetailPage()),
              ),
              BlocProvider(create: (_) => BlocFactory.createFilterBloc([])),
            ],
            child: const ResaleDetailPage(),
          ),
    );
  }

  static GoRoute _createPollsRoute() {
    return GoRoute(
      path: AppRoute.polls.path,
      builder:
          (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => BlocFactory.createFilterBloc([])),
              BlocProvider(
                create:
                    (context) =>
                        BlocFactory.createPollsListPageBloc()
                          ..add(LoadPollsListPage()),
              ),
            ],
            child: const PollsListPage(),
          ),
    );
  }

  static GoRoute _createNewsRoute() {
    return GoRoute(
      path: AppRoute.news.path,
      builder:
          (context, state) => BlocProvider(
            create:
                (context) =>
                    BlocFactory.createNewsListBloc()
                      ..add(LoadInitialNewsList()),
            child: const NewsListPage(),
          ),
    );
  }

  static GoRoute _createBenefitsRoute() {
    return GoRoute(
      path: AppRoute.benefits.path,
      builder:
          (context, state) => BlocProvider(
            create:
                (context) =>
                    BlocFactory.createBenefitsListCategoriesPageBloc()
                      ..add(LoadBenefitsListCategoriesPage()),
            child: const BenefitsListCategoriesPage(),
          ),
    );
  }

  static GoRoute _createBenefitsCategoryRoute() {
    return GoRoute(
      path: AppRoute.benefitsCategory.path,
      builder: (context, state) {
        final categoryString = state.pathParameters['category']!;
        final category = BenefitCategory.values.firstWhere(
          (c) => c.name == categoryString,
          orElse: () => BenefitCategory.voluntaryHealthInsurance,
        );

        return BlocProvider<BenefitsListCategoryPageBloc>(
          create:
              (context) =>
                  BlocFactory.createBenefitsListCategoryPageBloc(category)
                    ..add(LoadBenefitsListCategoryPage()),
          child: const BenefitsListCategoryPage(),
        );
      },
    );
  }

  static GoRoute _createBenefitContentRoute() {
    return GoRoute(
      path: AppRoute.benefitContent.path,
      builder:
          (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider<SnackBarCubit>(
                create: (_) => CubitFactory.createSnackBarCubit(),
              ),
              BlocProvider<BenefitContentBloc>(
                create:
                    (context) => BlocFactory.createBenefitContentBloc(
                      GetIt.I<FeatchLinkContentUseCase>(),
                      context.read<SnackBarCubit>(),
                    )..add(LoadBenefitContent()),
              ),
            ],
            child: const BenefitContentPage(),
          ),
    );
  }

  static GoRoute _createAddressBookRoute() {
    return GoRoute(
      path: AppRoute.addressBook.path,
      builder:
          (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider<SnackBarCubit>(
                create: (_) => CubitFactory.createSnackBarCubit(),
              ),
              BlocProvider(
                create:
                    (context) =>
                        BlocFactory.createAddressBookBloc()
                          ..add(AddressBookStarted()),
              ),
            ],
            child: const AddressBookPage(),
          ),
    );
  }

  static GoRoute _createUserKpiRoute() {
    return GoRoute(
      path: AppRoute.userKpi.path,
      builder:
          (context, state) => BlocProvider(
            create:
                (context) =>
                    BlocFactory.createUserKpiBloc()..add(LoadKpiGroups()),
            child: const UserKpiPage(),
          ),
    );
  }

  static GoRoute _createUserProfileRoute() {
    return GoRoute(
      path: AppRoute.userProfile.path,
      builder:
          (context, state) => BlocProvider(
            create:
                (context) =>
                    BlocFactory.createUserProfileBloc()..add(LoadUserProfile()),
            child: const UserProfilePage(),
          ),
    );
  }

  static GoRoute _createNewRequestRoute() {
    return GoRoute(
      path: AppRoute.newRequest.path,
      pageBuilder:
          (context, state) =>
              _createSlideFromBottomPage(child: const NewRequestPage()),
    );
  }

  static GoRoute _createCourierRequestCreateRoute() {
    return GoRoute(
      path: AppRoute.courierRequestCreate.path,
      pageBuilder:
          (context, state) => _createSlideFromBottomPage(
            child: const CourierRequestCreatePage(),
          ),
    );
  }

  static GoRoute _createCourierRequestViewRoute() {
    return GoRoute(
      path: AppRoute.courierRequestView.path,
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        return NoTransitionPage(child: CourierRequestViewPage(requestId: id));
      },
    );
  }

  static GoRoute _createAbsenceRequestCreateRoute() {
    return GoRoute(
      path: AppRoute.absenceRequestCreate.path,
      pageBuilder:
          (context, state) => _createSlideFromBottomPage(
            child: const AbsenceRequestCreatePage(),
          ),
    );
  }

  static GoRoute _createAbsenceRequestViewRoute() {
    return GoRoute(
      path: AppRoute.absenceRequestView.path,
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        return NoTransitionPage(child: AbsenceRequestViewPage(requestId: id));
      },
    );
  }

  static GoRoute _createAlpinaRequestCreateRoute() {
    return GoRoute(
      path: AppRoute.alpinaRequestCreate.path,
      pageBuilder:
          (context, state) => _createSlideFromBottomPage(
            child: const AlpinaRequestCreatePage(),
          ),
    );
  }

  static GoRoute _createAlpinaRequestViewRoute() {
    return GoRoute(
      path: AppRoute.alpinaRequestView.path,
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        return NoTransitionPage(child: AlpinaRequestViewPage(requestId: id));
      },
    );
  }

  static GoRoute _createWorkCertificateRequestCreateRoute() {
    return GoRoute(
      path: AppRoute.workCertificateRequestCreate.path,
      pageBuilder:
          (context, state) => _createSlideFromBottomPage(
            child: const WorkCertificateRequestCreatePage(),
          ),
    );
  }

  static GoRoute _createWorkCertificateRequestViewRoute() {
    return GoRoute(
      path: AppRoute.workCertificateRequestView.path,
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        return NoTransitionPage(
          child: WorkCertificateRequestViewPage(requestId: id),
        );
      },
    );
  }

  static GoRoute _createViolationRequestCreateRoute() {
    return GoRoute(
      path: AppRoute.violationRequestCreate.path,
      pageBuilder:
          (context, state) => _createSlideFromBottomPage(
            child: const ViolationRequestCreatePage(),
          ),
    );
  }

  static GoRoute _createViolationRequestViewRoute() {
    return GoRoute(
      path: AppRoute.violationRequestView.path,
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        return NoTransitionPage(child: ViolationRequestViewPage(requestId: id));
      },
    );
  }

  static GoRoute _createReferralProgramRequestCreateRoute() {
    return GoRoute(
      path: AppRoute.referralProgramRequestCreate.path,
      pageBuilder:
          (context, state) => _createSlideFromBottomPage(
            child: const ReferralProgramRequestCreatePage(),
          ),
    );
  }

  static GoRoute _createReferralProgramRequestViewRoute() {
    return GoRoute(
      path: AppRoute.referralProgramRequestView.path,
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        return NoTransitionPage(
          child: ReferralProgramRequestViewPage(requestId: id),
        );
      },
    );
  }

  static GoRoute _createTwoNdflRequestCreateRoute() {
    return GoRoute(
      path: AppRoute.twoNdflRequestCreate.path,
      pageBuilder:
          (context, state) => _createSlideFromBottomPage(
            child: const TwoNdflRequestCreatePage(),
          ),
    );
  }

  static GoRoute _createTwoNdflRequestViewRoute() {
    return GoRoute(
      path: AppRoute.twoNdflRequestView.path,
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        return NoTransitionPage(child: TwoNdflRequestViewPage(requestId: id));
      },
    );
  }

  static GoRoute _createPassRequestCreateRoute() {
    return GoRoute(
      path: AppRoute.passRequestCreate.path,
      pageBuilder:
          (context, state) =>
              _createSlideFromBottomPage(child: const PassRequestCreatePage()),
    );
  }

  static GoRoute _createPassRequestViewRoute() {
    return GoRoute(
      path: AppRoute.passRequestView.path,
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        return NoTransitionPage(child: PassRequestViewPage(requestId: id));
      },
    );
  }

  static GoRoute _createParkingRequestCreateRoute() {
    return GoRoute(
      path: AppRoute.parkingRequestCreate.path,
      pageBuilder:
          (context, state) => _createSlideFromBottomPage(
            child: const ParkingRequestCreatePage(),
          ),
    );
  }

  static GoRoute _createParkingRequestViewRoute() {
    return GoRoute(
      path: AppRoute.parkingRequestView.path,
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        return NoTransitionPage(child: ParkingRequestViewPage(requestId: id));
      },
    );
  }

  static GoRoute _createBusinessTripRequestCreateRoute() {
    return GoRoute(
      path: AppRoute.businessTripRequestCreate.path,
      pageBuilder:
          (context, state) => _createSlideFromBottomPage(
            child: const BusinessTripRequestCreatePage(),
          ),
    );
  }

  static GoRoute _createBusinessTripRequestViewRoute() {
    return GoRoute(
      path: AppRoute.businessTripRequestView.path,
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        return NoTransitionPage(
          child: BusinessTripRequestViewPage(requestId: id),
        );
      },
    );
  }

  static GoRoute _createWorkBookRequestCreateRoute() {
    return GoRoute(
      path: AppRoute.workBookRequestCreate.path,
      pageBuilder:
          (context, state) => _createSlideFromBottomPage(
            child: const WorkBookRequestCreatePage(),
          ),
    );
  }

  static GoRoute _createWorkBookRequestViewRoute() {
    return GoRoute(
      path: AppRoute.workBookRequestView.path,
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        return NoTransitionPage(child: WorkBookRequestViewPage(requestId: id));
      },
    );
  }

  static GoRoute _createUnplannedTrainingRequestCreateRoute() {
    return GoRoute(
      path: AppRoute.unplannedTrainingRequestCreate.path,
      pageBuilder:
          (context, state) => _createSlideFromBottomPage(
            child: const UnplannedTrainingRequestCreatePage(),
          ),
    );
  }

  static GoRoute _createUnplannedTrainingRequestViewRoute() {
    return GoRoute(
      path: AppRoute.unplannedTrainingRequestView.path,
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        return NoTransitionPage(
          child: UnplannedTrainingRequestViewPage(requestId: id),
        );
      },
    );
  }

  static GoRoute _createChatRoute() {
    return GoRoute(
      path: AppRoute.chat.path,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        final title = extra['title'] as String;
        final subTitle = extra['subTitle'] as String;
        return BlocProvider<ChatBloc>(
          create: (context) => BlocFactory.createChatBloc(),
          child: ChatPage(title: title, subTitle: subTitle),
        );
      },
    );
  }

  // Helper method for slide-from-bottom animation
  static CustomTransitionPage<T> _createSlideFromBottomPage<T>({
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.decelerate;

        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  Future<String> _getInitialLocation() async {
    final isPincodeSet = await _pincodeRepository.isPincodeSet();
    return isPincodeSet ? AppRoute.pincodeLogin.path : AppRoute.login.path;
  }

  static GoRoute _createPollDetailRoute() {
    return GoRoute(
      path: AppRoute.pollDetail.path,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return BlocProvider(
          create:
              (context) =>
                  BlocFactory.createPollBloc()..add(PollDetailPageStarted(id)),
          child: const PollDetailScreen(),
        );
      },
    );
  }
}
