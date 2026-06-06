import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/features/notifications/presentation/pages/notifications_page.dart';
import 'package:thimar/features/orders/presentation/pages/orders_page.dart';
import 'package:thimar/features/account/presentation/pages/account_page.dart';
import 'package:thimar/features/home/presentation/widgets/driver_home_tab.dart';
import 'package:thimar/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:thimar/features/orders/presentation/bloc/orders_event.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // FORCE DRIVER MODE ONLY
    return BlocProvider(
      create: (_) => sl<OrdersBloc>(),
      child: const _DriverHomeShell(),
    );
  }
}

class _DriverHomeShell extends StatefulWidget {
  const _DriverHomeShell();

  @override
  State<_DriverHomeShell> createState() => _DriverHomeShellState();
}

class _DriverHomeShellState extends State<_DriverHomeShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: const [
            DriverHomeTab(),
            OrdersPage(),
            NotificationsPage(),
            AccountPage(),
          ],
        ),
      ),
      bottomNavigationBar: AppNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          AppNavBarItem(labelKey: 'nav_home', icon: Icons.home_outlined),
          AppNavBarItem(labelKey: 'nav_orders', icon: Icons.receipt_long_outlined),
          AppNavBarItem(
            labelKey: 'nav_notifications',
            icon: Icons.notifications_none_outlined,
          ),
          AppNavBarItem(labelKey: 'nav_account', icon: Icons.person_outline),
        ],
      ),
    );
  }
}
