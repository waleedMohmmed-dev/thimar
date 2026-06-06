import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/models/user_role.dart';
import 'package:thimar/core/services/role_service.dart';
import 'package:thimar/core/injection/injection.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage>
    with SingleTickerProviderStateMixin {
  UserRole? _selectedRole;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectRole(UserRole role) async {
    setState(() {
      _selectedRole = role;
    });

    final roleService = sl<RoleService>();
    await roleService.saveOnboardingRole(role);

    if (mounted) {
      if (role.isUser) {
        context.goLogin();
      } else {
        context.goDriverRegistration();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: cs.surface,
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Stack(
              children: [
                // Animated background circles
                AnimatedPositioned(
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeInOut,
                  top: -100.w,
                  left: -100.w,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      width: 300.w,
                      height: 300.w,
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.06),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(seconds: 3),
                  curve: Curves.easeInOut,
                  bottom: -80.w,
                  right: -80.w,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      width: 250.w,
                      height: 250.w,
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),

                // Main content
                SlideTransition(
                  position: _slideAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          children: [
                            SizedBox(height: 48.h),

                            // Logo
                            Container(
                              width: 100.w,
                              height: 100.w,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    cs.primary,
                                    cs.primary.withValues(alpha: 0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: cs.primary.withValues(alpha: 0.3),
                                    blurRadius: 15.w,
                                    spreadRadius: 2.w,
                                    offset: Offset(0, 6.w),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.local_shipping_outlined,
                                size: 50.w,
                                color: cs.onPrimary,
                              ),
                            ),

                            SizedBox(height: 24.h),

                            // Welcome text
                            Text(
                              'مرحبا بك في تطبيقنا',
                              style: tt.headlineSmall?.copyWith(
                                color: cs.primary,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'اختر دورك للبدء',
                              style: tt.bodyLarge?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            SizedBox(height: 32.h),

                            // Role cards
                            Expanded(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: _RoleCard(
                                      role: UserRole.driver,
                                      label: 'سائق',
                                      icon: Icons.drive_eta_outlined,
                                      isSelected: _selectedRole == UserRole.driver,
                                      cs: cs,
                                      tt: tt,
                                      onTap: () => _selectRole(UserRole.driver),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 16.h),

                            // Continue button
                            AppButton(
                              label: 'متابعة',
                              onPressed: _selectedRole != null
                                  ? () => _selectRole(_selectedRole!)
                                  : () {},
                              isDisabled: _selectedRole == null,
                              size: ButtonSize.large,
                            ),

                            SizedBox(height: 24.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final UserRole role;
  final String label;
  final IconData icon;
  final bool isSelected;
  final ColorScheme cs;
  final TextTheme tt;
  final VoidCallback onTap;

  const _RoleCard({
    required this.role,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.cs,
    required this.tt,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? cs.primary : cs.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? Colors.transparent : cs.primary.withValues(alpha: 0.3),
            width: 2.w,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isSelected ? 0.15 : 0.06),
              blurRadius: 12.w,
              offset: Offset(0, 4.w),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40.w,
                color: isSelected ? cs.onPrimary : cs.primary,
              ),
              SizedBox(height: 8.h),
              Text(
                label,
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isSelected ? cs.onPrimary : cs.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
