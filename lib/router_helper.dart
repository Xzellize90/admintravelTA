import 'package:fluro/fluro.dart';
import 'package:travel_admin/utill/routes.dart';
import 'package:travel_admin/view/screens/login_screen_email.dart';
import 'package:travel_admin/view/screens/signup_screen.dart';
import 'package:travel_admin/view/screens/dashboard_screen.dart';

class RouterHelper {
  static final FluroRouter router = FluroRouter();

  static Handler _loginEmailHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          LoginScreenEmail());
  static Handler _signupHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) => SignupScreen());
  static Handler _deshboardHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) => DashboardScreen(
            pageIndex: 0,
          ));
  static Handler _dashScreenBoardHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return DashboardScreen(
      pageIndex: params['page'][0] == 'add'
          ? 0
          : params['page'][0] == 'list'
              ? 1
              : 0,
    );
  });

  static void setupRouter() {
    router.define(Routes.SIGNUP_SCREEN,
        handler: _signupHandler, transitionType: TransitionType.inFromRight);
    router.define(Routes.LOGIN_SCREEN,
        handler: _loginEmailHandler,
        transitionType: TransitionType.inFromRight);
    router.define(Routes.DASHBOARD,
        handler: _deshboardHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.DASHBOARD_SCREEN,
        handler: _dashScreenBoardHandler,
        transitionType: TransitionType.fadeIn); // ?page=home
  }
}
