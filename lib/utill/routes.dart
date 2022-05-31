class Routes {
  static const String LOGIN_SCREEN = '/login';
  static const String LOGIN_SCREEN_PHONE = '/login/phone';
  static const String SIGNUP_SCREEN = '/sign-up';
  static const String DASHBOARD = '/';
  static const String DASHBOARD_SCREEN = '/main';

  static String getLoginRoute() => LOGIN_SCREEN;
  static String getSignUpRoute() => SIGNUP_SCREEN;
  static String getMainRoute() => DASHBOARD;
  static String getDashboardRoute(String page) =>
      '$DASHBOARD_SCREEN?page=$page';
}
