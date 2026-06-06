import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:thimar/features/auth/presentation/bloc/auth_event.dart';
import 'package:thimar/features/auth/presentation/bloc/auth_state.dart';
import 'package:geolocator/geolocator.dart';

class LoginButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;
  final TextEditingController passwordController;

  const LoginButton({
    super.key,
    required this.formKey,
    required this.phoneController,
    required this.passwordController,
  });

  Future<Position?> _getCurrentPosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }
      if (permission == LocationPermission.deniedForever) return null;

      return await Geolocator.getCurrentPosition();
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AuthBloc, AuthState, bool>(
      selector: (state) => state.isLoading,
      builder: (context, isLoading) {
        return AppButton(
          label: 'تسجيل الدخول',
          size: ButtonSize.large,
          isLoading: isLoading,
          onPressed: () {
            if (formKey.currentState?.validate() ?? false) {
              _getCurrentPosition().then((position) {
                if (!context.mounted) return;
                context.read<AuthBloc>().add(
                  LoginSubmitted(
                    phone: phoneController.text.trim(),
                    password: passwordController.text,
                    lat: position?.latitude ?? 0.0,
                    lng: position?.longitude ?? 0.0,
                  ),
                );
              });
            }
          },
        );
      },
    );
  }
}
