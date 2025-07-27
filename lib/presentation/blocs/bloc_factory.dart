import 'package:get_it/get_it.dart';
import 'package:local_auth/local_auth.dart';

import '../../domain/entities/current_user.dart';
import '../../domain/repositories/access_token_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/current_user_repository.dart';
import '../../domain/usecases/usecases.dart';
import '../../models/models.dart';
import '../cubits/auth/auth_cubit.dart';
import '../cubits/snackbar/snackbar_cubit.dart';
import 'blocs.dart';

class BlocFactory {
  static UserProfileBloc createUserProfileBloc() {
    return UserProfileBloc(GetIt.I<LogoutUseCase>());
  }

  static UserKpiBloc createUserKpiBloc() {
    return UserKpiBloc();
  }

  static FilterBloc createFilterBloc(List<FilterTabModel> tabs) {
    return FilterBloc(tabs);
  }

  static RequestTypesBloc createRequestTypesBloc() {
    return RequestTypesBloc(
      GetIt.I<FetchRequestTypesUseCase>(),
      GetIt.I<FetchRequestTypesCountUseCase>(),
    );
  }

  static RequestsBloc createRequestsBloc() {
    return RequestsBloc(GetIt.I<FetchRequestsUseCase>());
  }

  static QuickLinksWidgetBloc createQuickLinksWidgetBloc() {
    return QuickLinksWidgetBloc();
  }

  static QuickLinksBloc createQuickLinksBloc() {
    return QuickLinksBloc();
  }

  static PollsListPageBloc createPollsListPageBloc() {
    return PollsListPageBloc(
      fetchPollsUseCase: GetIt.I<FetchPollsListUseCase>(),
    );
  }

  static AddressBookBloc createAddressBookBloc() {
    return AddressBookBloc(
      addressBookUseCase: GetIt.I<FetchAddressBookUseCase>(),
      addressBookTotalCountUseCase:
          GetIt.I<FetchAddressBookTotalCountUseCase>(),
    );
  }

  static EmployeeRewardBloc createEmployeeRewardBloc() {
    return EmployeeRewardBloc();
  }

  static PincodeSetupBloc createPincodeSetupBloc(
    String accessToken,
    CurrentUser currentUser,
  ) {
    return PincodeSetupBloc(
      GetIt.I<UpdatePincodeUseCase>(),
      GetIt.I<CurrentUserRepository>(),
      GetIt.I<AccessTokenRepository>(),
      GetIt.I<AuthRepository>(),
      accessToken,
      currentUser,
    );
  }

  static BiometricSetupBloc createBiometricSetupBloc(BiometricType type) {
    return BiometricSetupBloc(
      GetIt.I<AuthRepository>(),
      GetIt.I<LocalAuthentication>(),
      type,
    );
  }

  static LoginBloc createLoginBloc() {
    return LoginBloc(GetIt.I<LoginUseCase>(), GetIt.I<AuthCubit>());
  }

  static UserNavigationBarBloc createUserNavigationBarBloc() {
    return UserNavigationBarBloc();
  }

  static PincodeLoginBloc createPincodeLoginBloc() {
    return PincodeLoginBloc(
      GetIt.I<VerifyPinUseCase>(),
      GetIt.I<LogoutUseCase>(),
      GetIt.I<LocalAuthentication>(),
      GetIt.I<AuthRepository>(),
      GetIt.I<AuthCubit>(),
    );
  }

  static ResaleWidgetBloc createResaleWidgetBloc() {
    return ResaleWidgetBloc();
  }

  static ResaleListPageBloc createResaleListPageBloc() {
    return ResaleListPageBloc(GetIt.I<FetchResaleItemsUseCase>());
  }

  static ResaleDetailPageBloc createResaleDetailPageBloc() {
    return ResaleDetailPageBloc(
      linkContentUse: GetIt.I<FeatchLinkContentUseCase>(),
      snackBarCubit: GetIt.I<SnackBarCubit>(),
    );
  }

  static BenefitsWidgetBloc createBenefitsWidgetBloc() {
    return BenefitsWidgetBloc();
  }

  static BenefitsListCategoriesPageBloc createBenefitsListCategoriesPageBloc() {
    return BenefitsListCategoriesPageBloc();
  }

  static BenefitsListCategoryPageBloc createBenefitsListCategoryPageBloc(
    BenefitCategory category,
  ) {
    return BenefitsListCategoryPageBloc(category);
  }

  static BenefitContentBloc createBenefitContentBloc(
    FeatchLinkContentUseCase useCase,
    SnackBarCubit snackBarCubit,
  ) {
    return BenefitContentBloc(
      linkContentUse: useCase,
      snackBarCubit: snackBarCubit,
    );
  }

  static MorePageBloc createMorePageBloc() {
    return MorePageBloc();
  }

  static NewsSectionBloc createNewsSectionBloc() {
    return NewsSectionBloc();
  }

  static NewsListBloc createNewsListBloc() {
    return NewsListBloc(fetchNewsListUseCase: GetIt.I<FetchNewsListUseCase>());
  }

  static TwoNdflRequestBloc createTwoNdflRequestBloc() {
    return TwoNdflRequestBloc();
  }

  static TwoNdflRequestViewBloc createTwoNdflRequestViewBloc() {
    return TwoNdflRequestViewBloc(GetIt.I<FetchTwoNdflRequestDetailsUseCase>());
  }

  static WorkBookRequestBloc createWorkBookRequestBloc() =>
      WorkBookRequestBloc();

  static WorkBookRequestViewBloc createWorkBookRequestViewBloc() {
    return WorkBookRequestViewBloc(
      GetIt.I<FetchWorkBookRequestDetailsUseCase>(),
    );
  }

  static PollDetailPageBloc createPollBloc() {
    return PollDetailPageBloc(
      GetIt.I<FetchPollDetailUseCase>(),
      GetIt.I<SafePollDetailUseCase>(),
    );
  }

  static AbsenceRequestViewBloc createAbsenceRequestViewBloc() {
    return AbsenceRequestViewBloc(GetIt.I<GetAbsenceRequestUseCase>());
  }

  static BusinessTripRequestViewBloc createBusinessTripRequestViewBloc() {
    return BusinessTripRequestViewBloc(
      GetIt.I<GetBusinessTripRequestUseCase>(),
    );
  }

  static ViolationRequestBloc createViolationRequestBloc() {
    return ViolationRequestBloc(GetIt.I<SubmitViolationRequestUseCase>());
  }

  static ParkingRequestBloc createParkingRequestBloc() {
    return ParkingRequestBloc(
      GetIt.I<CreateParkingRequestUseCase>(),
      GetIt.I<GetCarBrandsUseCase>(),
    );
  }

  static ChatBloc createChatBloc() {
    return ChatBloc(
      snackBarCubit: GetIt.I<SnackBarCubit>(),
      linkContentUse: GetIt.I<FeatchLinkContentUseCase>(),
    );
  }

  static RequestsWidgetBloc createRequestsWidgetBloc() {
    return RequestsWidgetBloc();
  }

  static PollSectionBloc createPollSectionBloc() {
    return PollSectionBloc(GetIt.I<FetchPollsListUseCase>());
  }
}
