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

  // Products
  static const String products = "products";
  static const String search = "search";
  static const String sliders = "sliders";
  static const String clientFavorites = "client/products/favorites";
  static String addToFavorite(String id) =>
      "client/products/$id/add_to_favorite";
  static String removeFromFavorite(String id) =>
      "client/products/$id/remove_from_favorite";
  static String productDetails(String id) => "products/$id";
  static String productRates(String id) => "products/$id/rates";
  static String addProductRate(String id) => "client/products/$id/rate";

  // Orders
  static const String orderDetails = "orders";

  // Client Orders
  static const String clientOrders = "client/orders";
  static const String clientCurrentOrders = "client/orders/current";
  static const String clientFinishedOrders = "client/orders/finished";
  static const String clientDeliveryCost = "client/orders/delivery_cost";
  static String clientOrderDetails(String id) => "client/orders/$id";
  static String clientOrderProducts(String id) => "client/orders/$id/products";

  // Cart
  static const String cart = "client/cart";
  static String cartDeleteItem(String id) => "client/cart/delete_item/$id";
  static String cartUpdate(String id) => "client/cart/$id";
  static const String coupon = "client/cart/apply_coupon";

  // Client Profile
  static const String clientProfile = "client/profile";

  // Categories
  static const String categories = "categories";
  static String categoryProducts(String id) => "categories/$id";

  // Wallet
  static const String wallet = "wallet";
  static const String walletCharge = "wallet/charge";
  static const String walletCashout = "wallet/cashout";
  static const String walletTransactions = "wallet/get_wallet_transactions";

  // Client Addresses
  static const String clientAddresses = "client/addresses";
  static String clientAddressDetails(String id) => "client/addresses/$id";

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
