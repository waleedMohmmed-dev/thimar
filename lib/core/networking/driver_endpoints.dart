class DriverEndpoints {
  DriverEndpoints._();

  // Products / Search
  static const String search = "driver/search";
  static const String searchCurrent = "driver/search_current";

  // Orders
  static const String orders = "driver/orders";
  static const String pendingOrders = "driver/pending_orders";
  static const String currentOrders = "driver/current_orders";
  static const String finishedOrders = "driver/finished_orders";
  static const String refuseOrder = "driver/refuse_order";
  static const String acceptOrder = "driver/accept_order";
  static const String startDelivering = "driver/start_delivering_order";
  static const String finishOrder = "driver/finish_order";

  // Auth
  static const String register = "driver_register";

  // Profile
  static const String profile = "driver/profile";
}
