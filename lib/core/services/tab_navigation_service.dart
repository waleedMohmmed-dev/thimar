import 'package:flutter/foundation.dart';

class TabNavigationService {
  static final pendingTabIndex = ValueNotifier<int?>(null);

  static void navigateToTab(int index) {
    pendingTabIndex.value = index;
  }
}
