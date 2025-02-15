class ApiConfig {
  ApiConfig._privateConstructor() {
    _checkDateAndUpdateDomain();
  }

  static final ApiConfig _instance = ApiConfig._privateConstructor();

  factory ApiConfig() {
    return _instance;
  }

  String baseDomain = "api.dev.stadtnavi.eu";

  void _checkDateAndUpdateDomain() {
    var currentDate = DateTime.now();
    var switchDate = DateTime(2023, 12, 28);
    if (currentDate.isAfter(switchDate)) {
      baseDomain = "api.dev.stadtnavi.eu";
    }
  }

  String get openTripPlannerUrl =>
      "https://$baseDomain/routing/v1/router/index/graphql";
  String get faresURL => "https://$baseDomain/fares";
}
