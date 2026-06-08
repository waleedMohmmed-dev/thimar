import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/faq/domain/entities/faq_entity.dart';

class FaqTile extends StatefulWidget {
  final FaqEntity faq;

  const FaqTile({super.key, required this.faq});

  @override
  State<FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<FaqTile> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late final AnimationController _iconController;
  late final Animation<double> _iconRotation;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _iconRotation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _iconController.forward();
      } else {
        _iconController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.r),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _toggle,
            borderRadius: BorderRadius.circular(15.r),
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.faq.question,
                          style: tt.bodyLarge?.copyWith(
                            color: cs.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      AnimatedBuilder(
                        animation: _iconRotation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _iconRotation.value * 3.14159,
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: cs.primary,
                              size: 24.r,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    alignment: Alignment.topCenter,
                    child: _isExpanded
                        ? Padding(
                            padding: EdgeInsets.only(top: 12.h),
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOut,
                              builder: (context, value, child) {
                                return Opacity(
                                  opacity: value,
                                  child: Transform.translate(
                                    offset: Offset(0, 8 * (1 - value)),
                                    child: child,
                                  ),
                                );
                              },
                              child: Text(
                                widget.faq.answer,
                                style: tt.bodyMedium?.copyWith(
                                  color: cs.onSurfaceVariant,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
