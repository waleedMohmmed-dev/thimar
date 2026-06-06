class Endpoints {
  Endpoints._();

  static const String baseUrl = "https://thimar.amr.aait-d.com/api/";

  // Auth
  static const String login = "login";
  static const String verify = "verify";
  static const String forgetPassword = "forget_password";
  static const String resetPassword = "reset_password";
  static const String resendCode = "resend_code";
  static const String checkCode = "check_code";
  static const String logout = "logout";

  static const String editPassword = "edit_password";

  // Orders
  static const String orderDetails = "orders";

  // Helpers
  static const String notifications = "notifications";
  static const String policy = "policy";
  static const String about = "about";
  static const String terms = "terms";
  static const String faqs = "faqs";
  static const String contact = "contact";
  static const String cities = "cities";
  static const String carModels = "car_models";
  static const String deleteAccount = "delete_account";
}
