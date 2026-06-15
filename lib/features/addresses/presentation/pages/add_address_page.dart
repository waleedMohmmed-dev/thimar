import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/addresses/presentation/cubit/addresses_cubit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  String _selectedType = 'home';
  late TextEditingController _phoneController;
  late TextEditingController _descriptionController;
  bool _isLoading = false;
  bool _isGettingLocation = true;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _descriptionController = TextEditingController();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _isGettingLocation = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _isGettingLocation = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _isGettingLocation = false);
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _selectedLocation = LatLng(position.latitude, position.longitude);
        _isGettingLocation = false;
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLng(_selectedLocation!),
      );
    } catch (e) {
      setState(() => _isGettingLocation = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'add_address'.tr(),
          style: tt.headlineSmall?.copyWith(
            color: cs.primary,
            fontSize: 24.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        leading: const AppBackButton(),
      ),
      body: Stack(
        children: [
          if (_selectedLocation != null)
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _selectedLocation!,
                zoom: 15,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
              },
              onCameraMove: (position) {
                _selectedLocation = position.target;
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
            )
          else if (_isGettingLocation)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: cs.primary),
                  SizedBox(height: 16.h),
                  Text(
                    'جاري تحديد الموقع...',
                    style: tt.bodyMedium?.copyWith(color: cs.outline),
                  ),
                ],
              ),
            )
          else
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_off, size: 48.sp, color: cs.outline),
                  SizedBox(height: 8.h),
                  Text(
                    'لا يمكن تحديد الموقع',
                    style: tt.bodyMedium?.copyWith(color: cs.outline),
                  ),
                ],
              ),
            ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 180.h),
                child: Icon(
                  Icons.location_pin,
                  size: 48.sp,
                  color: cs.primary,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomForm(cs, tt),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomForm(ColorScheme cs, TextTheme tt) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'نوع العنوان',
            style: tt.bodyLarge?.copyWith(
              color: cs.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: _buildTypeButton(
                  label: 'العمل',
                  isSelected: _selectedType == 'work',
                  cs: cs,
                  tt: tt,
                  onTap: () => setState(() => _selectedType = 'work'),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildTypeButton(
                  label: 'المنزل',
                  isSelected: _selectedType == 'home',
                  cs: cs,
                  tt: tt,
                  onTap: () => setState(() => _selectedType = 'home'),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          AppTextField(
            controller: _phoneController,
            labelText: 'أدخل رقم الجوال',
            hintText: '05XXXXXXXX',
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 12.h),
          AppTextField(
            controller: _descriptionController,
            labelText: 'الوصف',
            hintText: 'مثال: شقة، دور علوي...',
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            height: 56.h,
            child: _isLoading
                ? AppButton(
                    label: 'إضافة العنوان',
                    isLoading: true,
                    onPressed: () {},
                    size: ButtonSize.large,
                  )
                : AppButton(
                    label: 'إضافة العنوان',
                    onPressed: _submitAddress,
                    size: ButtonSize.large,
                  ),
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  Widget _buildTypeButton({
    required String label,
    required bool isSelected,
    required ColorScheme cs,
    required TextTheme tt,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? cs.primary : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? cs.primary : cs.outline.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: tt.bodyMedium?.copyWith(
              color: isSelected ? Colors.white : cs.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitAddress() async {
    if (_selectedLocation == null) {
      context.showErrorSnackBar('يرجى تحديد الموقع أولاً');
      return;
    }

    if (_phoneController.text.trim().isEmpty) {
      context.showErrorSnackBar('يرجى إدخال رقم الجوال');
      return;
    }

    setState(() => _isLoading = true);

    final cubit = context.read<AddressesCubit>();
    await cubit.addAddress(
      type: _selectedType,
      phone: _phoneController.text.trim(),
      description: _descriptionController.text.trim(),
      location: _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : _selectedType == 'home'
              ? 'المنزل'
              : 'العمل',
      lat: _selectedLocation!.latitude,
      lng: _selectedLocation!.longitude,
      isDefault: false,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.of(context).pop(cubit.selectedAddress);
  }
}
