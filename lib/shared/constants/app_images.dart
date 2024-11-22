const _svgsRoot = 'assets/svg';
const _assetsRoot = 'assets';

enum AppImages {
  //SVG

  logo('$_svgsRoot/logo.svg');

  const AppImages(this.path);

  final String path;
}
