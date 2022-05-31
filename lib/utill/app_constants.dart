import 'package:travel_admin/data/model/response/language_model.dart';

class AppConstants {
  static const String APP_NAME = 'Haway';
  static const String VERSION = '1.0 (beta)';
  static const API_KEY = 'AIzaSyC4pqaaJrDjDxxm2iU-SIn4bDTmlBOSK70';

  static const String BASE_URL = 'https://tugasrekomendasiwisata.net';

  static const String CHECK_EMAIL_URI = '/auth/checkemail';
  static const String REGISTER_URI = '/auth/registration';
  static const String LOGIN_URI = '/auth/login';
  static const String FORGET_PASSWORD_URI = '/forget-password';
  static const String RESET_PASSWORD_URI = '/reset-password';
  static const String CATEGORY_URI = '/kategori';
  static const String LOKASI_URI = '/lokasi';
  static const String CONTENT_URI = '/content';
  static const String UPDATE_CONTENT_URI = '/content/update';
  static const String DELETE_CONTENT_URI = '/content/delete';
  static const String LIKE_URI = '/like';
  static const String FAVORIT_URI = '/favorit';

  // Shared Key
  static const String ID_USER = 'id_user';
  static const String EMAIL = 'email';
  static const String THEME = 'theme';
  static const String TOKEN = 'token';
  static const String COUNTRY_CODE = 'country_code';
  static const String LANGUAGE_CODE = 'language_code';
  static const String CART_LIST = 'cart_list';
  static const String USER_PASSWORD = 'user_password';
  static const String USER_ADDRESS = 'user_address';
  static const String USER_NUMBER = 'user_number';
  static const String SEARCH_ADDRESS = 'search_address';
  static const String TOPIC = 'notify';
  static const String MAP_API_KEY = 'AIzaSyCVc5Kq4MgnWDldO-3qmb4ojqI4qNUXq2E';

  static List<LanguageModel> languages = [
    LanguageModel(
        languageName: 'English',
        countryCode: 'US',
        languageCode: 'en'),
    LanguageModel(
        languageName: 'Indonesian',
        countryCode: 'ID',
        languageCode: 'id'),
  ];
}
