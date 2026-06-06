import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/constants/app_assets.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:thimar/features/splash/presentation/bloc/splash_event.dart';
import 'package:thimar/features/splash/presentation/bloc/splash_state.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SplashBloc>()..add(const SplashStarted()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state.isNavigating) {
            if (state.destination == SplashDestination.home) {
              context.goHome();
            } else {
              context.goRoleSelection();
            }
          }
        },
        child: const _SplashBody(),
      ),
    );
  }
}

class _SplashBody extends StatefulWidget {
  const _SplashBody();

  @override
  State<_SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<_SplashBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _logoPulse;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _textFade;
  late final Animation<double> _subtitleFade;
  late final Animation<double> _indicatorFade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..forward();

    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
      ),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.05, 0.5, curve: Curves.easeOut),
      ),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.65, curve: Curves.easeOutCubic),
      ),
    );

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.65, curve: Curves.easeOut),
      ),
    );

    _subtitleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.55, 0.75, curve: Curves.easeOut),
      ),
    );

    _indicatorFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 0.9, curve: Curves.easeOut),
      ),
    );

    _logoPulse = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeInOutSine),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.9,
            colors: [
              cs.primary.withValues(alpha: 0.07),
              cs.surface,
            ],
          ),
        ),
        child: Column(
          children: [
            const Spacer(flex: 3),
            _buildLogoSection(cs),
            SizedBox(height: 28.h),
            _buildBrandText(cs),
            SizedBox(height: 8.h),
            _buildSubtitle(cs),
            const Spacer(flex: 4),
            _buildFooter(cs),
            SizedBox(height: 48.h),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoSection(ColorScheme cs) {
    return FadeTransition(
      opacity: _logoFade,
      child: ScaleTransition(
        scale: _logoScale,
        child: AnimatedBuilder(
          animation: _logoPulse,
          builder: (context, child) => Transform.scale(
            scale: _logoPulse.value,
            child: child,
          ),
          child: Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: cs.primary.withValues(alpha: 0.2),
                  blurRadius: 40.r,
                  spreadRadius: 2.r,
                ),
                BoxShadow(
                  color: cs.primary.withValues(alpha: 0.1),
                  blurRadius: 80.r,
                  spreadRadius: 6.r,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                AppAssets.logo,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandText(ColorScheme cs) {
    return SlideTransition(
      position: _textSlide,
      child: FadeTransition(
        opacity: _textFade,
        child: Column(
          children: [
            Text(
              'تمار',
              style: context.textTheme.headlineMedium?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.bold,
                fontSize: 36.sp,
                letterSpacing: 2,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubtitle(ColorScheme cs) {
    return FadeTransition(
      opacity: _subtitleFade,
      child: Text(
        'خضار وفواكه طازجة',
        style: context.textTheme.bodyLarge?.copyWith(
          color: cs.onSurface.withValues(alpha: 0.55),
          fontSize: 14.sp,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildFooter(ColorScheme cs) {
    return FadeTransition(
      opacity: _indicatorFade,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24.r,
            height: 24.r,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'version 1.0.0',
            style: context.textTheme.bodySmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.3),
              fontSize: 11.sp,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
