enum BuildFlavor { locale, dev, prod }

extension BuildFlavorName on BuildFlavor {
  String get name {
    switch (this) {
      case BuildFlavor.dev:
        return 'dev';
      case BuildFlavor.prod:
        return 'prod';
      default:
        return 'locale';
    }
  }
}
