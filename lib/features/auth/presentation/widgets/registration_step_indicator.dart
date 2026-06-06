import 'package:thimar/core/imports/core_imports.dart';

class RegistrationStepIndicator extends StatelessWidget {
  final int currentStep;
  final ValueChanged<int>? onStepTap;

  const RegistrationStepIndicator({
    super.key,
    this.currentStep = 1,
    this.onStepTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Step 2 (right side in RTL)
        GestureDetector(
          onTap: onStepTap != null ? () => onStepTap!(2) : null,
          child: _StepItem(
            stepNumber: 2,
            label: 'بيانات السيارة',
            isActive: currentStep >= 2,
            cs: cs,
            tt: tt,
          ),
        ),
        // Dotted line connector
        Padding(
          padding: EdgeInsets.only(bottom: 20.h),
          child: SizedBox(
            width: 80.w,
            child: CustomPaint(
              painter: _DottedLinePainter(
                color: currentStep >= 2 ? cs.primary : cs.outline,
              ),
            ),
          ),
        ),
        // Step 1 (left side in RTL)
        GestureDetector(
          onTap: onStepTap != null ? () => onStepTap!(1) : null,
          child: _StepItem(
            stepNumber: 1,
            label: 'البيانات الشخصية',
            isActive: currentStep >= 1,
            cs: cs,
            tt: tt,
          ),
        ),
      ],
    );
  }
}

class _StepItem extends StatelessWidget {
  final int stepNumber;
  final String label;
  final bool isActive;
  final ColorScheme cs;
  final TextTheme tt;

  const _StepItem({
    required this.stepNumber,
    required this.label,
    required this.isActive,
    required this.cs,
    required this.tt,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 30.r,
          height: 30.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? cs.primary : Colors.transparent,
            border: Border.all(
              color: isActive ? cs.primary : cs.outline,
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              '$stepNumber',
              style: tt.bodySmall?.copyWith(
                color: isActive ? cs.onPrimary : cs.outline,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          label,
          style: tt.bodySmall?.copyWith(
            color: isActive ? cs.primary : cs.onSurfaceVariant,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  final Color color;

  _DottedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    const dashWidth = 4.0;
    const dashSpace = 4.0;
    double startX = 0;
    final y = size.height / 2;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, y),
        Offset(startX + dashWidth, y),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DottedLinePainter oldDelegate) =>
      color != oldDelegate.color;
}
