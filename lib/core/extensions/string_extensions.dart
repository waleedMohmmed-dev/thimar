import 'package:thimar/core/cache/cache_keys.dart';
import 'package:thimar/core/cache/cache_service.dart';
import 'package:thimar/core/injection/injection.dart';

extension StringTranslation on String {
  String tr() {
    String lang = 'ar';
    try {
      if (sl.isRegistered<HiveCacheService>()) {
        lang = sl<HiveCacheService>().get<String>(key: CacheKeys.language) ?? 'ar';
      }
    } catch (_) {}

    if (lang == 'en') {
      final translations = {
        // Bottom Navigation Bar
        'nav_home': 'Home',
        'nav_orders': 'My Orders',
        'nav_notifications': 'Notifications',
        'nav_favorites': 'Favorites',
        'nav_account': 'My Account',
        
        // Orders Tab
        'current_orders': 'Current Orders',
        'finished_orders': 'Finished Orders',
        'current': 'Current Orders',
        'finished': 'Finished Orders',
        
        // Profile Tab
        'personal_data': 'Personal Data',
        'car_data': 'Vehicle Data',
        
        // Menu Items
        'wallet': 'Wallet',
        'profile': 'Profile',
        'about_app': 'About Thimar',
        'faqs': 'FAQs',
        'privacy_policy': 'Privacy Policy',
        'contact_us': 'Contact Us',
        'report_issue': 'Report an Issue',
        'language': 'Language',
        'logout': 'Logout',

        // Onboarding
        'welcome_title': 'Welcome to Thimar',
        'welcome_subtitle': 'Choose the account type you want to create',
        'user': 'Client',
        'driver': 'Driver',
        'continue': 'Continue',

        // Profile Form
        'name': 'Name',
        'city': 'City',
        'old_password': 'Old Password',
        'new_password': 'New Password',
        'edit_profile': 'Edit Profile',
        'required_documents': 'Required Documents',
        'driver_license': 'Driver\'s License Image',
        'car_registration': 'Vehicle Registration',
        'car_insurance': 'Vehicle Insurance',
        'car_front': 'Vehicle Front Image',
        'car_rear': 'Vehicle Rear Image',
        'vehicle_type': 'Vehicle Type',

        // Order & Payment
        'mastercard': 'Mastercard',
        'visa': 'Visa',
        'cash': 'Cash',
        'payment_method': 'Payment Method',
        'order_details': 'Order Details',
        'january': 'January',
        'february': 'February',
        'march': 'March',
        'april': 'April',
        'may': 'May',
        'june': 'June',
        'july': 'July',
        'august': 'August',
        'september': 'September',
        'october': 'October',
        'november': 'November',
        'december': 'December',
        'am': 'AM',
        'pm': 'PM',
        'address': 'Address',
        'phone': 'Phone Number',
        'email': 'Email',
        'terms_and_conditions': 'Terms & Conditions',
        
        // General
        'retry': 'Retry',
        'error': 'An error occurred',

        // Notifications
        'notification_order_accepted_title': 'Order Accepted',
        'notification_order_accepted_body': 'Your order has been accepted and is being prepared.',
        'notification_time_1_minute': '1 min ago',
        'notification_order_on_way_title': 'Order on the Way',
        'notification_order_on_way_body': 'Your order is now with the driver and on the way.',
        'notification_time_30_minutes': '30 mins ago',
        'notification_order_delivered_title': 'Order Delivered',
        'notification_order_delivered_body': 'Your order has been delivered successfully. Thank you!',
        'notification_time_2_hours': '2 hours ago',
        'notification_admin_title': 'Security Update',
        'notification_admin_body': 'Please update your password to ensure account security.',
        'notification_time_yesterday': 'Yesterday',
        'notification_offers_title': 'Special Offer!',
        'notification_offers_body': 'Get up to 50% off on fresh produce today.',
        'notification_time_3_days': '3 days ago',

        // Features
        'feature_fast_delivery': 'Fast Delivery',
        'feature_fast_delivery_desc': 'Get your orders delivered to your doorstep in no time.',
        'feature_fresh_products': 'Fresh Products',
        'feature_fresh_products_desc': 'We select fresh produce directly from trusted local farms.',
        'feature_flexible_payment': 'Flexible Payment',
        'feature_flexible_payment_desc': 'Multiple secure payment options, including cash, card, and digital wallet.',
        'feature_product_rating': 'Product Rating',
        'feature_product_rating_desc': 'Rate products and read reviews from other customers.',
        'feature_digital_wallet': 'Digital Wallet',
        'feature_digital_wallet_desc': 'Keep funds in your in-app wallet for fast checkout.',
        'feature_multiple_addresses': 'Multiple Addresses',
        'feature_multiple_addresses_desc': 'Save and manage multiple delivery locations.',
      };
      return translations[this] ?? this;
    }

    final translations = {
      // Bottom Navigation Bar
      'nav_home': 'الرئيسية',
      'nav_orders': 'طلباتي',
      'nav_notifications': 'التنبيهات',
      'nav_favorites': 'المفضلة',
      'nav_account': 'حسابي',
      
      // Orders Tab
      'current_orders': 'الطلبات الحالية',
      'finished_orders': 'الطلبات المنتهية',
      'current': 'الطلبات الحالية',
      'finished': 'الطلبات المنتهية',
      
      // Profile Tab
      'personal_data': 'البيانات الشخصية',
      'car_data': 'بيانات السيارة',

      // Menu Items
      'wallet': 'المحفظة',
      'profile': 'الملف الشخصي',
      'about_app': 'عن التمار',
      'faqs': 'الأسئلة الشائعة',
      'privacy_policy': 'سياسة الخصوصية',
      'contact_us': 'تواصل معنا',
      'report_issue': 'الإبلاغ عن مشكلة',
      'language': 'اللغة',
      'logout': 'تسجيل الخروج',

      // Onboarding
      'welcome_title': 'مرحباً بك في ثمار',
      'welcome_subtitle': 'اختر نوع الحساب الذي تريد إنشاءه',
      'user': 'مستخدم',
      'driver': 'سائق',
      'continue': 'متابعة',

      // Profile Form
      'name': 'الاسم',
      'city': 'المدينة',
      'old_password': 'كلمة المرور القديمة',
      'new_password': 'كلمة المرور الجديدة',
      'edit_profile': 'تعديل البيانات',
      'required_documents': 'المستندات المطلوبة',
      'driver_license': 'صورة رخصة القيادة',
      'car_registration': 'استمارة السيارة',
      'car_insurance': 'تأمين السيارة',
      'car_front': 'السيارة من الأمام',
      'car_rear': 'السيارة من الخلف',
      'vehicle_type': 'نوع السيارة',

      // Order & Payment
      'mastercard': 'ماستركارد',
      'visa': 'فيزا',
      'cash': 'نقدي',
      'payment_method': 'طريقة الدفع',
      'order_details': 'تفاصيل الطلب',
      'january': 'يناير',
      'february': 'فبراير',
      'march': 'مارس',
      'april': 'أبريل',
      'may': 'مايو',
      'june': 'يونيو',
      'july': 'يوليو',
      'august': 'أغسطس',
      'september': 'سبتمبر',
      'october': 'أكتوبر',
      'november': 'نوفمبر',
      'december': 'ديسمبر',
      'am': 'ص',
      'pm': 'م',
      'address': 'العنوان',
      'phone': 'الهاتف',
      'email': 'البريد الإلكتروني',
      'terms_and_conditions': 'الشروط والأحكام',

      // General
      'retry': 'إعادة المحاولة',
      'error': 'حدث خطأ',

      // Notifications
      'notification_order_accepted_title': 'تم قبول طلبك',
      'notification_order_accepted_body': 'تم قبول طلبك من المتجر وجاري تجهيزه الآن.',
      'notification_time_1_minute': 'منذ دقيقة',
      'notification_order_on_way_title': 'الطلب في الطريق',
      'notification_order_on_way_body': 'طلبك الآن مع المندوب وفي طريقه إليك.',
      'notification_time_30_minutes': 'منذ 30 دقيقة',
      'notification_order_delivered_title': 'تم توصيل الطلب بنجاح',
      'notification_order_delivered_body': 'تم تسليم طلبك بنجاح. شكراً لاستخدامك ثمار!',
      'notification_time_2_hours': 'منذ ساعتين',
      'notification_admin_title': 'تحديث أمان الحساب',
      'notification_admin_body': 'يرجى مراجعة وتحديث كلمة المرور الخاصة بك لضمان أمان حسابك.',
      'notification_time_yesterday': 'أمس',
      'notification_offers_title': 'عروض وخصومات حصرية!',
      'notification_offers_body': 'احصل على خصم يصل إلى 50٪ على الخضروات والفواكه الطازجة اليوم.',
      'notification_time_3_days': 'منذ 3 أيام',

      // Features
      'feature_fast_delivery': 'توصيل سريع',
      'feature_fast_delivery_desc': 'احصل على طلباتك حتى باب منزلك في أسرع وقت.',
      'feature_fresh_products': 'منتجات طازجة',
      'feature_fresh_products_desc': 'نختار لك خضار وفواكه طازجة مباشرة من المزارع.',
      'feature_flexible_payment': 'دفع مرن',
      'feature_flexible_payment_desc': 'خيارات دفع متعددة وآمنة تشمل الكاش، البطاقة، والمحفظة.',
      'feature_product_rating': 'تقييم المنتجات',
      'feature_product_rating_desc': 'يمكنك تقييم المنتجات والاطلاع على آراء بقية العملاء.',
      'feature_digital_wallet': 'المحفظة الرقمية',
      'feature_digital_wallet_desc': 'اشحن محفظتك في التطبيق لسرعة الدفع والطلب.',
      'feature_multiple_addresses': 'عناوين متعددة',
      'feature_multiple_addresses_desc': 'احفظ وعيِّن أكثر من عنوان للتوصيل بسهولة.',
    };

    return translations[this] ?? this;
  }
}
