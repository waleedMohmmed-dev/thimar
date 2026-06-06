import 'package:thimar/core/imports/core_imports.dart';

class AppTextField extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool readOnly;
  final int? maxLength;
  final int maxLines;
  final int minLines;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Widget? suffixWidget;
  final VoidCallback? onSuffixTap;
  final TextAlign? textAlign;
  final TextDirection? hintTextDirection;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? style;
  final FocusNode? focusNode;
  final String? counterText;

  const AppTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.onChanged,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.readOnly = false,
    this.maxLength,
    this.maxLines = 1,
    this.minLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixWidget,
    this.onSuffixTap,
    this.textAlign,
    this.hintTextDirection,
    this.fillColor,
    this.contentPadding,
    this.style,
    this.focusNode,
    this.counterText,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: context.textTheme.bodyMedium?.copyWith(
              color: cs.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
        ],
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          onChanged: widget.onChanged,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          readOnly: widget.readOnly,
          maxLength: widget.maxLength,
          maxLines: _obscureText ? 1 : widget.maxLines,
          minLines: widget.minLines,
          textAlign: widget.textAlign ?? TextAlign.start,
          style: widget.style,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintTextDirection: widget.hintTextDirection,
            filled: widget.fillColor != null,
            fillColor: widget.fillColor,
            counterText: widget.counterText,
            prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon, color: cs.outline)
              : null,
            suffixIcon: widget.isPassword
              ? GestureDetector(
                  onTap: () => setState(() => _obscureText = !_obscureText),
                  child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: cs.outline,
                  ),
                )
              : widget.suffixWidget ?? (widget.suffixIcon != null
                  ? GestureDetector(
                      onTap: widget.onSuffixTap,
                      child: Icon(widget.suffixIcon, color: cs.outline),
                    )
                  : null),
            contentPadding: widget.contentPadding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: cs.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: cs.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: cs.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: cs.error),
            ),
          ),
        ),
      ],
    );
  }
}
