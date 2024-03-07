import 'package:pet_mobile_social_flutter/common/flavor_config.dart';
import 'package:pet_mobile_social_flutter/main.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.android,
    values: FlavorValues(
      baseUrl: "https://thecoder-pro.com/api/v1/",
      version: "V1.0.0-Pro",
      name: "android",
    ),
  );
  mainCommon();
}
