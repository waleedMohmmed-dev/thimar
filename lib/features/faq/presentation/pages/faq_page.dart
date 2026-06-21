import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/features/faq/domain/entities/faq_entity.dart';
import 'package:thimar/features/faq/presentation/bloc/faq_bloc.dart';
import 'package:thimar/features/faq/presentation/bloc/faq_event.dart';
import 'package:thimar/features/faq/presentation/bloc/faq_state.dart';
import 'package:thimar/features/faq/presentation/widgets/faq_tile.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FaqBloc>()..add(const FaqFetched()),
      child: const _FaqView(),
    );
  }
}

class _FaqView extends StatelessWidget {
  const _FaqView();

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'الأسئلة الشائعة',
          style: tt.titleLarge?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const AppBackButton(),
      ),
      body: BlocBuilder<FaqBloc, FaqState>(
        buildWhen: (prev, curr) =>
            prev.isLoading != curr.isLoading ||
            prev.faqs != curr.faqs ||
            prev.errorMessage != curr.errorMessage,
        builder: (context, state) {
          if (state.isLoading) {
            return const AppLoading();
          }

          if (state.errorMessage != null) {
            return AppError(
              message: state.errorMessage!,
              onRetry: () {
                context.read<FaqBloc>().add(const FaqFetched());
              },
            );
          }

          if (state.faqs.isEmpty) {
            return _buildDefaultFaqs(tt, cs);
          }

          final allFaqs = [
            ...state.faqs,
            ..._defaultFaqs.where(
              (d) => !state.faqs.any((f) => f.question == d.question),
            ),
          ];

          return ListView.separated(
            padding: EdgeInsets.all(16.w),
            itemCount: allFaqs.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              return FaqTile(faq: allFaqs[index]);
            },
          );
        },
      ),
    );
  }
}

final List<FaqEntity> _defaultFaqs = [
  const FaqEntity(
    id: '1',
    question: 'كيف يمكنني إنشاء حساب جديد؟',
    answer:
        'يمكنك إنشاء حساب جديد من خلال فتح التطبيق والضغط على "إنشاء حساب" ثم إدخال بياناتك الشخصية مثل الاسم ورقم الهاتف وكلمة المرور، ثم التحقق من رقم الهاتف عبر رمز التحقق.',
  ),
  const FaqEntity(
    id: '2',
    question: 'كيف أطلب منتجات من التطبيق؟',
    answer:
        'بعد تسجيل الدخول، تصفح الفئات واختر المنتجات التي تريدها واضغط على "أضف إلى السلة". اختر العنوان والوقت المناسب للتوصيل، ثم اختر طريقة الدفع وأكمل الطلب.',
  ),
  const FaqEntity(
    id: '3',
    question: 'ما هي طرق الدفع المتاحة؟',
    answer:
        'نوفر عدة خيارات للدفع: الدفع عند الاستلام (كاش)، بطاقات الائتمان (فيزا ومستركارد)، بالإضافة إلى المحفظة الرقمية داخل التطبيق.',
  ),
  const FaqEntity(
    id: '4',
    question: 'هل يمكنني تعديل أو إلغاء الطلب بعد تأكيده؟',
    answer:
        'يمكنك إلغاء الطلب طالما لم يتم تجهيزه بعد. بعد تأكيد الطلب من قبل المتجر، يمكنك متابعة حالته من صفحة الطلبات. للتعديل يرجى التواصل مع خدمة العملاء.',
  ),
  const FaqEntity(
    id: '5',
    question: 'كيف أشحن محفظتي الرقمية؟',
    answer:
        'اذهب إلى صفحة المحفظة واضغط على "شحن المحفظة"، أدخل المبلغ ورقم العملية ثم اضغط "ادفع". سيتم شحن محفظتك فوراً.',
  ),
  const FaqEntity(
    id: '6',
    question: 'كم يستغرق التوصيل؟',
    answer:
        'يتم التوصيل عادةً خلال 30-60 دقيقة حسب المنطقة والطلب. يمكنك تتبع حالة طلبك لحظة بلحظة من داخل التطبيق.',
  ),
  const FaqEntity(
    id: '7',
    question: 'هل التوصيل مجاني؟',
    answer:
        'نوفر توصيلاً مجانيًا على الطلبات التي تتجاوز الحد الأدنى المطلوب. رسوم التوصيل تظهر عند إتمام الطلب قبل التأكيد.',
  ),
  const FaqEntity(
    id: '8',
    question: 'كيف أضيف عنوان توصيل جديد؟',
    answer:
        'من صفحة إتمام الطلب، اضغط على "+" لإضافة عنوان جديد. أدخل العنوان واختر الموقع على الخريطة، ثم احفظ العنوان وسيتم استخدامه في طلباتك القادمة.',
  ),
  const FaqEntity(
    id: '9',
    question: 'كيف أتواصل مع خدمة العملاء؟',
    answer:
        'يمكنك التواصل معنا من خلال صفحة "تواصل معنا" في الإعدادات، أو عبر البريد الإلكتروني أو رقم الهاتف الموحد المتوفر في صفحة حول التطبيق.',
  ),
  const FaqEntity(
    id: '10',
    question: 'هل بياناتي آمنة في التطبيق؟',
    answer:
        'نعم، نحن نحرص على حماية بياناتك الشخصية باستخدام أحدث تقنيات الأمان والتشفير. لا نشارك بياناتك مع أي طرف ثالث.',
  ),
];

Widget _buildDefaultFaqs(TextTheme tt, ColorScheme cs) {
  return ListView.separated(
    padding: EdgeInsets.all(16.w),
    itemCount: _defaultFaqs.length,
    separatorBuilder: (context, index) => SizedBox(height: 16.h),
    itemBuilder: (context, index) {
      return FaqTile(faq: _defaultFaqs[index]);
    },
  );
}
