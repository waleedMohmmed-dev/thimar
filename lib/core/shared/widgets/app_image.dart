import 'package:thimar/core/imports/core_imports.dart';

class AppImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const AppImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isNetwork =
        imageUrl.startsWith('http') || imageUrl.startsWith('https');

    final imageWidget = isNetwork
        ? Image.network(
            imageUrl,
            width: width,
            height: height,
            fit: fit,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return SizedBox(
                width: width,
                height: height,
                child: const AppLoading(),
              );
            },
            errorBuilder: (context, error, stackTrace) =>
                _ErrorWidget(width: width, height: height),
          )
        : Image.asset(
            imageUrl,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) =>
                _ErrorWidget(width: width, height: height),
          );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }

    return imageWidget;
  }
}

class _ErrorWidget extends StatelessWidget {
  final double? width;
  final double? height;

  const _ErrorWidget({this.width, this.height});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return Container(
      width: width,
      height: height,
      color: cs.surfaceContainerHighest,
      child: Icon(
        Icons.broken_image_outlined,
        color: cs.onSurfaceVariant,
        size: (width != null && width! < 40) ? 16.r : 24.r,
      ),
    );
  }
}
