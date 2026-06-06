import 'package:thimar/core/imports/core_imports.dart';

class AppSvg extends StatelessWidget {
  final String assetName;
  final double? width;
  final double? height;
  final Color? color;

  const AppSvg({
    super.key,
    required this.assetName,
    this.width,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      width: width,
      height: height,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      placeholderBuilder: (BuildContext context) => SizedBox(
        width: width,
        height: height,
        child: const Center(
          child: AppLoading(),
        ),
      ),
    );
  }
}
