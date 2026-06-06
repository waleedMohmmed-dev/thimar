import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/models/user_role.dart';
import 'package:thimar/features/orders/presentation/pages/orders_page.dart';

class ClientOrdersPage extends StatelessWidget {
  const ClientOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const OrdersPage(role: UserRole.client);
  }
}
