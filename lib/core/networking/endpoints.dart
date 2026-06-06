class Endpoints {
  Endpoints._();

  static const String baseUrl = "https://thimar.amr.aait-d.com/api/";

  // Auth
  static const String login = "login";
  static const String driverRegister = "driver_register";
  static const String verify = "verify";
  static const String forgetPassword = "forget_password";
  static const String resetPassword = "reset_password";
  static const String resendCode = "resend_code";
  static const String checkCode = "check_code";
  static const String logout = "logout";

  // Products
  static const String driverSearch = "driver/search";
  static const String driverSearchCurrent = "driver/search_current";
  static const String driverPendingOrders = "driver/pending_orders";
  static const String driverFinishedOrders = "driver/finished_orders";
  static const String driverOrders = "driver/orders";

  // Driver Profile
  static const String driverProfile = "driver/profile";
  static const String editPassword = "edit_password";

  // Orders
  static const String orderDetails = "orders";

  // Driver Orders
  static const String driverCurrentOrders = "driver/current_orders";
  static const String driverRefuseOrder = "driver/refuse_order";
  static const String driverAcceptOrder = "driver/accept_order";
  static const String driverStartDelivering = "driver/start_delivering_order";
  static const String driverFinishOrder = "driver/finish_order";

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
