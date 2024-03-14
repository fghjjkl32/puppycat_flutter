enum Flavor { apple, android, one }

class FlavorValues {
  FlavorValues({required this.baseUrl, required this.version, required this.name});

  final String baseUrl;
  final String version;
  final String name;
}

class FlavorConfig {
  final Flavor? flavor;
  final FlavorValues? values;
  static FlavorConfig? _instance;

  factory FlavorConfig({required Flavor flavor, required FlavorValues values}) {
    _instance ??= FlavorConfig._internal(flavor, values);
    return _instance!;
  }

  FlavorConfig._internal(this.flavor, this.values);

  static FlavorConfig get instance {
    return _instance!;
  }

  static bool isApple() => _instance!.flavor == Flavor.apple;

  static bool isAndroid() => _instance!.flavor == Flavor.android;

  static bool isOne() => _instance!.flavor == Flavor.one;
}
