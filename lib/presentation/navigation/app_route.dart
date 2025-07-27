enum AppRoute {
  absenceRequestCreate('/absence-request/create'),
  absenceRequestView('/absence-request/:id'),
  addressBook('/address-book'),
  alpinaRequestCreate('/alpina-request/create'),
  alpinaRequestView('/alpina-request/:id'),
  benefitContent('/benefit-content'),
  benefits('/benefits'),
  benefitsCategory('/benefits/:category'),
  biometricAuth('/biometric-auth/:type'),
  businessTripRequestCreate('/business-trip-request/create'),
  businessTripRequestView('/business-trip-request/:id'),
  chat('/chat'),
  courierRequestCreate('/courier-request/create'),
  courierRequestView('/courier-request/:id'),
  dpoRequestCreate('/dpo-request/create'),
  dpoRequestView('/dpo-request/:id'),
  home('/'),
  internalTrainingRequestCreate('/internal-training-request/create'),
  internalTrainingRequestView('/internal-training-request/:id'),
  login('/login'),
  newRequest('/new-request'),
  news('/news'),
  parkingRequestCreate('/parking-request/create'),
  parkingRequestView('/parking-request/:id'),
  passRequestCreate('/pass-request/create'),
  passRequestView('/pass-request/:id'),
  pincodeLogin('/pincode-login'),
  pincodeSetup('/pincode-setup'),
  pollDetail('/poll-detail/:id'),
  polls('/polls'),
  quickLinks('/quick-links'),
  referralProgramRequestCreate('/referral-program-request/create'),
  referralProgramRequestView('/referral-program-request/:id'),
  resaleDetail('/resale-detail'),
  resaleList('/resale-list'),
  twoNdflRequestCreate('/two-ndfl-request/create'),
  twoNdflRequestView('/two-ndfl-request/:id'),
  unplannedTrainingRequestCreate('/unplanned-training-request/create'),
  unplannedTrainingRequestView('/unplanned-training-request/:id'),
  userKpi('/user-kpi'),
  userProfile('/user-profile'),
  violationRequestCreate('/violation-request/create'),
  violationRequestView('/violation-request/:id'),
  workBookRequestCreate('/work-book-request/create'),
  workBookRequestView('/work-book-request/:id'),
  workCertificateRequestCreate('/work-certificate-request/create'),
  workCertificateRequestView('/work-certificate-request/:id');

  final String path;

  const AppRoute(this.path);

  static String absenceRequestViewWithId(String id) {
    return '/absence-request/$id';
  }

  static String alpinaRequestViewWithId(String id) {
    return '/alpina-request/$id';
  }

  static String benefitsCategoryWithCategory(String category) {
    return '/benefits/$category';
  }

  static String biometricAuthWithType(String type) {
    return '/biometric-auth/$type';
  }

  static String businessTripRequestViewWithId(String id) {
    return '/business-trip-request/$id';
  }

  static String courierRequestViewWithId(String id) {
    return '/courier-request/$id';
  }

  static String dpoRequestViewWithId(String id) {
    return '/dpo-request/$id';
  }

  static String internalTrainingRequestViewWithId(String id) {
    return '/internal-training-request/$id';
  }

  static String parkingRequestViewWithId(String id) {
    return '/parking-request/$id';
  }

  static String passRequestViewWithId(String id) {
    return '/pass-request/$id';
  }

  static String referralProgramRequestViewWithId(String id) {
    return '/referral-program-request/$id';
  }

  static String twoNdflRequestViewWithId(String id) {
    return '/two-ndfl-request/$id';
  }

  static String unplannedTrainingRequestViewWithId(String id) {
    return '/unplanned-training-request/$id';
  }

  static String violationRequestViewWithId(String id) {
    return '/violation-request/$id';
  }

  static String workBookRequestViewWithId(String id) {
    return '/work-book-request/$id';
  }

  static String workCertificateRequestViewWithId(String id) {
    return '/work-certificate-request/$id';
  }

  static String pollDetailWithId(String id) {
    return '/poll-detail/$id';
  }
}
